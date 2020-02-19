//
//  SerieCollectionViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SerieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!
    
    func configure(serie: Result) {
        serieNameLabel.text = serie.name
        
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serie.posterPath) { (data) in
                if let data = data {
                    self.serieNameLabel.isHidden = true
                    self.serieImageView.image = UIImage(data: data)
                } else {
                    print("No image")
                }
        }
    }
}
