//
//  MovieDetailViewController.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 9/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

class MovieDetailViewController: UIViewController, MovieDetailViewProtocol {
    
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
        print(presenter.movie)
    }
    
    //MARK: MovieDetailViewProtocol
    func loadView(for movie: Movie) {
        configureView()
    }

}
