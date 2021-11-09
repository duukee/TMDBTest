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

    override public func prepareForReuse() {
        averageView.prepareForReuse()
        coverImageView.image = nil
    }
    
    func set(cover: String?, title: String?, overview: String?, average: Double) {
        titleLabel.textAlignment = .left
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        overviewLabel.numberOfLines = 0
        averageView.rating = average
        averageView.settings.updateOnTouch = false
        
        if let cover = cover {
            let coverString = TMDBApiConstants.Endpoints.imagesURL + cover
            let coverURL: URL = URL.init(string: coverString)!
            coverImageView.af.setImage(withURL: coverURL)
        }
    }

    
}
