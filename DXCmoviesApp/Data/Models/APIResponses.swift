//
//  APIResponses.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    let data: MoviesResults<T>
    let page: Int
    let totalPages: Int
}

struct MoviesResults<T: Codable>: Codable {
    let results: [T]
}
