//
//  NickNameViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View controller to choose a nickname and save the account.
class NickNameViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var nicknameTitleLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!

    // MARK: - View Text
    let nicknamePlaceholder = NSLocalizedString("NICKNAME", comment: "")

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        setTextAndTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
    }

    // MARK: - View Actions
    // Action that saves the account in the database.
    @IBAction func saveAccount(_ sender: UIButton) {
        let nicknameText = nicknameTextField.checkTextfield(placeholder: nicknamePlaceholder)

        guard let currentUser = Auth.auth().currentUser,
            let nickname = nicknameText,
            let email = currentUser.email,
            let name = currentUser.displayName else {
                alertLabel.isHidden = false
                alertLabel.text = NSLocalizedString("ALERT_EMPTY_TEXTFIELD", comment: "Missing infos !")
            return
        }
        let user = User(id: currentUser.uid, nickname: nickname, email: email, fullName: name, description: nil)
        UsersService.saveUser(user: user)

        // Present the TabBarController.
        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Keyboard and TextField
extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
        textField.restore(placeholder: nicknamePlaceholder)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Action that dismiss the keyboard when the view is tapped.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
    }
}

// MARK: - Localization
extension NickNameViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        nicknameTitleLabel.text = NSLocalizedString("NICKNAME_TITLE_LABEL", comment: "Choose nickname")
        saveButton.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)

        nicknameTextField
            .attributedPlaceholder = NSAttributedString(string: nicknamePlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
