//
//  NickNameViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View controller to choose a nickname and save the account
class NickNameViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var nicknameTextField: UITextField!

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
    }

    // MARK: - View Actions
    // Action that saves the account in the database
    @IBAction func saveAccount(_ sender: UIButton) {
        guard let currentUser = Auth.auth().currentUser,
            let nickname = nicknameTextField.text, nickname != "",
            let email = currentUser.email,
            let name = currentUser.displayName else {
                print("Saving Error")
            return
        }
        let user = User(id: currentUser.uid, nickname: nickname, email: email, fullName: name, description: nil)
        UsersService.saveUser(user: user)

        // Present the TabBarController
        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Keyboard
extension NickNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // Action that dismiss the keyboard when the view is tapped
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
    }
}
