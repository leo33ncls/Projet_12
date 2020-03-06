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

    func configure(serie: Result) {
        self.selectionStyle = .none
        
        setEvaluationColor(evaluation: serie.voteAverage, label: evaluationPressLabel)
        evaluationPressLabel.text = "\(serie.voteAverage)"
        
        evaluationReadersLabel.textColor = UIColor.blue
        EvaluationService.getEvaluations(serie: serie) { result in
            if let result = result {
                let roundedResult = Double(round(10*result)/10)
                self.evaluationReadersLabel.text = "\(roundedResult)"
            } else {
                self.evaluationReadersLabel.text = "/"
            }
        }
        
        giveEvaluationButton.setTitle("Donner\n une\n note\n >", for: .normal)
    }
    
    private func setEvaluationColor(evaluation: Double, label: UILabel) {
        switch evaluation {
        case 0..<3: label.textColor = UIColor.red
        case 3..<5: label.textColor = UIColor.orange
        case 5..<7: label.textColor = UIColor.blue
        case 7...10: label.textColor = UIColor.green
        default: label.textColor = UIColor.blue
        }
    }
    
    @IBAction func evaluateButtonTapped(_ sender: UIButton) {
        let notifName = NSNotification.Name("EvaluateButtonTapped")
        NotificationCenter.default.post(name: notifName, object: nil, userInfo: nil)
    }
}
