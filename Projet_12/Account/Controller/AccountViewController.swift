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
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var imagePicker: UIImagePickerController?
    var imageViewSelected: Int?
    var currentUser: User?
    let segueToUserInfos = "segueToUserInfos"
    let segueToFavoriteSerie = "segueToFavoriteSerie"

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfos()
        imageViewRecognizer()
        accountImageView.layer.borderColor = UIColor.white.cgColor
        accountImageView.layer.borderWidth = 5.0

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self

        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayActivityIndicator(true)
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ImageStorageService.getUserImage(userId: userId) { (data) in
            if let data = data {
                self.accountImageView.image = UIImage(data: data)
            }
        }
        ImageStorageService.getUserBackground(userId: userId) { (data) in
            if let data = data {
                self.backgroundImageView.image = UIImage(data: data)
                self.displayActivityIndicator(false)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let user = currentUser else { return }
        guard segue.identifier == segueToUserInfos,
            let userInfosVC = segue.destination as? UserInfosViewController else {
                return
        }
        userInfosVC.user = user
    }

    private func displayActivityIndicator(_ bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !bool
        userInformationView.isHidden = bool
        accountTableView.isHidden = bool
    }

    private func getUserInfos() {
        guard let userId = Auth.auth().currentUser?.uid else {
            UIAlertController().showAlert(title: "Sorry", message: "No user logged in!",
                                          viewController: self)
            return
        }
        UsersService.getUserInformation(userId: userId) { (user) in
            if let user = user {
                self.currentUser = user
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

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        signOutAlert()
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

    private func saveImageAlert(imageData: Data, imageView: UIImageView) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let alertVC = UIAlertController(title: "Save this image ?",
                                        message: nil,
                                        preferredStyle: .alert)

        let save = UIAlertAction(title: "Save", style: .default) { (act) in
            if imageView == self.accountImageView {
                ImageStorageService.saveUserImage(userId: userId, data: imageData)
            } else if imageView == self.backgroundImageView {
                ImageStorageService.saveUserBackground(userId: userId, data: imageData)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(save)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }

    private func signOutAlert() {
        let alertVC = UIAlertController(title: "Are you sure ?",
                                        message: "Do you want to logout ?",
                                        preferredStyle: .alert)
        let logout = UIAlertAction(title: "Yes", style: .default) { (act) in
            do {
                try Auth.auth().signOut()
                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "AuthenticationNC") else { return }
                self.present(vc, animated: true, completion: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)

        alertVC.addAction(logout)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let data = image.jpegData(compressionQuality: 0.5) else {
            imagePicker?.dismiss(animated: true, completion: nil)
            return
        }
        if imageViewSelected == 1 {
            backgroundImageView.image = image
            imagePicker?.dismiss(animated: true, completion: nil)
            saveImageAlert(imageData: data, imageView: backgroundImageView)
        } else if imageViewSelected == 2 {
            accountImageView.image = image
            imagePicker?.dismiss(animated: true, completion: nil)
            saveImageAlert(imageData: data, imageView: accountImageView)
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
            as? AccountTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.row {
        case 0: cell.configure(title: "Informations personnelles")
        case 1: cell.configure(title: "Séries Favorites")
        default: break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: segueToUserInfos, sender: nil)
        case 1:
            performSegue(withIdentifier: segueToFavoriteSerie, sender: nil)
        default:
            break
        }
    }
}
