//
//  AuthenticationViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth

class AuthenticationViewController: UIViewController {

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Checking if the user is already logged in.
        guard Auth.auth().currentUser != nil else {
            return
        }
        guard let vc = self.storyboard?
            .instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.present(vc, animated: true, completion: nil)
    }
}
