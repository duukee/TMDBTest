//
//  MovieDetailViewController.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 9/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import Cosmos

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    static func getConfiguredInstance() -> MovieDetailViewController {
        let viewController = MovieDetailViewController(presenter: MovieDetailPresenter())
        return viewController
    }

    var presenter: MovieDetailPresenterProtocol

	init(presenter: MovieDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: "MovieDetailViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.prepare()
    }

    func configureView() {
        titleLabel.text = presenter.movie?.title
        if let cover = presenter.movie?.resourceURI {
            let coverString = TMDBApiConstants.Endpoints.imagesURL + cover
            let coverURL: URL = URL.init(string: coverString)!
            coverImageView.af.setImage(withURL: coverURL)
        }
        ratingLabel.text = NSLocalizedString("rating", comment: "")
        ratingView.rating = presenter.movie?.voteAverage ?? 0
        ratingView.settings.updateOnTouch = false
        overviewLabel.text = NSLocalizedString("overview", comment: "")
        overviewTextView.text = presenter.movie?.overview
    }
    
    //MARK: MovieDetailViewProtocol
    func loadView(for movie: Movie) {
        configureView()
    }

}
