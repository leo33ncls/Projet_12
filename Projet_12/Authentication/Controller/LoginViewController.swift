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

// View Controller to login in the application.
class LoginViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // ====================
    // MARK: - View Actions

    // Action that closes the View Controller.
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func checkTextfield(textfield: UITextField, placeholder: String) -> String? {
        guard let text = textfield.text, text != "", text != " " else {
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.layer.borderWidth = 1
            textfield.attributedPlaceholder = NSAttributedString(string: placeholder + " (manquants)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.red])
            return nil
        }
        textfield.layer.borderWidth = 0
        textfield.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor:
                                                                UIColor.placeholderGray])
        return text
    }

    // Action that signes in the user in the application if the email and password are corrected.
    @IBAction func loginAction(_ sender: UIButton) {
        let emailText = checkTextfield(textfield: emailTextField, placeholder: "Email")
        let passwordText = checkTextfield(textfield: passwordTextField, placeholder: "Password")

        guard let email = emailText, let password = passwordText else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                UIAlertController().showAlert(title: "Error",
                                              message: error.localizedDescription,
                                              viewController: self)
            } else {
                // Present the tabBarController.
                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "TabBarController") else { return }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Keyboard
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        if textField == emailTextField {
            textField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.placeholderGray])
        } else if textField == passwordTextField {
            textField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.placeholderGray])
        }
    }

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
