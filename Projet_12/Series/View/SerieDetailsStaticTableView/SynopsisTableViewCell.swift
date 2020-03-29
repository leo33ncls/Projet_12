//
//  SynopsisTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SynopsisTableViewCell: UITableViewCell {
    @IBOutlet weak var synopsisTextView: UITextView!

    func configure(serie: Result) {
        self.selectionStyle = .none
        synopsisTextView.text = serie.overview
    }
}
