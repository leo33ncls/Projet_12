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

    // MARK: - View Outlets
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        setButtonTitle()
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

    // MARK: - View Functions
    /// Function that sets the title of the buttons depending on the localization.
    private func setButtonTitle() {
        emailLoginButton.setTitle(NSLocalizedString("EMAIL_LOGIN_BUTTON", comment: "Connect by email"),
                                  for: .normal)
        signUpButton.setTitle(NSLocalizedString("SIGN_UP_BUTTON", comment: "Sign up"), for: .normal)
    }
}
