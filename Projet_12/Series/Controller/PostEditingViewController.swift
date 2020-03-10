//
//  PostEditingViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 07/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class PostEditingViewController: UIViewController {
    @IBOutlet weak var postTextView: UITextView!
    
    var serie: Result?
    var topic: Topic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        
        guard let currentSerie = serie else { return }
        self.navigationItem.title = currentSerie.name
    }
    
    @IBAction func savePost(_ sender: UIButton) {
        guard let currentTopic = topic else { return }
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let postText = postTextView.text, postText != "" else {
            UIAlertController().showAlert(title: "Attention !",
                                          message: "Vous devez entrer un commentaire !",
                                          viewController: self)
            return
        }
        let post = Post(userId: userId,
                        date: Date(),
                        text: postText)
        ForumService.savePost(topic: currentTopic, post: post)
        navigationController?.popViewController(animated: true)
    }
}

extension PostEditingViewController: UITextViewDelegate {
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        postTextView.resignFirstResponder()
    }
}
