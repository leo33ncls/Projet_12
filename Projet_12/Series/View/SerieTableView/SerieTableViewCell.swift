//
//  SerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the series list.
class SerieTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var genreLabel: UILabel!

    // MARK: - View Properties
    var serieList: SeriesList?

    // MARK: - View Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - View Functions
    /**
     Function that configures the SerieTableViewCell.

     Calling this function gives a value to the genreLabel,
     and sends a request to get a series list.

     - Parameter genreInd: The index of the genre.
    */
    func configure(genreInd: Int) {
        genreLabel.text = Genres.genres[genreInd].genre

        if NSLocale.current.languageCode == "fr" {
            getSeriesList(genreInd: genreInd, language: "fr")
        } else {
            getSeriesList(genreInd: genreInd, language: "en")
        }
    }

    /// Function that sends a request with a specific language and gets a series list.
    private func getSeriesList(genreInd: Int, language: String) {
        SeriesService(session: URLSession(configuration: .default))
            .getSeriesList(genre: Genres.genres[genreInd].id, language: language) { (success, seriesList) in
                if success, let seriesList = seriesList {
                    self.serieList = seriesList
                    self.collectionView.reloadData()
                } else {
                    print("SeriesList Request Error Genre: \(Genres.genres[genreInd].id)")
                }
        }
    }
}

// MARK: - CollectionView
extension SerieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let series = serieList else { return 0 }
        return series.results.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        guard let series = serieList else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SerieCVCell", for: indexPath)
            as? SerieCollectionViewCell else {
            return UICollectionViewCell()
        }
        let serie = series.results[indexPath.row]
        cell.configure(serie: serie)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let series = serieList else { return }
        let serieSelected = series.results[indexPath.row]
        let serieDict: [String: Serie] = ["serie": serieSelected]

        // Post a notification to tell that the collectionViewCell is selected by the user.
        let notifName = NSNotification.Name("CollectionViewSelected")
        NotificationCenter.default.post(name: notifName, object: nil, userInfo: serieDict)
    }
}
