//
//  SeriesViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let segueIdentifier = "segueToSerieDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NSNotification.Name(rawValue: "CollectionViewSelected")
        NotificationCenter.default.addObserver(self, selector: #selector(collectionViewTapped(_:)), name: name, object: nil)
    }
    
    @objc func collectionViewTapped(_ notification: NSNotification) {
        guard let serie = notification.userInfo?["serie"] as? Result else {
            return
        }
        performSegue(withIdentifier: segueIdentifier, sender: serie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segueIdentifier == segue.identifier, let serieDetailsVC = segue.destination as? SerieDetailsViewController {
            serieDetailsVC.serie = sender as? Result
        }
    }
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Genres.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SerieCell", for: indexPath) as? SerieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(genreInd: indexPath.row)
        /*cell.callback = { (success, serie) in
        }
        cell.serieClickListener = self*/
        return cell
    }
}

/*extension SeriesViewController: SerieClickListener {
    func onClick(serie: Result) {
        
    }
}*/
