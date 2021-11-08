//
//  MovieTableViewCell.swift
//  DXCmoviesApp
//
//  Created by Alex Zaragoza Chazarra on 8/11/21.
//

import Foundation
import Reusable
import AlamofireImage
import Cosmos


class MovieTableViewCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var averageView: CosmosView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func set(cover: String?, title: String?, overview: String?, average: Double) {
        titleLabel.textAlignment = .left
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        averageView.rating = average
                
    }

    
}
