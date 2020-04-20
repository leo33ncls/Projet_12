//
//  UserInfosViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class UserInfosViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameTextField.delegate = self
        nicknameTextField.delegate = self
        descriptionTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let currentUser = user else {
            UIAlertController().showAlert(title: "Désolé",
                                          message: "Aucun utilisateur trouvé",
                                          viewController: self)
            return
        }
        fullNameTextField.text = currentUser.fullName
        nicknameTextField.text = currentUser.nickname
        descriptionTextView.text = currentUser.description
    }

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

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        fullNameTextField.resignFirstResponder()
        nicknameTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
}

extension UserInfosViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width,
                                                              height: Double.greatestFiniteMagnitude),
                                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                 attributes: [NSAttributedString.Key.font: font],
                                                 context: nil).size
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        var textWidth = textView.frame.width
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding

        let boundingRect = sizeOfString(string: newText, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight

        return numberOfLines <= 6
    }
}
