//
//  ViewController.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 6/11/21.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.red
        loadMovies(page: 1)
    }


    func loadMovies(page: Int){
        let provider = MoyaProvider<TMDBApi>()
        provider.request(.popularMovies(page: page)) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let response):
            do {
                print(try response.mapJSON())
                           
                let movies: [Movie] = try response.map(ListResponse<Movie>.self).results
                
                print(movies)
//                self.charactersData.append(contentsOf: charactersReceived)
//                self.view?.updateViewState(with: .ready)
//                self.page += 1
            } catch {
//                self.view?.updateViewState(with: .error)
                print("map error")

            }
        case .failure:
//            self.view?.updateViewState(with: .error)
            print("request error")
            }
        }
    }

    
}

