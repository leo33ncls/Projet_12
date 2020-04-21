//
//  UserViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var userId: String?
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 5.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentUserId = userId else {
            UIAlertController().showAlert(title: "Sorry",
                                          message: "No user found",
                                          viewController: self)
            return
        }
        getUserInfos(userId: currentUserId)
        getUserImage(userId: currentUserId)
    }

    private func getUserInfos(userId: String) {
        UsersService.getUserInformation(userId: userId) { (user) in
            if let user = user {
                self.currentUser = user
                self.nicknameLabel.text = user.nickname
                self.descriptionTextView.text = user.description
            } else {
                UIAlertController().showAlert(title: "Sorry",
                                              message: "No user found",
                                              viewController: self)
            }
        }
    }

    private func getUserImage(userId: String) {
        ImageStorageService.getUserImage(userId: userId) { (data) in
            if let data = data {
                self.userImageView.image = UIImage(data: data)
            }
        }
        ImageStorageService.getUserBackground(userId: userId) { (data) in
            if let data = data {
                self.backgroundImageView.image = UIImage(data: data)
            }
        }
    }

    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
