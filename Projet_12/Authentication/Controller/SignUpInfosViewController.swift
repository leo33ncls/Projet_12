//
//  SignUpInfosViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

// View controller to save the user informations.
class SignUpInfosViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!

    // MARK: - View Properties
    // Email and password received from SignUpVC.
    var email: String?
    var password: String?

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
    }

    // MARK: - View Actions
    // Action that creates and saves the user in the database.
    @IBAction func saveInformations(_ sender: UIButton) {
        let nicknameText = nicknameTextField.checkTextfield(placeholder: "Pseudo")
        let lastNameText = lastNameTextField.checkTextfield(placeholder: "Nom")
        let firstNameText = firstNameTextField.checkTextfield(placeholder: "Prénom")

        guard let userEmail = email,
            let userPassword = password,
            let nickname = nicknameText,
            let lastName = lastNameText,
            let firstName = firstNameText else {
                alertLabel.isHidden = false
                alertLabel.text = "Informations manquantes !"
                return
        }

        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
            if let error = error {
                self.alertLabel.isHidden = false
                self.alertLabel.text = error.localizedDescription
            } else {
                guard let userId = user?.user.uid else { return }
                let user = User(id: userId, nickname: nickname, email: userEmail,
                                fullName: lastName + firstName, description: nil)
                UsersService.saveUser(user: user)

                // Present the TabBarController.
                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "TabBarController") else { return }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Keyboard
extension SignUpInfosViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
        textField.layer.borderWidth = 0
        if textField == nicknameTextField {
            nicknameTextField.restore(placeholder: "Pseudo")
        } else if textField == lastNameTextField {
            lastNameTextField.restore(placeholder: "Nom")
        } else if textField == firstNameTextField {
            firstNameTextField.restore(placeholder: "Prénom")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Action that dismiss the keyboard when the view is tapped.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
    }
}
