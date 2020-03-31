//
//  TopicViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class TopicViewController: UIViewController {
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var editingPostView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var serie: Result?
    var topic: Topic?

    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.backgroundColor = UIColor.customGrey

        postTextView.delegate = self
        postTextView.isScrollEnabled = false

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

        guard let currentTopic = topic else { return }
        if let currentSerie = serie {
            serieNameLabel.text = currentSerie.name
        } else {
            serieNameLabel.text = String(currentTopic.serieId)
        }
        topicTitleLabel.text = "Sujet: \(currentTopic.title)"

        getPosts(topic: currentTopic)

        FavoriteTopicService.isAFavoriteTopic(topic: currentTopic) { (success) in
            if success {
                self.favoriteButton.tintColor = UIColor.customOrange
            } else {
                self.favoriteButton.tintColor = UIColor.white
            }
        }
    }

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

        postTextView.text = ""
        postTextView.resignFirstResponder()
        editingPostView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    @IBAction func saveTopicAsFavorite(_ sender: UIBarButtonItem) {
        guard let currentTopic = topic else { return }
        FavoriteTopicService.isAFavoriteTopic(topic: currentTopic) { (success) in
            if success {
                FavoriteTopicService.removeFavoriteTopic(topic: currentTopic)
                self.favoriteButton.tintColor = UIColor.white
            } else {
                FavoriteTopicService.saveTopicAsFavorite(topic: currentTopic)
                self.favoriteButton.tintColor = UIColor.customOrange
            }
        }
    }

    private func getPosts(topic: Topic) {
        ForumService.getPosts(topic: topic) { (postArray) in
            if let postArray = postArray {
                topic.post = postArray
                self.postTableView.reloadData()
            } else {
                UIAlertController().showAlert(title: "Désolé !",
                                              message: "Ce sujet n'a aucun publication !",
                                              viewController: self)
            }
        }
    }
}

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

extension TopicViewController: UITextViewDelegate {
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
