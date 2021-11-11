//
//  TMDBApiCaller.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 11/11/21.
//

import Foundation
import Moya


//protocol TMDBApiCallerProtocol {
//    func getMovies(page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ())
//    func searchMovie(query: String, page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ())
//}

class TMDBApiCaller {
    
    func getMovies(page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ()) {
        let provider = MoyaProvider<TMDBApiDefinition>()
        provider.request(.popularMovies(page: page)) { result in
        switch result {
        case .success(let response):
            do {
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                completion(movies, nil)
            } catch {
                completion(nil, "Mapping response error")
            }
        case .failure:
            completion(nil, "Request Error")
            }
        }
    }
    
    func searchMovie(query: String, page: Int, completion: @escaping (_ movies: [Movie]?, _ errorMessage: String?) -> ()) {
        let provider = MoyaProvider<TMDBApiDefinition>()
        provider.request(.searchMovie(query: query, page: page)) { result in
        switch result {
        case .success(let response):
            do {
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                completion(movies, nil)
            } catch {
                completion(nil, "Mapping response error")
            }
        case .failure:
            completion(nil, "Request Error")
            }
        }
    }

}
