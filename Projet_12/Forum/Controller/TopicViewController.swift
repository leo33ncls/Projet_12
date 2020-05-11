//
//  TopicViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View Controller to display a topic (list of posts).
class TopicViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var editingPostView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    // MARK: - View Properties
    // The topic received from ForumVC or from ForumFavoriteVC.
    var topic: Topic?
    let segueToUserIdentifier = "segueToUserVC"

    // ========================
    // MARK: - View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self

        postTextView.delegate = self
        postTextView.isScrollEnabled = false

        // Observe the notification sent when a nickname is tapped.
        let name = NSNotification.Name(rawValue: "NicknameTapped")
        NotificationCenter.default
            .addObserver(self, selector: #selector(nicknameTapped(_:)), name: name, object: nil)

        // Keyboard Notification.
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(notification:)),
                           name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardWillHide(notification:)),
                           name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

        guard let currentTopic = topic else { return }
        serieNameLabel.text = currentTopic.serieName
        topicTitleLabel.text = NSLocalizedString("TOPIC", comment: "") + ": \(currentTopic.title)"

        getPosts(topic: currentTopic)

        // Set the color of the favoriteButton.
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FavoriteTopicService.isAFavoriteTopic(userId: userId, topic: currentTopic) { (success) in
            if success {
                self.favoriteButton.tintColor = UIColor.customOrange
            } else {
                self.favoriteButton.tintColor = UIColor.white
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give the userId of a post to UserVC.
        guard segue.identifier == segueToUserIdentifier,
            let userVC = segue.destination as? UserViewController,
            let userId = sender as? String else {
            return
        }
        userVC.userId = userId
    }

    @objc func nicknameTapped(_ notification: NSNotification) {
        guard let userId = notification.userInfo?["userId"] as? String else {
            return
        }
        // Perform a segue to UserVC
        performSegue(withIdentifier: segueToUserIdentifier, sender: userId)
    }

    // =====================
    // MARK: - View Actions

    // Action that creates and saves a post.
    @IBAction func savePost(_ sender: UIButton) {
        guard let currentTopic = topic else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let postText = postTextView.text, postText != "" else {
            postTextView.resignFirstResponder()
            return
        }
        let post = Post(userId: userId,
                        date: Date(),
                        text: postText)
        ForumService.savePost(topic: currentTopic, post: post)

        // Refresh the postTextView.
        postTextView.text = ""
        postTextView.resignFirstResponder()
        editingPostView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    // Action that saves or removes the topic in the FavoriteTopic database.
    @IBAction func saveTopicAsFavorite(_ sender: UIBarButtonItem) {
        guard let currentTopic = topic else { return }
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        FavoriteTopicService.isAFavoriteTopic(userId: currentUser, topic: currentTopic) { (success) in
            if success {
                FavoriteTopicService.removeFavoriteTopic(userId: currentUser, topic: currentTopic)
                self.favoriteButton.tintColor = UIColor.white
            } else {
                FavoriteTopicService.saveTopicAsFavorite(userId: currentUser, topic: currentTopic)
                self.favoriteButton.tintColor = UIColor.customOrange
            }
        }
    }

    // =====================
    // MARK: - View Functions
    /**
     Function that gets all the post of the topic.
     - Parameter topic: The topic for which we want to get its posts.
    */
    private func getPosts(topic: Topic) {
        ForumService.getPosts(topic: topic) { (postArray) in
            if let postArray = postArray {
                topic.post = postArray
                self.postTableView.restore()
                self.postTableView.reloadData()
            } else {
                self.postTableView.setEmptyView(title: NSLocalizedString("TOPIC_TABLEVIEW_ALERT_TITLE",
                                                                         comment: "Sorry"),
                                                message: NSLocalizedString("TOPIC_TABLEVIEW_ALERT_MESSAGE",
                                                                           comment: "No post"))
            }
        }
    }
}

// MARK: - TableView
extension TopicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentTopic = topic else {
            return 0
        }
        return currentTopic.post.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentTopic = topic else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
            as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post = currentTopic.post[indexPath.row]
        cell.postView.configure(post: post)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 200
        return UITableView.automaticDimension
    }
}

// MARK: - Keyboard and postTextView
extension TopicViewController: UITextViewDelegate {

    // Function which makes the textView size dynamic when the text changes.
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width,
                          height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        editingPostView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                if estimatedSize.height > 133 {
                    constraint.constant = 133
                    textView.isScrollEnabled = true
                } else {
                    constraint.constant = estimatedSize.height + 14
                }
            }
        }
    }

    /// Function which moves up the view when the keyboard appears.
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo as NSDictionary? else { return }
        guard let keyboardFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

        let keyboardSize = keyboardFrame.cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height

        guard let keyboardAnimationTime = info[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? NSNumber as? CGFloat else { return }

        UIView.animate(withDuration: TimeInterval(keyboardAnimationTime), delay: 0,
                       options: .curveEaseInOut, animations: {
                        self.view.frame = CGRect(x: 0,
                                                 y: (self.view.frame.origin.y - keyboardHeight),
                                                 width: self.view.bounds.width,
                                                 height: self.view.bounds.height)
        }, completion: nil)
    }

    /// Function which moves back the view when the keyboard disappears.
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let info: NSDictionary = notification.userInfo as NSDictionary? else { return }
        guard let keyboardFrame = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }

        let keyboardSize = keyboardFrame.cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height

        guard let keyboardAnimationTime = info[UIResponder.keyboardAnimationDurationUserInfoKey]
            as? NSNumber as? CGFloat else { return }

        UIView.animate(withDuration: TimeInterval(keyboardAnimationTime), delay: 0,
                       options: .curveEaseInOut, animations: {
                        self.view.frame = CGRect(x: 0,
                                                 y: (self.view.frame.origin.y + keyboardHeight),
                                                 width: self.view.bounds.width,
                                                 height: self.view.bounds.height)
        }, completion: nil)
    }
}
