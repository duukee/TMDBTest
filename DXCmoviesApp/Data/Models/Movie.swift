//
//  Movie.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import Foundation

struct Movie : Codable {
    let id: Int
    let title : String?
    let originalTitle : String?
    let overview : String?
    let voteAverage : Double
    let resourceURI : String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case originalTitle = "original_title"
        case overview = "overview"
        case voteAverage = "vote_average"
        case resourceURI = "backdrop_path"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)!
        title = try values.decodeIfPresent(String.self, forKey: .title)
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage)!
        resourceURI = try values.decodeIfPresent(String.self, forKey: .resourceURI)
    }

}
