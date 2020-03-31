//
//  ForumFavoriteViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 31/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForumFavoriteViewController: UIViewController {
    @IBOutlet weak var topicsTableView: UITableView!

    var topics = [Topic]()
    let segueToTopicIdentifier = "segueToTopicFromFavoriteForum"

    override func viewDidLoad() {
        super.viewDidLoad()
        topicsTableView.delegate = self
        topicsTableView.dataSource = self

        guard let userId = Auth.auth().currentUser?.uid else { return }
        FavoriteTopicService.getFavoriteTopics(userId: userId) { (topicArray) in
            if let topicArray = topicArray {
                self.topics = topicArray
                self.topicsTableView.reloadData()
            } else {
                UIAlertController().showAlert(title: "Désolé !",
                                              message: "Vous n'avez aucun sujet favoris pour le moment !",
                                              viewController: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToTopicIdentifier,
            let topicVC = segue.destination as? TopicViewController,
            let topic = sender as? Topic {
            topicVC.topic = topic
        }
    }

}

extension ForumFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTopicCell", for: indexPath) as? FavoriteTopicCell else {
            return UITableViewCell()
        }
        let topic = topics[indexPath.row]
        cell.favoriteTopicView.configure(favoriteTopic: topic, indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        performSegue(withIdentifier: segueToTopicIdentifier, sender: topic)
    }
}
