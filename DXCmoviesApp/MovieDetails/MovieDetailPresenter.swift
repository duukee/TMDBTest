//
//  MovieDetailPresenter.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 9/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: Presenter -
protocol MovieDetailPresenterProtocol: AnyObject {
	var view: MovieDetailViewProtocol? { get set }
    func prepare()
    var movie: Movie? { get set }
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {

    weak var view: MovieDetailViewProtocol?
    var movie: Movie?

    func prepare() {
        if let movie = movie {
            view?.loadView(for: movie)
        }
    }
}
