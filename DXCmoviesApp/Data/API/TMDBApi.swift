//
//  TMDBApi.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import Foundation
import Moya

public enum TMDBApi {
    case popularMovies(page: Int)
    case searchMovie(query: String)
}

extension TMDBApi: TargetType {
    
    // Base Marvel Service URL
    public var baseURL: URL {
        return URL(string: TMDBApiConstants.Endpoints.baseURL)!
    }

    // Paths for each case
    public var path: String {
        switch self {
        case .popularMovies: return TMDBApiConstants.Endpoints.popularMovies
        case .searchMovie: return TMDBApiConstants.Endpoints.searchMovie
        }
    }
    
    // HTTP methods for each case
    public var method: Moya.Method {
        switch self {
        case .popularMovies: return .get
        case .searchMovie: return .get
        }
    }

    // Fake response for testing
    public var sampleData: Data {
        //IMPROVE: return fake response for testing
        return Data()
    }

    // Request for each API endpoint
    public var task: Task {
        
        // Marvel API Hash for authorization
        let authParams = [TMDBApiConstants.Params.apikey: TMDBApiConstants.Auth.apiKey]
        let language = Locale.preferredLanguages[0]
        
        switch self {
        case .popularMovies(let page):
          return .requestParameters(
            parameters: [
                TMDBApiConstants.Params.page: page,
                TMDBApiConstants.Params.language: language] + authParams,
            encoding: URLEncoding.default)
            
        case .searchMovie(let query):
          return .requestParameters(
            parameters: [
                TMDBApiConstants.Params.language: language,
                TMDBApiConstants.Params.query: query] + authParams,
            encoding: URLEncoding.default)
        }
    }

    // Headers for endpoints
    public var headers: [String: String]? {
        return [TMDBApiConstants.SessionConfiguration.contentType: TMDBApiConstants.SessionConfiguration.valueJson]
    }

    // Return success for 200-299 HTTP codes
    public var validationType: ValidationType {
        return .successCodes
    }


    
}
