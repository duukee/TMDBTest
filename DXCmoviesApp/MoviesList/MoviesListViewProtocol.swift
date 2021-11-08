//
//  MoviesListViewProtocol.swift
//  DXCmoviesApp
//
//  Created Alex Zaragoza Chazarra on 8/11/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import Foundation

// MARK: View -
protocol MoviesListViewProtocol: AnyObject {
    func updateViewState(with newState:MoviesListViewController.State)
}
