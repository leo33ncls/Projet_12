//
//  EvaluationService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages evaluations
class EvaluationService {

    // The reference for the Evaluation database
    static let evaluationRef = Database.database().reference().child("Evaluation")

    /**
     Function which saves a evaluation on a serie in the Evaluation database.
     Calling this function saves the user id, the serie id and the evaluation in the Evaluation dabatabase.

     - Parameter evaluation: The evaluation to save in the db.
     */
    static func saveEvaluation(evaluation: Evaluation) {
        let userDictionary: NSDictionary = ["evaluation": evaluation.evaluation]

        evaluationRef.child("\(evaluation.serieID)")
            .child("\(evaluation.userID)")
            .setValue(userDictionary) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Evaluation saved successfully")
            }
        }
    }

    /**
     Function which returns a callback with the average evaluation of a given serie.
     Calling this function observes the evaluations of a serie in the database
     calculs and returns his average evaluation in a callback.

     - Parameters:
        - serie: The serie we want the average evaluation.
        - callback: The callback returning the evaluation.
     */
    static func getEvaluations(serie: Result, callback: @escaping (Double?) -> Void) {
        evaluationRef.child(String(serie.id)).observe(.value) { (snapshot) in
            var sumOfEvaluations = 0.0
            var numbersOfVotes = 0.0

            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                    let dictEvaluation = snap.value as? [String: Double],
                    let evaluation = dictEvaluation["evaluation"] else {
                    callback(nil)
                    return
                }
                sumOfEvaluations += evaluation
                numbersOfVotes += 1
            }

            guard numbersOfVotes != 0 else {
                callback(nil)
                return
            }
            let result = sumOfEvaluations/numbersOfVotes
            callback(result)
        }
    }
}
