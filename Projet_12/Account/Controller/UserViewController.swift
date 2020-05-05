//
//  UserViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 20/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View Controller to display the user informations of a user.
class UserViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: - View Properties
    // The user id received from TopicVC.
    var userId: String?
    var currentUser: User?

    // ==========================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.borderWidth = 5.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertLabel.isHidden = true
        displayActivityIndicator(true)

        guard let currentUserId = userId else {
            displayActivityIndicator(false)
            displayAlertLabel(message: "No user found !")
            return
        }
        getUserInfos(userId: currentUserId)
        getUserImage(userId: currentUserId)
    }

    // ==========================
    // MARK: - View Functions

    /// Function that displays a activity indicator and hides the other views.
    private func displayActivityIndicator(_ bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !bool
        backgroundImageView.isHidden = bool
        userImageView.isHidden = bool
        nicknameLabel.isHidden = bool
        descriptionTextView.isHidden = bool
    }
    
    private func displayAlertLabel(message: String) {
        alertLabel.text = message
        alertLabel.isHidden = false
        backgroundImageView.isHidden = true
        userImageView.isHidden = true
        nicknameLabel.isHidden = true
        descriptionTextView.isHidden = true
    }

    /**
     Function that gets the user informations from the User database and displays them.
     - Parameter userId: The id of the user whose we want the informations.
     */
    private func getUserInfos(userId: String) {
        UsersService.getUserInformation(userId: userId) { (user) in
            self.displayActivityIndicator(false)
            if let user = user {
                self.currentUser = user
                self.nicknameLabel.text = user.nickname
                self.descriptionTextView.text = user.description
            } else {
                self.displayAlertLabel(message: "No user found !")
            }
        }
    }

    /**
     Function that gets the user images from the imageStorage database
     and displays them.
     - Parameter userId: The id of the user whose we want the image.
     */
    private func getUserImage(userId: String) {
        ImageStorageService.getUserImage(userId: userId) { (data) in
            if let data = data {
                self.userImageView.image = UIImage(data: data)
            } else {
                self.userImageView.image = UIImage(named: "defaultUserImage")
            }
        }
        ImageStorageService.getUserBackground(userId: userId) { (data) in
            if let data = data {
                self.backgroundImageView.image = UIImage(data: data)
            } else {
                self.backgroundImageView.image = UIImage(named: "defaultBackground")
            }
        }
    }

    // ==========================
    // MARK: - View Actions
    // Action that dismisses the ViewController
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
