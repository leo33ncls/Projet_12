//
//  NickNameViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 25/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class NickNameViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameTextField.delegate = self
    }

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

        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}

extension NickNameViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        nicknameTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
