//
//  Evaluation.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// An user evaluation on a serie
class Evaluation {

    // The id of the user who gives the evaluation
    let userID: String
    
    // The id of the serie which is evaluated
    let serieID: Int
    
    // The evaluation
    var evaluation: Int
    
    /**
     Initializes a new evaluation from a user for a serie.
     
     - Parameters:
        - userID: The id of the user who gives the evaluation.
        - serieID: The id of the serie which is evaluated.
        - evaluation: The evaluation.
     */
    init(userID: String, serieID: Int, evaluation: Int) {
        self.userID = userID
        self.serieID = serieID
        self.evaluation = evaluation
    }
}
