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
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
    }

    // MARK: - View Actions
    // Action that saves the account in the database.
    @IBAction func saveAccount(_ sender: UIButton) {
        let nicknameText = nicknameTextField.checkTextfield(placeholder: "Nickname")

        guard let currentUser = Auth.auth().currentUser,
            let nickname = nicknameText,
            let email = currentUser.email,
            let name = currentUser.displayName else {
                alertLabel.isHidden = false
                alertLabel.text = "Informations manquantes !"
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

// MARK: - Keyboard
extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
        textField.layer.borderWidth = 0
        textField.restore(placeholder: "Nickname")
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
