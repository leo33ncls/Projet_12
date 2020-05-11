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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!

    // MARK: - View Properties
    // Email and password received from SignUpVC.
    var email: String?
    var password: String?

    // MARK: - View Text
    let nicknamePlaceholder = NSLocalizedString("NICKNAME", comment: "")
    let lastNamePlaceholder = NSLocalizedString("LAST_NAME", comment: "")
    let firstNamePlacholder = NSLocalizedString("FIRST_NAME", comment: "")

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        setTextAndTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
    }

    // MARK: - View Actions
    // Action that creates and saves the user in the database.
    @IBAction func saveInformations(_ sender: UIButton) {
        let nicknameText = nicknameTextField.checkTextfield(placeholder: nicknamePlaceholder)
        let lastNameText = lastNameTextField.checkTextfield(placeholder: lastNamePlaceholder)
        let firstNameText = firstNameTextField.checkTextfield(placeholder: firstNamePlacholder)

        guard let userEmail = email,
            let userPassword = password,
            let nickname = nicknameText,
            let lastName = lastNameText,
            let firstName = firstNameText else {
                alertLabel.isHidden = false
                alertLabel.text = NSLocalizedString("ALERT_EMPTY_TEXTFIELD", comment: "Missing infos !")
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

// MARK: - Keyboard and TextField
extension SignUpInfosViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
        if textField == nicknameTextField {
            nicknameTextField.restore(placeholder: nicknamePlaceholder)
        } else if textField == lastNameTextField {
            lastNameTextField.restore(placeholder: lastNamePlaceholder)
        } else if textField == firstNameTextField {
            firstNameTextField.restore(placeholder: firstNamePlacholder)
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

// MARK: - Localization
extension SignUpInfosViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        self.navigationItem.title = NSLocalizedString("SIGN_UP", comment: "")
        titleLabel.text = NSLocalizedString("SIGN_UP_INFOS_TITLE", comment: "Personal Informations")
        saveButton.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)

        nicknameTextField
            .attributedPlaceholder = NSAttributedString(string: nicknamePlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
        lastNameTextField
            .attributedPlaceholder = NSAttributedString(string: lastNamePlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
        firstNameTextField
            .attributedPlaceholder = NSAttributedString(string: firstNamePlacholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
