//
//  TopicEditingViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class TopicEditingViewController: UIViewController {

    @IBOutlet weak var topicTitleTextField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    
    var serie: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentSerie = serie else { return }
        self.navigationItem.title = currentSerie.name
    }
    
    @IBAction func createTopic(_ sender: UIButton) {
        guard let currentSerie = serie else { return }
        guard let user = Auth.auth().currentUser else { return }

        if let topictitle = topicTitleTextField.text, topictitle != "",
            let postText = postTextView.text, postText != "" {

            let post = Post(userId: user.uid,
                            date: Date(),
                            text: postText)
            let topic = Topic(serieId: currentSerie.id,
                              topicId: nil,
                              userId: user.uid,
                              date: Date(),
                              title: topictitle,
                              post: [post])
            
            ForumService.saveTopic(topic: topic)
            navigationController?.popViewController(animated: true)

        } else {
            UIAlertController().showAlert(title: "Attention",
                                          message: "Informations manquantes !",
                                          viewController: self)
        }
    }
}
