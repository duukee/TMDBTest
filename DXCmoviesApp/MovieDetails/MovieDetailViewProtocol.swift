//
//  MovieDetailViewProtocol.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 9/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: View -
protocol MovieDetailViewProtocol: AnyObject {
    func loadView(for movie: Movie)
}
