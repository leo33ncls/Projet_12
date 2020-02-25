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

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        tableView.reloadData()
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
        case 4: return 70
        default: return 150
        }
    }
}
