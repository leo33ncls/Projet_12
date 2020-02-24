//
//  SerieDetailsViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SerieDetailsViewController: UIViewController {
    
    @IBOutlet weak var serieNameLabel: UILabel!
    
    var serie: Result?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let serieDetails = serie else { return }
        serieNameLabel.text = serieDetails.name
    }
}
