//
//  EvaluationTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class EvaluationTableViewCell: UITableViewCell {
    @IBOutlet weak var evaluationPressLabel: UILabel!
    @IBOutlet weak var evaluationReadersLabel: UILabel!
    @IBOutlet weak var giveEvaluationButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(serie: Result) {
        self.selectionStyle = .none
        if serie.voteAverage >= 7 {
            evaluationPressLabel.textColor = UIColor.green
        } else if serie.voteAverage > 5 {
            evaluationPressLabel.textColor = UIColor.blue
        } else if serie.voteAverage > 3 {
            evaluationPressLabel.textColor = UIColor.orange
        } else {
            evaluationPressLabel.textColor = UIColor.red
        }
        evaluationPressLabel.text = "\(serie.voteAverage)"
        
        evaluationReadersLabel.textColor = UIColor.blue
        evaluationReadersLabel.text = "5"
        
        giveEvaluationButton.setTitle("Donner\n une\n note\n >", for: .normal)
    }
}
