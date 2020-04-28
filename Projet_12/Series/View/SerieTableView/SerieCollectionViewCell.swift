//
//  SerieCollectionViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// CollectionViewCell that displays a serie.
class SerieCollectionViewCell: UICollectionViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!

    // MARK: - View Functions
    /**
     Function that configures the SerieCollectionViewCell.

     Calling this function gives a value to the serieNameLabel,
     sends a request to get the serie image and displays this image.
     
     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        serieImageView.image = nil
        serieNameLabel.text = serie.name

        guard let serieImageUrl = serie.posterPath else { return }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                guard let data = data else { return }
                self.serieNameLabel.isHidden = true
                self.serieImageView.image = UIImage(data: data)
        }
    }
}
