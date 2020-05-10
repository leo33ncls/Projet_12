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

    // MARK: - View Text
    let emailPlaceholder = NSLocalizedString("EMAIL", comment: "")
    let passwordPlaceholder = NSLocalizedString("PASSWORD", comment: "")

    // ====================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setTextAndTitle()
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
        let emailText = emailTextField.checkTextfield(placeholder: emailPlaceholder)
        let passwordText = passwordTextField.checkTextfield(placeholder: passwordPlaceholder)

        guard emailText != nil && passwordText != nil else { return }
        performSegue(withIdentifier: "segueToSignUpInfos", sender: nil)
    }
}

// MARK: - Keyboard
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
extension SignUpViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        self.navigationItem.title = NSLocalizedString("SIGN_UP", comment: "")
        nextButton.setTitle(NSLocalizedString("NEXT", comment: ""), for: .normal)

        emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder,
                                                                  attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.placeholderGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder,
                                                                  attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.placeholderGray])
    }
}
