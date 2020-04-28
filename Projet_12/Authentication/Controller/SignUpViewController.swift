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

// View controller to start the sign up process.
class SignUpViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!

    // ====================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give the email and password to SignUpInfosVC.
        if segue.identifier == "segueToSignUpInfos",
            let signUpInfosVC = segue.destination as? SignUpInfosViewController {
            signUpInfosVC.email = emailTextField.text
            signUpInfosVC.password = passwordTextField.text
        }
    }

    // ====================
    // MARK: - View Action
    // Action that perform a segue to the SignUpInfosVC if the email and password exist.
    @IBAction func passEmailAndPassword(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text,
            email != "", password != ""  else {
            UIAlertController().showAlert(title: "Warning",
                                          message: "Please enter your email and password",
                                          viewController: self)
            return
        }
        performSegue(withIdentifier: "segueToSignUpInfos", sender: nil)
    }
}

// MARK: - Keyboard
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Action that dismiss the keyboard when the view is tapped.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
