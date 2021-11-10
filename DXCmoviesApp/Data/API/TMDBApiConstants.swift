//
//  TMDBApiConstants.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import Foundation

struct TMDBApiConstants {
    
    enum Auth {
        static let apiKey = "812421ba4ad92bbbfe399f7ba05c36fd"
    }
    
    enum Endpoints {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imagesURL = "https://image.tmdb.org/t/p/w500"
        static let popularMovies = "/movie/popular"
        static let searchMovie = "/search/movie"
    }

    enum Params {
        static let apikey = "api_key"
        static let page = "page"
        static let language = "language" //Default en-US
        static let query = "query"
        static let adult_content = "include_adult"
    }
            
    enum SessionConfiguration {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        static let valueJson = "application/json"
    }
}
