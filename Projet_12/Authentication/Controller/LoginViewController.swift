//
//  LoginViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 28/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func loginAction(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email != "", password != "" else {
                UIAlertController().showAlert(title: "Warning",
                                              message: "Please enter your email and password",
                                              viewController: self)
                return
        }

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                UIAlertController().showAlert(title: "Error",
                                              message: error.localizedDescription,
                                              viewController: self)
            } else {
                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "TabBarController") else { return }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    emailTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
