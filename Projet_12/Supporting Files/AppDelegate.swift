//
//  AppDelegate.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/01/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:])
        -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any)
        -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let rootVC = self.window?.rootViewController,
                    let id = Auth.auth().currentUser?.uid else { return }

                let ref = UsersService(FIRDatabase: Database.database()).usersDTBRef.child(id)
                ref.observe(.value) { (snapshot) in
                    if snapshot.exists() {
                        guard let vc = storyboard.instantiateViewController(withIdentifier: "TabBarController")
                            as? UITabBarController else { return }
                        rootVC.present(vc, animated: true, completion: nil)
                    } else {
                        guard let vc = storyboard.instantiateViewController(withIdentifier: "NicknameVC")
                            as? NickNameViewController else { return }
                        rootVC.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
