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
        case searching
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
        presenter.prepare()
    }
        
    //MARK: View Configuration
    func configureView() {
        configureAlertView()
        configureSearcher()
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
        tableView.keyboardDismissMode = .onDrag
        // Add pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    //Pull to refresh
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
            alertLabel.text = NSLocalizedString("loading_movies", comment: "")
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
            alertLabel.text = NSLocalizedString("loading_error", comment: "")
            do {
                let errorGif = try UIImage(gifName: "error.gif")
                alertIcon.setGifImage(errorGif)
            } catch {
                let errorImage = UIImage(named: "errorIcon.jpeg")
                alertIcon.image = errorImage
            }
        case .searching:
            tableView.reloadData()
            tableView.isHidden = false
            alertView.isHidden = true
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC: MovieDetailViewController = MovieDetailViewController.getConfiguredInstance()
        detailsVC.presenter.movie = presenter.movies[indexPath.row]
        present(detailsVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
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
                if state == .ready {
                    presenter.loadMore()
                } else if state == .searching {
                    presenter.searchMore()
                }
            }
        } else {
            cell.set(cover: nil, title: NSLocalizedString("no_data", comment: ""), overview: nil, average: 0)
        }
        return cell
    }
}


extension MoviesListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func configureSearcher() {
        navigationItem.title = NSLocalizedString("title", comment: "")
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.searchController?.searchBar.placeholder = NSLocalizedString("search_placeholder", comment: "")
    }

    //MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
        /*
         * NOTE: Here we can do search char by char, but this has been avoided so as not to make many API requests.
         */
    }

    //MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            presenter.prepareForSearches()
            presenter.searchMovie(query: query)
        }
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.prepare()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.prepareForSearches()
        }
    }

    
}
