//
//  AccountTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the name of a section in the AccountVC.
class AccountTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var titleCellLabel: UILabel!

    // MARK: - View Functions
    /**
     Function that configure the titleLabel of the AccountTableViewCell.
     - Parameter title: The title of the section.
    */
    func configure(title: String) {
        titleCellLabel.text = title
    }
}
