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
    private let dataSource = MoviesDataSource()
    var movies: [Movie] = []
    var page: Int = 1
    var searchQuery: String?
    var searchPage: Int = 1

    func prepare() {
        reloadMovies()
    }
        
    //MARK: Load Movies
    func loadMovies(){
        dataSource.getMovies(page: page) { movies, errorMessage in
            if let newMovies = movies {
                self.movies.append(contentsOf: newMovies)
                self.view?.updateViewState(with: .ready)
                self.page += 1
            } else {
                self.view?.updateViewState(with: .error)
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
        dataSource.searchMovie(query: query, page: searchPage) { movies, errorMessage in
            if let newMovies = movies {
                self.movies.append(contentsOf: newMovies)
                self.view?.updateViewState(with: .searching)
                self.searchPage += 1
            } else {
                self.view?.updateViewState(with: .error)
            }
        }
    }
    
    func searchMore() {
        if let query = searchQuery {
            searchMovie(query: query)
        }
    }
}
