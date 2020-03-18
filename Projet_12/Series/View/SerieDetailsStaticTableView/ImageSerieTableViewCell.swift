//
//  ImageSerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 24/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class ImageSerieTableViewCell: UITableViewCell {

    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!

    func configure(serie: Result) {
        serieNameLabel.text = serie.name
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serie.backdropPath) { (data) in
                if let data = data {
                    self.serieImageView.image = UIImage(data: data)
                }
        }
    }

    func setUpShadow(width: CGFloat) {
        serieImageView.layer.addSublayer(CustomShadowLayer(view: serieImageView,
                                                           shadowColor: UIColor.customGrey,
                                                           shadowWidth: width,
                                                           shadowRadius: serieNameLabel.bounds.height + 20))
    }
}
