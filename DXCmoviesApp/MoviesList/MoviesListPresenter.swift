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
    func loadMovies()
    func reloadMovies()
    func loadMore()
    func prepareForSearches()
    func searchMovie(query: String)
    func searchMore()
    var movies: [Movie] { get set }
}

class MoviesListPresenter: MoviesListPresenterProtocol {
    weak var view: MoviesListViewProtocol?
    var movies: [Movie] = []
    var page: Int = 1
    var searchQuery: String?
    var searchPage: Int = 1

    func prepare() {
        reloadMovies()
    }
    
    //MARK: Load Movies
    func loadMovies(){
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
        loadMovies()
    }
    
    func loadMore() {
        loadMovies()
    }
    
    //MARK: SEARCH
    func prepareForSearches() {
        searchPage = 1
        movies.removeAll()
        self.view?.updateViewState(with: .searching)
    }
    
    func searchMovie(query: String) {
        searchQuery = query
        let provider = MoyaProvider<TMDBApi>()
        provider.request(.searchMovie(query: query, page: searchPage)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
            do {
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                self.movies.append(contentsOf: movies)
                self.view?.updateViewState(with: .searching)
                self.searchPage += 1
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
    
    func searchMore() {
        if let query = searchQuery {
            searchMovie(query: query)
        }
    }
}
