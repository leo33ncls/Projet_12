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

class SignUpInfosViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!

    var email: String?
    var password: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
    }

    @IBAction func saveInformations(_ sender: UIButton) {
        guard let userEmail = email,
            let userPassword = password,
            let nickname = nicknameTextField.text, nickname != "",
            let lastName = lastNameTextField.text, lastName != "",
            let firstName = firstNameTextField.text, firstName != "" else {
                UIAlertController().showAlert(title: "Attention !",
                                              message: "Informations manquantes !",
                                              viewController: self)
                return
        }

        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (user, error) in
            if let error = error {
                UIAlertController().showAlert(title: "Error",
                                              message: error.localizedDescription,
                                              viewController: self)
            } else {
                guard let userId = user?.user.uid else { return }
                let user = User(id: userId, nickname: nickname, email: userEmail,
                                fullName: lastName + firstName, description: nil)
                UsersService.saveUser(user: user)

                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "TabBarController") else { return }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension SignUpInfosViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
