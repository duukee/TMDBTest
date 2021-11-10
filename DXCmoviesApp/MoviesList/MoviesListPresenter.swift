//
//  MoviesListPresenter.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 8/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation
import Moya

// MARK: Presenter -
protocol MoviesListPresenterProtocol: AnyObject {
	var view: MoviesListViewProtocol? { get set }
    func prepare()
    func loadMovies(page: Int)
    func reloadMovies()
    func loadMore()
    func searchMovie(query: String)
    var movies: [Movie] { get set }
}

class MoviesListPresenter: MoviesListPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    var movies: [Movie] = []
    var page: Int = 1

    func prepare() {
        reloadMovies()
    }
    
    //MARK: Load data
    func loadMovies(page: Int){
        let provider = MoyaProvider<TMDBApi>()
        provider.request(.popularMovies(page: page)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
            do {
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                self.movies.append(contentsOf: movies)
                self.view?.updateViewState(with: .ready)
                self.page += 1
            } catch {
                self.view?.updateViewState(with: .error)
                print("map error")
            }
        case .failure:
            self.view?.updateViewState(with: .error)
            print("request error")
            }
        }
    }
    
    func reloadMovies() {
        movies.removeAll()
        page = 1
        view?.updateViewState(with: .loading)
        //TODO: remove delay -> added to test the alert view
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.loadMovies(page: self.page)
        })
    }
    
    func loadMore() {
        loadMovies(page: page)
    }
    
    func searchMovie(query: String) {
        movies.removeAll()
        page = 1
        
        let provider = MoyaProvider<TMDBApi>()
        provider.request(.searchMovie(query: query, page: page)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
            do {
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                self.movies.append(contentsOf: movies)
                self.view?.updateViewState(with: .ready)
                self.page += 1
            } catch {
                self.view?.updateViewState(with: .error)
                print("map error")
            }
        case .failure:
            self.view?.updateViewState(with: .error)
            print("request error")
            }
        }

    }
}
