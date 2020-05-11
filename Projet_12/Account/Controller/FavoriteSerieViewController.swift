//
//  FavoriteSerieViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View Controller to display the favorite series of the user logged in.
class FavoriteSerieViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var favoriteSerieCollectionView: UICollectionView!
    @IBOutlet weak var seriesFavoriteLabel: UILabel!

    // MARK: - View Properties
    var favoriteSeriesId = [Int]()
    let segueToSerieDetailsIdentifier = "segueToSerieDetailsFromAccount"

    // =========================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSerieCollectionView.delegate = self
        favoriteSerieCollectionView.dataSource = self
        seriesFavoriteLabel.text = NSLocalizedString("FAVORITE_SERIE_TITLE", comment: "Favorite series")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get the IDs of the user's favorite series.
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FavoriteSerieService.getFavoriteSerieId(userId: userId) { (seriesId) in
            if let seriesId = seriesId {
                self.favoriteSeriesId = seriesId
                self.favoriteSerieCollectionView.restore()
                self.favoriteSerieCollectionView.reloadData()
            } else {
                self.favoriteSeriesId.removeAll()
                self.favoriteSerieCollectionView.reloadData()
                self.favoriteSerieCollectionView
                    .setEmptyView(title: NSLocalizedString("FAVSERIE_TABLEVIEW_ALERT_TITLE",
                                                           comment: "No favorite serie"),
                                  message: NSLocalizedString("FAVSERIE_TABLEVIEW_ALERT_MESSAGE",
                                                             comment: "Instructions"))
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give a serie to the SerieDetailsVC.
        guard segue.identifier == segueToSerieDetailsIdentifier,
            let serieDetailsVC = segue.destination as? SerieDetailsViewController,
            let serie = sender as? Serie else {
            return
        }
        serieDetailsVC.serie = serie
    }

    // ========================
    // MARK: - View Functions

    /**
     Function that gets the selected serie and gives it to SerieDetailsVC.
     
     Calling this function sends a request with the id of the selected serie to the API,
     gets the selected serie informations from the API response;
     gives it in a segue and performs a segue to the SerieDetailsVC
     
     - Parameters:
        - serieId: The id of the selected serie.
        - language: The language in which we want the response.
     */
    private func getSelectedSerie(serieId: Int, language: String) {
        SeriesService(session: URLSession(configuration: .default))
            .getSerie(serieId: serieId, language: language) { (success, serie) in
                guard success, let serie = serie else {
                    print("Incorrect serie id")
                    return
                }
                self.performSegue(withIdentifier: self.segueToSerieDetailsIdentifier, sender: serie)
        }
    }
}

// MARK: - CollectionView
extension FavoriteSerieViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteSeriesId.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteSerieCVCell",
                                                            for: indexPath) as? FavoriteSerieCVCell else {
            return UICollectionViewCell()
        }
        let serieId = favoriteSeriesId[indexPath.row]
        cell.configure(serieId: serieId)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let serieId = favoriteSeriesId[indexPath.row]

        // Get the serie selected, give it in a segue and perform a segue to the SerieDetailsVC.
        if NSLocale.current.languageCode == "fr" {
            getSelectedSerie(serieId: serieId, language: "fr")
        } else {
            getSelectedSerie(serieId: serieId, language: "en")
        }
    }
}
