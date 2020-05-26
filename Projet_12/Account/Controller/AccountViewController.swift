//
//  AccountViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 07/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// View Controller to display the user informations of the user logged in the application.
class AccountViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - View Properties
    var imagePicker: UIImagePickerController?
    var imageViewSelected: UIImageView?
    var currentUser: User?
    let segueToUserInfosIdentifier = "segueToUserInfos"
    let segueToFavoriteSerieIdentifier = "segueToFavoriteSerie"

    // ========================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("ACCOUNT", comment: "")
        imageViewRecognizer()

        accountImageView.layer.borderColor = UIColor.white.cgColor
        accountImageView.layer.borderWidth = 5.0

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self

        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView()

        guard let userId = Auth.auth().currentUser?.uid else {
            // If the user isn't logged in, send them to the Authentication page.
            guard let vc = self.storyboard?
                .instantiateViewController(withIdentifier: "AuthenticationNC") else { return }
            self.present(vc, animated: true, completion: nil)
            return
        }
        getUserImage(userId: userId)
        getUserBackground(userId: userId)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        displayActivityIndicator(true)
        guard let userId = Auth.auth().currentUser?.uid else {
            displayActivityIndicator(false)

            // If the user isn't logged in, send them to the Authentication page.
            guard let vc = self.storyboard?
                .instantiateViewController(withIdentifier: "AuthenticationNC") else { return }
            self.present(vc, animated: true, completion: nil)
            return
        }
        getUserInfos(userId: userId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give the user to UserInfosVC.
        guard let user = currentUser else { return }
        guard segue.identifier == segueToUserInfosIdentifier,
            let userInfosVC = segue.destination as? UserInfosViewController else {
                return
        }
        userInfosVC.user = user
    }

    // =======================
    // MARK: - View Functions

    /// Function that displays a activity indicator and hides the other views.
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

    /**
     Function that gets the user informations from the User database
     and displays them in the userInformationView.
     - Parameter userId: The id of the user whose we want the informations.
    */
    private func getUserInfos(userId: String) {
        UsersService(FIRDatabase: Database.database()).getUserInformation(userId: userId) { (user) in
            self.displayActivityIndicator(false)
            if let user = user {
                self.currentUser = user
                self.nicknameLabel.text = user.nickname
                guard let description = user.description else {
                    self.descriptionTextView.textColor = UIColor.lightGray
                    self.descriptionTextView.text = NSLocalizedString("NO_DESCRIPTION", comment: "")
                    return
                }
                self.descriptionTextView.textColor = UIColor.black
                self.descriptionTextView.text = description
            } else {
                UIAlertController().showAlert(title: NSLocalizedString("SORRY", comment: ""),
                                              message: NSLocalizedString("NO_USER_ALERT", comment: ""),
                                              viewController: self)
            }
        }
    }

    /**
     Function that gets the user image from the imageStorage and displays it in the accountImageView.
     - Parameter userId: The id of the user for which we want the image.
     */
    private func getUserImage(userId: String) {
        ImageStorageService.getUserImage(userId: userId) { (data) in
            if let data = data {
                self.accountImageView.image = UIImage(data: data)
            } else {
                self.accountImageView.image = UIImage(named: "defaultUserImage")
            }
        }
    }

    /**
     Function that gets the background image from a user in the imageStorage
     and displays it in the backgroundImageView.
     - Parameter userId: The id of the user for which we want the backgroundImage.
     */
    private func getUserBackground(userId: String) {
        ImageStorageService.getUserBackground(userId: userId) { (data) in
            if let data = data {
                self.backgroundImageView.image = UIImage(data: data)
            } else {
                self.backgroundImageView.image = UIImage(named: "defaultBackground")
            }
        }
    }

    /// Function that adds a tapGestureRecognizer to accountImageView and backgroundImageView.
    private func imageViewRecognizer() {
        backgroundImageView.isUserInteractionEnabled = true
        accountImageView.isUserInteractionEnabled = true

        let backgroundTapGesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(setBackgroundImageViewSelected(_:)))
        backgroundImageView.addGestureRecognizer(backgroundTapGesture)

        let accountTapGesture = UITapGestureRecognizer(target: self,
                                                       action: #selector(setAccountImageViewSelected(_:)))
        accountImageView.addGestureRecognizer(accountTapGesture)
    }

    /**
     Function that sets the backgroundImageView as the selected imageView and presents the imageViewAlert
     when the backgroundImageView is tapped.
    */
    @objc private func setBackgroundImageViewSelected(_ sender: UIGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        imageViewSelected = imageView
        imageViewAlert()
    }

    /**
     Function that sets the AccountImageView as the selected imageView and presents the imageViewAlert
     when the accountImageView is tapped.
     */
    @objc private func setAccountImageViewSelected(_ sender: UIGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        imageViewSelected = imageView
        imageViewAlert()
    }

    /**
     Function that saves the user image.
     
     Calling this function shows an alert asking the user if he wants to save the image in the db
     and saves the image if the user clicks "save".
     
     - Parameters:
     - imageData: The data of the image chosen by the user.
     - imageView: The imageView selected by the user to receive this image.
     */
    private func saveImage(imageData: Data, imageView: UIImageView?) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let imageView = imageView else { return }
        if imageView == self.accountImageView {
            ImageStorageService.saveUserImage(userId: userId, data: imageData)
        } else if imageView == self.backgroundImageView {
            ImageStorageService.saveUserBackground(userId: userId, data: imageData)
        }
    }

    // ==========================
    // MARK: - View Actions
    // Action that presents the signOutAlert
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        signOutAlert()
    }

    // ==========================
    // MARK: - View Alert

    /**
     Function that presents an alert allowing the user to chooce a media for the imagePicker.

     Calling this function shows an alert allowing the user to choose between the camera
     or the photo library to pick an image for a image view.
     */
    private func imageViewAlert() {
        guard let imagePickerController = imagePicker else { return }
        let alertVC = UIAlertController(title: NSLocalizedString("MEDIA_ALERT_TITLE", comment: "Choose a media"),
                                        message: nil,
                                        preferredStyle: .actionSheet)

        let camera = UIAlertAction(title: NSLocalizedString("CAMERA_ALERT_ACTION", comment: "Camera"),
                                   style: .default) { (act) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let photoLibrary = UIAlertAction(title: NSLocalizedString("PHOTO_ALERT_ACTION", comment: "Photo Library"),
                                         style: .default) { (act) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""),
                                   style: .cancel, handler: nil)

        alertVC.addAction(camera)
        alertVC.addAction(photoLibrary)
        alertVC.addAction(cancel)
        self.present(alertVC, animated: true, completion: nil)
    }

    /**
     Function that presents an alert to make sure that the user wants to log out.
     
     Calling this function shows an alert asking the user if he wants to log out;
     signs out the user if he clicks "Yes" and presents the AuthenticationVC.
     */
    private func signOutAlert() {
        let alertVC = UIAlertController(title: NSLocalizedString("SIGN_OUT_ALERT_TITLE", comment: "Sure ?"),
                                        message: NSLocalizedString("SIGN_OUT_ALERT_MESSAGE", comment: "Log out ?"),
                                        preferredStyle: .alert)
        let logout = UIAlertAction(title: NSLocalizedString("YES", comment: ""),
                                   style: .default) { (act) in
            do {
                try Auth.auth().signOut()
                guard let vc = self.storyboard?
                    .instantiateViewController(withIdentifier: "AuthenticationNC") else { return }
                self.present(vc, animated: true, completion: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        let cancel = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""),
                                   style: .cancel, handler: nil)

        alertVC.addAction(logout)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker
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
        imageViewSelected?.image = image
        imagePicker?.dismiss(animated: true, completion: nil)
        saveImage(imageData: data, imageView: imageViewSelected)
    }
}

// MARK: - TableView
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
        case 0: cell.configure(title: NSLocalizedString("PERSONAL_INFOS_CELL", comment: "Personal infos"))
        case 1: cell.configure(title: NSLocalizedString("FAVORITE_SERIES_CELL", comment: "Séries favorites"))
        default: break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            // Perform a segue to UserInfosVC.
            performSegue(withIdentifier: segueToUserInfosIdentifier, sender: nil)
        case 1:
            // Perform a segue to FavoriteSerieVC.
            performSegue(withIdentifier: segueToFavoriteSerieIdentifier, sender: nil)
        default:
            break
        }
    }
}
