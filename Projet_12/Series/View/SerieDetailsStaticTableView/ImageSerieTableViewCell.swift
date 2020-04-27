//
//  ImageSerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 24/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the serie image and name
class ImageSerieTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!

    // =======================
    // MARK: - View Functions

    /**
     Function that configures the ImageSerieTableViewCell
     Calling this function gives a value to the serieNameLabel,
     sends a request to get the serie background image and displays this image.
     
     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        serieNameLabel.text = serie.name

        guard let serieImageUrl = serie.backdropPath else { return }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                if let data = data {
                    self.serieImageView.image = UIImage(data: data)
                }
        }
    }

    /**
     Function that set up a shadow on a view.
     - Parameter width: The width of the shadow.
     */
    func setUpShadow(width: CGFloat) {
        serieImageView.layer.addSublayer(CustomShadowLayer(view: serieImageView,
                                                           shadowColor: UIColor.customGrey,
                                                           shadowWidth: width,
                                                           shadowRadius: serieNameLabel.bounds.height + 20))
    }
}
