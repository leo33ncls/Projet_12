//
//  SearchSerieView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View that displays a serie after a research.
class SearchSerieView: UIView {

    // MARK: - View Outlet
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var serieGenresLabel: UILabel!

    // ======================
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // The init of the view from the nib.
    private func commonInit() {
        Bundle.main.loadNibNamed("SearchSerieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    // =======================
    // MARK: - View Functions

    /**
     Function that configures the SearchSerieView.

     Calling this function gives a value to the serieNameLabel, gets the serie genres,
     sends a request to get the serie image and displays this image.

     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        serieNameLabel.text = serie.name
        serieImageView.image = nil

        if let genres = serie.genreIDS {
            serieGenresLabel.text = Genres.getStringGenre(genreId: genres)
        } else {
            serieGenresLabel.text = "Unknown genre"
        }

        guard let serieImageUrl = serie.posterPath else { return }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                if let data = data {
                    self.serieImageView.image = UIImage(data: data)
                } else {
                    self.serieImageView.image = UIImage(named: "defaultSerieImage")
                }
        }
    }
}
