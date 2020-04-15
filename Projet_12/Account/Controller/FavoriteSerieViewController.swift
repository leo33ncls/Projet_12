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
    @IBOutlet weak var favoriteSerieTableView: UITableView!

    var favoriteSeriesId = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteSerieTableView.delegate = self
        favoriteSerieTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FavoriteSerieService.getFavoriteSerieId(userId: userId) { (seriesId) in
            if let seriesId = seriesId {
                self.favoriteSeriesId = seriesId
            } else {
                UIAlertController().showAlert(title: "Désolé !",
                                              message: "Vous n'avez aucune serie favorite pour le moment !",
                                              viewController: self)
            }
        }
    }
}

extension FavoriteSerieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteSeriesId.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
