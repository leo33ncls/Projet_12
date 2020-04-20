//
//  FavoriteSerieViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class FavoriteSerieViewController: UIViewController {
    @IBOutlet weak var favoriteSerieCollectionView: UICollectionView!

    var favoriteSeriesId = [Int]()
    let segueIdentifier = "segueToSerieDetailsFromAccount"

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSerieCollectionView.delegate = self
        favoriteSerieCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        guard segue.identifier == segueIdentifier,
            let serieDetailsVC = segue.destination as? SerieDetailsViewController,
            let serie = sender as? Result else {
            return
        }
        serieDetailsVC.serie = serie
    }
}

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

        SeriesService(session: URLSession(configuration: .default))
            .getSerie(serieId: serieId) { (success, serie) in
                guard success, let serie = serie else {
                    UIAlertController().showAlert(title: "Désolé",
                                                  message: "Le serie Id est incorrecte !",
                                                  viewController: self)
                    return
                }
                self.performSegue(withIdentifier: self.segueIdentifier, sender: serie)
        }
    }
}
