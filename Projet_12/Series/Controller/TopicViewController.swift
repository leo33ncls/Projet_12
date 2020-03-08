//
//  TopicViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {
    @IBOutlet weak var serieNameLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    
    var serie: Result?
    var topic: Topic?
    let segueToPostEditingIdentifier = "segueToPostEditingVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.backgroundColor = UIColor.customGrey
        
        guard let currentSerie = serie else { return }
        guard let currentTopic = topic else { return }
        serieNameLabel.text = currentSerie.name
        topicTitleLabel.text = "Sujet: \(currentTopic.title)"
        
        getPosts(serie: currentSerie, topic: currentTopic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentSerie = serie else { return }
        guard let currentTopic = topic else { return }
        if segue.identifier == segueToPostEditingIdentifier,
            let postEditingVC = segue.destination as? PostEditingViewController {
            postEditingVC.serie = currentSerie
            postEditingVC.topic = currentTopic
        }
    }
    
    @IBAction func goToPagePostEditing(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueToPostEditingIdentifier, sender: nil)
    }
    
    private func getPosts(serie: Result, topic: Topic) {
        ForumService.getPosts(serie: serie, topic: topic) { (postArray) in
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
            as? PostTableViewCell else  {
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
