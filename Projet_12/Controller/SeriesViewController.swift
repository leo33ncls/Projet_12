//
//  SeriesViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {
}

extension SeriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SerieCell", for: indexPath)
        SeriesService(session: URLSession(configuration: .default))
            .getSeriesList(genre: "18") { (success, seriesList) in
            
        }
        return cell
    }
    
    
}
