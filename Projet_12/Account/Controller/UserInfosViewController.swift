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
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - View Text
    let fullnamePlaceholder = NSLocalizedString("FULLNAME", comment: "")
    let nicknamePlaceholder = NSLocalizedString("NICKNAME", comment: "")

    // MARK: - View Properties
    // The user received from the AccountVC.
    var user: User?

    // =======================
    // MARK: - View Cycles
    override func viewDidLoad() {
        setTextAndTitle()
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
        if currentUser.description == "nil" {
            descriptionTextView.text = ""
        } else {
            descriptionTextView.text = currentUser.description
        }
    }

    // MARK: - View Actions
    // Action checking if the textFields are completed and presents the saveInfosAlert.
    @IBAction func saveUserInfosChange(_ sender: UIButton) {
        let fullNameText = fullNameTextField.checkTextfield(placeholder: fullnamePlaceholder)
        let nicknameText = nicknameTextField.checkTextfield(placeholder: nicknamePlaceholder)

        guard let fullName =  fullNameText, let nickname = nicknameText else { return }
        guard let description = descriptionTextView.text, description != "" else {
            saveInfosAlert(fullName: fullName, nickname: nickname, description: nil)
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
    private func saveInfosAlert(fullName: String, nickname: String, description: String?) {
        guard let currentUser = user else { return }
        guard currentUser.fullName != fullName || currentUser.nickname != nickname
            || currentUser.description != description else {
            self.navigationController?.popViewController(animated: true)
            return
        }

        let alertVC = UIAlertController(title: NSLocalizedString("SAVE_INFOS_ALERT_TITLE", comment: "Sure ?"),
                                        message: NSLocalizedString("SAVE_INFOS_ALERT_MESSAGE", comment: "Save ?"),
                                        preferredStyle: .alert)
        let save = UIAlertAction(title: NSLocalizedString("YES", comment: ""),
                                 style: .default) { (act) in
            UsersService.updateUserInformation(userId: currentUser.id, fullName: fullName,
                                               nickname: nickname, description: description)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""),
                                   style: .cancel, handler: nil)

        alertVC.addAction(save)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Keyboard and TextView
extension UserInfosViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fullNameTextField {
            textField.restore(placeholder: fullnamePlaceholder)
        } else if textField == nicknameTextField {
            textField.restore(placeholder: nicknamePlaceholder)
        }
    }
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

// MARK: - Localization
extension UserInfosViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        self.navigationItem.title = NSLocalizedString("PERSONAL_INFOS_TITLE", comment: "Personal infos")
        fullnameLabel.text = NSLocalizedString("FULLNAME", comment: "")
        nicknameLabel.text = NSLocalizedString("NICKNAME", comment: "")
        descriptionLabel.text = NSLocalizedString("DESCRIPTION", comment: "")
        saveButton.setTitle(NSLocalizedString("SAVE", comment: ""), for: .normal)

        fullNameTextField
            .attributedPlaceholder = NSAttributedString(string: fullnamePlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
        nicknameTextField
            .attributedPlaceholder = NSAttributedString(string: nicknamePlaceholder,
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
