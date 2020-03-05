//
//  EvaluationViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class EvaluationViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var evaluationSlider: UISlider!
    @IBOutlet weak var evaluationLabel: UILabel!
    @IBOutlet weak var validateButton: UIButton!
    
    var serie: Result?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentSerie = serie else { return }
        self.navigationItem.title = currentSerie.name
        questionLabel.text = "Quelle note donneriez vous à \(currentSerie.name) ?"
        validateButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        evaluationLabel.text = "\(currentValue)/10"
    }
    
    @IBAction func validateButtonTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else { return }
        guard let currentSerie = serie else { return }
        let evaluation = Evaluation(userID: user.uid,
                                    serieID: currentSerie.id,
                                    evaluation: Int(evaluationSlider.value))
        EvaluationService.saveEvaluation(evaluation: evaluation)
        navigationController?.popViewController(animated: true)
    }
}
