//
//  FavoriteSerieCVCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// CollectionViewCell that displays the favorite series of a user.
class FavoriteSerieCVCell: UICollectionViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!

    // MARK: - View Functions
    /**
     Function that configures the FavoriteSerieCVCell.
     
     Calling this function calls the displaySerie function to send a request to get the serie,
     to get the serie informations, to give a value to the serieNameLabel,
     to send a request to get the serie image and to display this image.
     
     - Parameter serieId: The id of the serie to display.
    */
    func configure(serieId: Int) {
        serieImageView.image = UIImage(named: "defaultSerieImage")

        if NSLocale.current.languageCode == "fr" {
            displaySerie(serieId: serieId, language: "fr")
        } else {
            displaySerie(serieId: serieId, language: "en")
        }
    }

    /// Function that gets a serie and his image; and displays then in the view.
    private func displaySerie(serieId: Int, language: String) {
        SeriesService(session: URLSession(configuration: .default))
            .getSerie(serieId: serieId, language: language) { (success, serie) in
                guard success, let serie = serie else { return }
                self.serieImageView.image = nil
                self.serieNameLabel.text = serie.name

                guard let serieImageUrl = serie.posterPath else { return }
                SeriesService(session: URLSession(configuration: .default))
                    .getSerieImage(imageUrl: serieImageUrl, completionHandler: { (data) in
                        guard let data = data else { return }
                        self.serieNameLabel.isHidden = true
                        self.serieImageView.image = UIImage(data: data)
                    })
        }
    }
}
