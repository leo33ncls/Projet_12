//
//  AccountTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var titleCellLabel: UILabel!

    func configure(title: String) {
        titleCellLabel.text = title
    }
}
