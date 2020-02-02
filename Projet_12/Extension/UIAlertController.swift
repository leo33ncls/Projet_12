//
//  UIAlertController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 28/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    // Function which shows an alert on a controller with a title and a message
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
