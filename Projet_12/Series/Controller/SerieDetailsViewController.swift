//
//  SerieDetailsViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View Controller that displays details of a serie.
class SerieDetailsViewController: UITableViewController {

    // MARK: - View Outlet
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    // MARK: - View Properties
    // The serie received from SeriesVC, SearchVC or FavoriteSerieVC.
    var serie: Serie?
    let segueToEvaluationIdentifier = "segueToEvaluationVC"
    let segueToForumIdentifier = "segueToForumVC"

    // ========================
    // MARK: - View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        registerCell()

        // Observe the notification sent when the evaluateButton is tapped.
        let name = NSNotification.Name(rawValue: "EvaluateButtonTapped")
        NotificationCenter.default.addObserver(self, selector: #selector(evaluateButtonTapped), name: name, object: nil)
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentSerie = serie else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        // Set the color of the favoriteButton.
        FavoriteSerieService.isAFavoriteSerie(userId: currentUserId, serie: currentSerie) { (success) in
            if success {
                self.favoriteButton.tintColor = UIColor.customOrange
            } else {
                self.favoriteButton.tintColor = UIColor.white
            }
        }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentSerie = serie else { return }
        // Give the serie to the EvaluationVC or to the ForumVC.
        if segue.identifier == segueToEvaluationIdentifier,
            let evaluationVC = segue.destination as? EvaluationViewController {
            evaluationVC.serie = currentSerie
        } else if segue.identifier == segueToForumIdentifier,
        let forumVC = segue.destination as? ForumViewController {
            forumVC.serie = currentSerie
        }
    }

    /// Function that performs a segue to EvaluationVC when the evaluateButton is pressed.
    @objc func evaluateButtonTapped() {
        performSegue(withIdentifier: segueToEvaluationIdentifier, sender: nil)
    }

    // ========================
    // MARK: - View Functions

    /// Function that registers the custom cells on the tableView.
    private func registerCell() {
        let imageSerieCell = UINib(nibName: "ImageSerieTableViewCell", bundle: nil)
        self.tableView.register(imageSerieCell, forCellReuseIdentifier: "ImageSerieCell")

        let informationCell = UINib(nibName: "InformationSerieTableViewCell", bundle: nil)
        self.tableView.register(informationCell, forCellReuseIdentifier: "InformationSerieCell")

        let evaluationCell = UINib(nibName: "EvaluationTableViewCell", bundle: nil)
        self.tableView.register(evaluationCell, forCellReuseIdentifier: "EvaluationCell")

        let synopsisCell = UINib(nibName: "SynopsisTableViewCell", bundle: nil)
        self.tableView.register(synopsisCell, forCellReuseIdentifier: "SynopsisCell")

        let forumCell = UINib(nibName: "ForumTableViewCell", bundle: nil)
        self.tableView.register(forumCell, forCellReuseIdentifier: "ForumCell")
    }

    /// Function that creates and configures the ImageSerieTableViewCell.
    private func configureImageSerieTVCell(tableView: UITableView, currentSerie: Serie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSerieCell")
            as? ImageSerieTableViewCell else {
            return UITableViewCell()
        }
        cell.setUpShadow(width: view.bounds.width)
        cell.configure(serie: currentSerie)
        return cell
    }

    /// Function that creates and configures the InformationSerieTableViewCell.
    private func configureInformationSerieTVCell(tableView: UITableView, currentSerie: Serie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationSerieCell")
            as? InformationSerieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }

    /// Function that creates and configures the EvaluationTableViewCell.
    private func configureEvaluationTVCell(tableView: UITableView, currentSerie: Serie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationCell")
            as? EvaluationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }

    /// Function that creates and configures the SynopsisTableViewCell.
    private func configureSynopsisTVCell(tableView: UITableView, currentSerie: Serie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SynopsisCell") as? SynopsisTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }

    /// Function that creates and configures the ForumTableViewCell.
    private func configureForumTVCell(tableView: UITableView, currentSerie: Serie) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCell") as? ForumTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }

    // =================
    // MARK: - View Actions

    // Action that saves or removes the serie in the FavoriteSerie database.
    @IBAction func saveSerieAsFavorite(_ sender: UIBarButtonItem) {
        guard let currentSerie = serie else { return }
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        FavoriteSerieService.isAFavoriteSerie(userId: currentUserId, serie: currentSerie) { (success) in
            if success {
                FavoriteSerieService.removeFavoriteSerie(userId: currentUserId, serie: currentSerie)
                self.favoriteButton.tintColor = UIColor.white
            } else {
                FavoriteSerieService.saveSerieAsFavorite(userId: currentUserId, serie: currentSerie)
                self.favoriteButton.tintColor = UIColor.customOrange
            }
        }
    }

    // =================
    // MARK: - TableView

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentSerie = serie else { return UITableViewCell() }

        switch indexPath.row {
        case 0: return configureImageSerieTVCell(tableView: tableView, currentSerie: currentSerie)
        case 1: return configureInformationSerieTVCell(tableView: tableView, currentSerie: currentSerie)
        case 2: return configureEvaluationTVCell(tableView: tableView, currentSerie: currentSerie)
        case 3: return configureSynopsisTVCell(tableView: tableView, currentSerie: currentSerie)
        case 4: return configureForumTVCell(tableView: tableView, currentSerie: currentSerie)
        default: return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 200
        case 1: return 150
        case 2: return 140
        case 3:
            tableView.estimatedRowHeight = 150
            return UITableView.automaticDimension
        case 4: return 45
        default: return 150
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform a segue to ForumVC when the ForumTableViewCell is selected.
        if indexPath.row == 4 {
            performSegue(withIdentifier: segueToForumIdentifier, sender: nil)
        }
    }
}
