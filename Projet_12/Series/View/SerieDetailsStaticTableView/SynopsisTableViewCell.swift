//
//  SynopsisTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the synopsis
class SynopsisTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var synopsisTextView: UITextView!

    // MARK: - View Functions
    /**
     Function that configures the SynopsisTableViewCell.
     Calling this function gives a value to the synopsisTextView.
     
     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        self.selectionStyle = .none
        synopsisTextView.text = serie.overview
    }
}
