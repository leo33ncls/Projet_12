//
//  EvaluationTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// TableViewCell that displays the serie evaluation.
class EvaluationTableViewCell: UITableViewCell {

    // MARK: - View Outlet
    @IBOutlet weak var evaluationPressLabel: UILabel!
    @IBOutlet weak var evaluationReadersLabel: UILabel!
    @IBOutlet weak var giveEvaluationButton: UIButton!

    // =======================
    // MARK: - View Functions
    
    /**
     Function that configures the EvaluationTableViewCell.

     Calling this function gives a value to the evaluationPressLabel,
     and get a value for the evaluationReadersLabel in the db.
     
     - Parameter serie: The serie to display.
     */
    func configure(serie: Serie) {
        self.selectionStyle = .none
        giveEvaluationButton.layer.cornerRadius = 10
        giveEvaluationButton.backgroundColor = UIColor.white
        giveEvaluationButton.layer.borderColor = UIColor.black.cgColor
        giveEvaluationButton.setTitleColor(UIColor.black, for: .normal)
        giveEvaluationButton.layer.borderWidth = 3

        setEvaluationColor(evaluation: serie.voteAverage, label: evaluationPressLabel)
        evaluationPressLabel.text = "\(serie.voteAverage)"

        evaluationReadersLabel.textColor = UIColor.gray
        EvaluationService.getEvaluations(serie: serie) { result in
            if let result = result {
                let roundedResult = Double(round(10*result)/10)
                self.setEvaluationColor(evaluation: roundedResult, label: self.evaluationReadersLabel)
                self.evaluationReadersLabel.text = "\(roundedResult)"
            } else {
                self.evaluationReadersLabel.text = "/"
            }
        }
    }

    /// Function that sets the color for the text of the evaluationLabel depending to the evaluation value.
    private func setEvaluationColor(evaluation: Double, label: UILabel) {
        switch evaluation {
        case 0..<3: label.textColor = UIColor.red
        case 3..<5: label.textColor = UIColor.orange
        case 5..<7: label.textColor = UIColor.blue
        case 7...10: label.textColor = UIColor.green
        default: label.textColor = UIColor.blue
        }
    }

    // MARK: - View Actions
    // Action that sends a notification when the button is tapped.
    @IBAction func evaluateButtonTapped(_ sender: UIButton) {
        let notifName = NSNotification.Name("EvaluateButtonTapped")
        NotificationCenter.default.post(name: notifName, object: nil, userInfo: nil)
    }
}
