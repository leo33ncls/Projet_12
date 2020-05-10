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
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!

    // MARK: - View Text
    let emailPlaceholder = NSLocalizedString("EMAIL", comment: "")
    let passwordPlaceholder = NSLocalizedString("PASSWORD", comment: "")

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setTextAndTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
    }

    // ====================
    // MARK: - View Actions

    // Action that closes the View Controller.
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // Action that signes in the user in the application if the email and password are corrected.
    @IBAction func loginAction(_ sender: UIButton) {
        let emailText = emailTextField.checkTextfield(placeholder: emailPlaceholder)
        let passwordText = passwordTextField.checkTextfield(placeholder: passwordPlaceholder)

        guard let email = emailText, let password = passwordText else {
            alertLabel.isHidden = false
            alertLabel.text = NSLocalizedString("ALERT_EMPTY_TEXTFIELD", comment: "Missing infos !")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.alertLabel.isHidden = false
                self.alertLabel.text = error.localizedDescription
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
        alertLabel.isHidden = true
        textField.layer.borderWidth = 0
        if textField == emailTextField {
            emailTextField.restore(placeholder: emailPlaceholder)
        } else if textField == passwordTextField {
            passwordTextField.restore(placeholder: passwordPlaceholder)
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

// MARK: - Localization
extension LoginViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        loginLabel.text = NSLocalizedString("LOGIN_LABEL", comment: "Connexion by email")
        loginButton.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)

        emailTextField
            .attributedPlaceholder = NSAttributedString(string: emailPlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.placeholderGray])
        passwordTextField
            .attributedPlaceholder = NSAttributedString(string: passwordPlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
