//
//  SearchSerieView.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SearchSerieView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var serieImageView: UIImageView!
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var serieGenresLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("SearchSerieView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }

    func configure(serie: Result) {
        serieNameLabel.text = serie.name
        serieGenresLabel.text = Genres.getStringGenre(genreId: serie.genreIDS)

        guard let serieImageUrl = serie.posterPath else { return }
        SeriesService(session: URLSession(configuration: .default))
            .getSerieImage(imageUrl: serieImageUrl) { (data) in
                if let data = data {
                    self.serieImageView.image = UIImage(data: data)
                }
        }
    }
}
