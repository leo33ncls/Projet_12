//
//  InformationSerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 24/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class InformationSerieTableViewCell: UITableViewCell {
    @IBOutlet weak var seriePosterImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(serie: Result) {
        self.selectionStyle = .none
        genreLabel.text = "Genre: \(Genres.getStringGenre(genreId: serie.genreIDS))"
        dateLabel.text = "Date de sortie: \(serie.firstAirDate)"
        popularityLabel.text = "Popularité: \(serie.popularity)"
        originalLanguageLabel.text = "Langue originale: \(serie.originalLanguage)"
        countryLabel.text = "Pays: \(serie.originCountry.joined(separator: ", "))"
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serie.posterPath) { (data) in
                if let data = data {
                    self.seriePosterImageView.image = UIImage(data: data)
                }
        }
    }
}
