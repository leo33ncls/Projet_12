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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }

    func loadViewFromNib() -> UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: "InformationSerieTableViewCell", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
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
