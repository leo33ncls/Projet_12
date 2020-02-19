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
        return cell
    }
}
