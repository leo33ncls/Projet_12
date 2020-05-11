//
//  TopicEditingViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View Controller to edit a topic.
class TopicEditingViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstPostLabel: UILabel!
    @IBOutlet weak var topicTitleTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var editTopicButton: UIButton!

    // MARK: - View Properties
    // The serie received from ForumVC.
    var serie: Serie?

    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        topicTitleTextField.delegate = self
        postTextView.delegate = self
        setTextAndTitle()
        guard let currentSerie = serie else { return }
        self.navigationItem.title = currentSerie.name
    }

    // MARK: - View Actions
    // Actions that creates and saves a topic in the db.
    @IBAction func createTopic(_ sender: UIButton) {
        guard let currentSerie = serie else { return }
        guard let user = Auth.auth().currentUser else { return }
        let topicTitleText = topicTitleTextField.checkTextfield(placeholder: NSLocalizedString("TITLE",
                                                                                               comment: ""))
        let postTVText = checkTextView(textview: postTextView)

        guard let topicTitle = topicTitleText, let postText = postTVText else { return }
        let post = Post(userId: user.uid,
                        date: Date(),
                        text: postText)
        let topic = Topic(serieId: currentSerie.id,
                          topicId: nil,
                          userId: user.uid,
                          date: Date(),
                          serieName: currentSerie.name,
                          title: topicTitle,
                          post: [post])

        ForumService.saveTopic(topic: topic)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - View Functions
    /// Function that checks if the text in the textview is valid and returns the text.
    private func checkTextView(textview: UITextView) -> String? {
        guard let text = textview.text, text != "", text != " " else {
            textview.layer.borderColor = UIColor.red.cgColor
            textview.layer.borderWidth = 1
            return nil
        }
        textview.layer.borderWidth = 0
        return text
    }
}

// MARK: - Keyboard, TextField and TextView
extension TopicEditingViewController: UITextFieldDelegate, UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }

    // Action that dismiss the keyboard when the view is tapped.
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        topicTitleTextField.resignFirstResponder()
        postTextView.resignFirstResponder()
    }
}

// MARK: - Localization
extension TopicEditingViewController {
    /// Function that sets texts and titles of the view depending on the localization.
    private func setTextAndTitle() {
        viewTitleLabel.text = NSLocalizedString("TOPIC_EDITING_TITLE", comment: "Topic creation")
        titleLabel.text = NSLocalizedString("TOPIC_TITLE_LABEL", comment: "Topic title")
        firstPostLabel.text = NSLocalizedString("TOPIC_POST_LABEL", comment: "First post")
        editTopicButton.setTitle(NSLocalizedString("TOPIC_CREATION_BUTTON", comment: "Create topic"),
                                 for: .normal)

        topicTitleTextField
            .attributedPlaceholder = NSAttributedString(string: NSLocalizedString("TITLE", comment: ""),
                                                        attributes: [NSAttributedString.Key.foregroundColor:
                                                            UIColor.placeholderGray])
    }
}
