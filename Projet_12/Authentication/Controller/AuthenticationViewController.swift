//
//  AuthenticationViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import GoogleSignIn

class AuthenticationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //GIDSignIn.sharedInstance()?.signIn()
    }
}
