//
//  FavoriteSerieCVCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class FavoriteSerieCVCell: UICollectionViewCell {
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!

    func configure(serieId: Int) {
        serieImageView.image = nil

        SeriesService(session: URLSession(configuration: .default))
            .getSerie(serieId: serieId) { (success, serie) in
                guard success, let serie = serie else { return }
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
