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

    // MARK: - View Properties
    var favoriteSeriesId = [Int]()
    let segueToSerieDetailsIdentifier = "segueToSerieDetailsFromAccount"

    // =========================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSerieCollectionView.delegate = self
        favoriteSerieCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get the IDs of the user's favorite series.
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FavoriteSerieService.getFavoriteSerieId(userId: userId) { (seriesId) in
            if let seriesId = seriesId {
                self.favoriteSeriesId = seriesId
                self.favoriteSerieCollectionView.reloadData()
            } else {
                UIAlertController().showAlert(title: "Désolé !",
                                              message: "Vous n'avez aucune serie favorite pour le moment !",
                                              viewController: self)
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
        SeriesService(session: URLSession(configuration: .default))
            .getSerie(serieId: serieId) { (success, serie) in
                guard success, let serie = serie else {
                    UIAlertController().showAlert(title: "Désolé",
                                                  message: "Le serie Id est incorrecte !",
                                                  viewController: self)
                    return
                }
                self.performSegue(withIdentifier: self.segueToSerieDetailsIdentifier, sender: serie)
        }
    }
}
