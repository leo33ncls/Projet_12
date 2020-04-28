//
//  SeriesViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View Controller that displays series lists.
class SeriesViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Properties
    private let segueIdentifier = "segueToSerieDetails"

    // ====================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Observe the notification sent when a collectionViewCell is selected.
        let name = NSNotification.Name(rawValue: "CollectionViewSelected")
        NotificationCenter.default
            .addObserver(self, selector: #selector(collectionViewTapped(_:)), name: name, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give a serie to the serieDetailsVC.
        if segue.identifier == segueIdentifier, let serieDetailsVC = segue.destination as? SerieDetailsViewController {
            serieDetailsVC.serie = sender as? Serie
        }
    }

    /// Function that performs a segue to SerieDetailsVC when the VC receives a notification from a CollectionViewCell.
    @objc func collectionViewTapped(_ notification: NSNotification) {
        guard let serie = notification.userInfo?["serie"] as? Serie else {
            return
        }
        performSegue(withIdentifier: segueIdentifier, sender: serie)
    }
}

// MARK: - TableView
extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Genres.genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SerieCell", for: indexPath)
            as? SerieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(genreInd: indexPath.row)
        return cell
    }
}
