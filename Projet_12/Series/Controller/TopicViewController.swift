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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.backgroundColor = UIColor.customGrey
        
        guard let currentSerie = serie else { return }
        guard let currentTopic = topic else { return }
        serieNameLabel.text = currentSerie.name
        topicTitleLabel.text = "Sujet: \(currentTopic.title)"
        
        ForumService.getPosts(serie: currentSerie, topic: currentTopic) { (postArray) in
            if let postArray = postArray {
                currentTopic.post = postArray
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
