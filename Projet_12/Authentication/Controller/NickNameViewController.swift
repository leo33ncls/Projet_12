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
   
    @IBAction func saveAccount(_ sender: UIButton) {
        guard let currentUser = Auth.auth().currentUser,
            let nickname = nicknameTextField.text, nickname != "",
            let email = currentUser.email,
            let name = currentUser.displayName,
            let phone = currentUser.phoneNumber else {
                print(Auth.auth().currentUser?.uid)
                print(Auth.auth().currentUser?.email)
                print(Auth.auth().currentUser?.displayName)
                print(Auth.auth().currentUser?.phoneNumber)
                print("Saving Error")
            return
        }
        let user = User(id: currentUser.uid, nickname: nickname, email: email,
                        lastName: name, firstName: name, phone: phone)
        UsersService.saveUser(user: user)
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}
