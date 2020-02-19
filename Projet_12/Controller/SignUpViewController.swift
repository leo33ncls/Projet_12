//
//  SignUpViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 28/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSignUpInfos", let signUpInfosVC = segue.destination as? SignUpInfosViewController {
            signUpInfosVC.email = emailTextField.text
        }
    }
    
    @IBAction func createAccount(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != ""  else {
            UIAlertController().showAlert(title: "Warning",
                                          message: "Please enter your email and password",
                                          viewController: self)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "segueToSignUpInfos", sender: nil)
            } else {
                UIAlertController().showAlert(title: "Error",
                                              message: error?.localizedDescription ?? "Error has occured",
                                              viewController: self)
            }
        }
    }
}
