//
//  InformationSerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 24/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the serie informations.
class InformationSerieTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var seriePosterImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var originalLanguageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    var view: UIView!

    // =======================
    // MARK: - View Functions

    /**
     Function that configures the InformationSerieTableViewCell.

     Calling this function gives a value to the genreLabel, the dateLabel,
     the popularityLabel, the originalLanguageLabel and the countryLabel;
     sends a request to get the serie image and displays this image.

     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        self.selectionStyle = .none
        if let genres = serie.genreIDS {
            genreLabel.text = "Genre: \(Genres.getStringGenre(genreId: genres))"
        } else if let genres = serie.genres {
            genreLabel.text = "Genre: \(getGenres(genreArray: genres))"
        } else {
            genreLabel.text = "Genre:" + NSLocalizedString("UNKNOWN", comment: "")
        }

        dateLabel.text = NSLocalizedString("RELEASE_DATE", comment: "") + ": \(serie.firstAirDate)"
        popularityLabel.text = NSLocalizedString("POPULARITY", comment: "") + ": \(serie.popularity)"
        originalLanguageLabel.text = NSLocalizedString("ORIGINAL_LANGUAGE", comment: "")
                                        + ": \(serie.originalLanguage.uppercased())"
        countryLabel.text = NSLocalizedString("COUNTRY", comment: "")
                                        + ": \(serie.originCountry.joined(separator: ", "))"

        guard let serieImageUrl = serie.posterPath else {
            seriePosterImageView.image = UIImage(named: "defaultSerieImage")
            return
        }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                if let data = data {
                    self.seriePosterImageView.image = UIImage(data: data)
                } else {
                    self.seriePosterImageView.image = UIImage(named: "defaultSerieImage")
                }
        }
    }

    /// Function that transforms the genre array in a string.
    private func getGenres(genreArray: [Genre]) -> String {
        var genres = [String]()
        for genre in genreArray {
            genres.append(genre.name)
        }
        return genres.joined(separator: ", ")
    }
}
