//
//  Evaluation.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class Evaluation {
    var userID: String
    var serieID: Int
    var evaluation: Int
    
    init(userID: String, serieID: Int, evaluation: Int) {
        self.userID = userID
        self.serieID = serieID
        self.evaluation = evaluation
    }
}
