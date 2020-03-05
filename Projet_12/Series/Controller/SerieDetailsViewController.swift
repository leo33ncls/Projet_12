//
//  SerieDetailsViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SerieDetailsViewController: UITableViewController {
    var serie: Result?
    var segueToEvaluationIdentifier = "segueToEvaluationVC"
    var segueToForumIdentifier = "segueToForumVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        registerCell()
        
        let name = NSNotification.Name(rawValue: "EvaluateButtonTapped")
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewTapped), name: name, object: nil)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentSerie = serie else { return }
        if segue.identifier == segueToEvaluationIdentifier,
            let evaluationVC = segue.destination as? EvaluationViewController {
            evaluationVC.serie = currentSerie
        } else if segue.identifier == segueToForumIdentifier,
        let forumVC = segue.destination as? ForumViewController {
            forumVC.serie = currentSerie
        }
    }
    
    @objc func collectionViewTapped() {
        performSegue(withIdentifier: segueToEvaluationIdentifier, sender: nil)
    }
    
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
    
    private func configureImageSerieTVCell(tableView: UITableView, currentSerie: Result) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSerieCell") as? ImageSerieTableViewCell else {
            return UITableViewCell()
        }
        cell.setUpShadow(width: view.bounds.width)
        cell.configure(serie: currentSerie)
        return cell
    }
    
    private func configureInformationSerieTVCell(tableView: UITableView, currentSerie: Result) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InformationSerieCell") as? InformationSerieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }
    
    private func configureEvaluationTVCell(tableView: UITableView, currentSerie: Result) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationCell") as? EvaluationTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }
    
    private func configureSynopsisTVCell(tableView: UITableView, currentSerie: Result) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SynopsisCell") as? SynopsisTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(serie: currentSerie)
        return cell
    }
    
    private func configureForumTVCell(tableView: UITableView, currentSerie: Result) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForumCell") as? ForumTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
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
        case 3: return 150
        case 4: return 45
        default: return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            performSegue(withIdentifier: segueToForumIdentifier, sender: nil)
        }
    }
}
