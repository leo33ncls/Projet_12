//
//  UserInfosViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View Controller to change the user information of the user logged in the application.
class UserInfosViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    // MARK: - View Properties
    // The user received from the AccountVC.
    var user: User?

    // =======================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        fullNameTextField.delegate = self
        nicknameTextField.delegate = self
        descriptionTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentUser = user else {
            // If the user isn't logged in, send them to the Authentication page.
            guard let vc = self.storyboard?
                .instantiateViewController(withIdentifier: "AuthenticationNC") else { return }
            self.present(vc, animated: true, completion: nil)
            return
        }
        // Display the user informations.
        fullNameTextField.text = currentUser.fullName
        nicknameTextField.text = currentUser.nickname
        descriptionTextView.text = currentUser.description
    }

    // MARK: - View Actions
    // Action checking if the textFields are completed and presents the saveInfosAlert.
    @IBAction func saveUserInfosChange(_ sender: UIButton) {
        guard let fullName = fullNameTextField.text, fullName != "" else {
            UIAlertController().showAlert(title: "Warning",
                                          message: "Full name is incomplete !",
                                          viewController: self)
            return
        }
        guard let nickname = nicknameTextField.text, nickname != "" else {
            UIAlertController().showAlert(title: "Warning",
                                          message: "Nickname is unvalid !",
                                          viewController: self)
            return
        }
        guard let description = descriptionTextView.text, description != "" else {
            UIAlertController().showAlert(title: "Warning",
                                          message: "Descritpion is incomplete !",
                                          viewController: self)
            return
        }
        saveInfosAlert(fullName: fullName, nickname: nickname, description: description)
    }

    // ======================
    // MARK: - View Alert
    /**
     Function that presents an alert to make sure that the user wants to save the new informations.

     Calling this function shows an alert asking the user if he wants to save the new informations in the db
     and saves this informations if the user clicks "Yes".

     - Parameters:
        - fullName: The user fullName we want to save.
        - nickname: The user nickname we want to save.
        - description: The user description we want to save.
     */
    private func saveInfosAlert(fullName: String, nickname: String, description: String) {
        guard let currentUser = user else { return }
        let alertVC = UIAlertController(title: "Are you sure ?",
                                        message: "Do you want to save this new informations ?",
                                        preferredStyle: .alert)
        let save = UIAlertAction(title: "Yes", style: .default) { (act) in
            UsersService.updateUserInformation(userId: currentUser.id, fullName: fullName,
                                               nickname: nickname, description: description)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)

        alertVC.addAction(save)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard and TextView
extension UserInfosViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// Get the size of a given string according to its container's width and to its font.
    private func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width,
                                                              height: Double.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                 context: nil).size
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Limit the number of lines of the textView.
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        var textWidth = textView.frame.width
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding

        guard let textViewFont = textView.font else { return false}
        let boundingRect = sizeOfString(string: newText,
                                        constrainedToWidth: Double(textWidth),
                                        font: textViewFont)
        let numberOfLines = boundingRect.height / textViewFont.lineHeight

        return numberOfLines <= 6
    }

    // Action that dismiss the keyboard when the view is tapped.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fullNameTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}
