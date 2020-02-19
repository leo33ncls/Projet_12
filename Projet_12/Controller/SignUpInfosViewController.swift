//
//  SignUpInfosViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SignUpInfosViewController: UIViewController {

    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    var email: String?
   
    @IBAction func saveInformations(_ sender: UIButton) {
        guard let userEmail = email,
            let nickname = nicknameTextField.text, nickname != "",
            let lastName = lastNameTextField.text, lastName != "",
            let firstName = firstNameTextField.text, firstName != "",
            let phone = phoneTextField.text, phone != "" else {
                UIAlertController().showAlert(title: "Attention !", message: "Informations manquantes !", viewController: self)
                return
        }
        let user = User(nickname: nickname, email: userEmail, lastName: lastName,
                        firstName: firstName, phone: phone)
        UsersService.saveUser(user: user)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}
