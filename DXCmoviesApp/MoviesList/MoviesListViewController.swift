//
//  MoviesListViewController.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 8/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import Reusable
import SwiftyGif

extension MoviesListViewController {
    enum State {
        case loading
        case ready
        case error
    }
}

class MoviesListViewController: UIViewController, MoviesListViewProtocol, NibOwnerLoadable {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var presenter: MoviesListPresenterProtocol

    
    static func getConfiguredInstance() -> MoviesListViewController {
        let viewController = MoviesListViewController(presenter: MoviesListPresenter())
        return viewController
    }

	init(presenter: MoviesListPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "MoviesListViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    func configureView() {
        configureAlertView()
        configureTableView()
    }
    
    func configureAlertView(){
        alertView.layer.shadowColor = UIColor.gray.cgColor
        alertView.layer.shadowOpacity = 0.7
        alertView.layer.shadowOffset = CGSize(width: 4, height: 4)
        alertView.layer.shadowRadius = 5.0
        alertView.layer.masksToBounds = false
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieTableViewCell.self)
        tableView.estimatedRowHeight = 160
        tableView.rowHeight = UITableView.automaticDimension
        // Add pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Movies")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func reloadData(refreshControl: UIRefreshControl){
        presenter.reloadMovies()
        refreshControl.endRefreshing()
    }
    
    // MARK: - MoviesListViewProtocol
    func updateViewState(with newState:MoviesListViewController.State) {
        state = newState
    }

    // MARK: - Alert View
    //AlertView
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var alertIcon: UIImageView!

    private var state: State = .loading {
      didSet {
        switch state {
        case .ready:
            alertView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        case .loading:
            tableView.reloadData()
            tableView.isHidden = true
            alertView.isHidden = false
            alertLabel.text = "Getting movies..."
            do {
                let loadingGif = try UIImage(gifName: "loading.gif")
                alertIcon.setGifImage(loadingGif)
            } catch {
                let loadingImage = UIImage(named: "TMDBLogo.jpg")
                alertIcon.image = loadingImage
            }

        case .error:
            tableView.isHidden = true
            alertView.isHidden = false
            alertLabel.text = "Something went wrong!\nTap to try again."
            do {
                let errorGif = try UIImage(gifName: "error.gif")
                alertIcon.setGifImage(errorGif)
            } catch {
                let errorImage = UIImage(named: "errorIcon.jpeg")
                alertIcon.image = errorImage
            }
        }
      }
    }
    
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        if state == .error {
            presenter.reloadMovies()
        }
    }
}


// MARK: - TableView Delegate
extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detailsVC: MovieDetailViewController = CharacterDetailViewController.getConfiguredInstance()
//        // TODO: Improve
//        detailsVC.character = presenter.movies[indexPath.row]
//        present(detailsVC, animated: true, completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TableView DataSource
extension MoviesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.movies.count > 0 {
            tableView.isUserInteractionEnabled = true
            return presenter.movies.count
        } else {
            tableView.isUserInteractionEnabled = false
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MovieTableViewCell.self)
        if presenter.movies.count > 0 {
            cell.set(cover: presenter.movies[indexPath.row].resourceURI, title: presenter.movies[indexPath.row].title, overview: presenter.movies[indexPath.row].overview, average: presenter.movies[indexPath.row].voteAverage)
            // load more movies when there are 10 rows left to reach the end
            if indexPath.row == presenter.movies.count - 10 {
                presenter.loadMore()
            }
        } else {
            cell.set(cover: nil, title: "NOTHING TO SHOW", overview: nil, average: 0)
        }
        return cell
    }
}
