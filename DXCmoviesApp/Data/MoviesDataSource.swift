//
//  MoviesDataSource.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 11/11/21.
//

import Foundation


class MoviesDataSource {
    
    /*
     * If we had CoreData, this class would handle whether the data is requested from the database or from the api
     */
    
    private let api = TMDBApiCaller()
    
    func getMovies(page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ()) {
        api.getMovies(page: page) { movies, errorMessage in
            completion(movies, errorMessage)
        }
    }

    func searchMovie(query: String, page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ()) {
        api.searchMovie(query: query, page: page) { movies, errorMessage in
            completion(movies, errorMessage)
        }
    }

}
