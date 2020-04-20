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

    var view: UIView!

    func configure(serie: Result) {
        self.selectionStyle = .none
        if let genres = serie.genreIDS {
            genreLabel.text = "Genre: \(Genres.getStringGenre(genreId: genres))"
        } else if let genres = serie.genres {
            genreLabel.text = "Genre: \(getGenres(genreArray: genres))"
        } else {
            genreLabel.text = "Genre: Unknown"
        }

        dateLabel.text = "Date de sortie: \(serie.firstAirDate)"
        popularityLabel.text = "Popularité: \(serie.popularity)"
        originalLanguageLabel.text = "Langue originale: \(serie.originalLanguage)"
        countryLabel.text = "Pays: \(serie.originCountry.joined(separator: ", "))"

        guard let serieImageUrl = serie.posterPath else { return }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                if let data = data {
                    self.seriePosterImageView.image = UIImage(data: data)
                }
        }
    }

    private func getGenres(genreArray: [Genre]) -> String {
        var genres = [String]()
        for genre in genreArray {
            genres.append(genre.name)
        }
        return genres.joined(separator: ", ")
    }
}
