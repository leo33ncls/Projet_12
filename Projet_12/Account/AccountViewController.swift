//
//  AccountViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 07/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var imagePicker: UIImagePickerController?
    var imageViewSelected: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfos()
        imageViewRecognizer()
        accountImageView.layer.borderColor = UIColor.white.cgColor
        accountImageView.layer.borderWidth = 5.0

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
    }

    private func getUserInfos() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        UsersService.getUserInformation(userId: userId) { (user) in
            if let user = user {
                self.nicknameLabel.text = user.nickname
                self.descriptionTextView.text = user.description
            } else {
                UIAlertController().showAlert(title: "Sorry", message: "No user found",
                                              viewController: self)
            }
        }
    }

    private func imageViewRecognizer() {
        backgroundImageView.isUserInteractionEnabled = true
        accountImageView.isUserInteractionEnabled = true

        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                    action: #selector(setBackgroundImageViewSelected))
        backgroundImageView.addGestureRecognizer(backgroundTapGestureRecognizer)

        let accountTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(setAccountImageViewSelected))
        accountImageView.addGestureRecognizer(accountTapGestureRecognizer)
    }

    @objc private func setBackgroundImageViewSelected() {
        imageViewSelected = 1
        imageViewAlert()
    }

    @objc private func setAccountImageViewSelected() {
        imageViewSelected = 2
        imageViewAlert()
    }

    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }

    private func imageViewAlert() {
        guard let imagePickerController = imagePicker else { return }
        let alertVC = UIAlertController(title: "Choice a media",
                                        message: nil,
                                        preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: "Camera", style: .default) { (act) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (act) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(camera)
        alertVC.addAction(photoLibrary)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if imageViewSelected == 1,
            let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            backgroundImageView.image = editedImage
        } else if imageViewSelected == 1,
            let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            backgroundImageView.image = originalImage
        } else if imageViewSelected == 2,
            let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            accountImageView.image = editedImage
        } else if imageViewSelected == 2,
            let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            accountImageView.image = originalImage
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}
