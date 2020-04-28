//
//  ForumFavoriteViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 31/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit
import FirebaseAuth

// View Controller to display the favorite topics.
class ForumFavoriteViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var topicsTableView: UITableView!

    // MARK: - View Propeties
    var topics = [Topic]()
    let segueToTopicIdentifier = "segueToTopicFromFavoriteForum"

    // ======================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        topicsTableView.delegate = self
        topicsTableView.dataSource = self

        // Gets the favorite topics of the user.
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
        // Give a topic to TopicVC.
        if segue.identifier == segueToTopicIdentifier,
            let topicVC = segue.destination as? TopicViewController,
            let topic = sender as? Topic {
            topicVC.topic = topic
        }
    }

}

// MARK: - TableView
extension ForumFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTopicCell", for: indexPath)
            as? FavoriteTopicCell else {
            return UITableViewCell()
        }
        let topic = topics[indexPath.row]
        cell.favoriteTopicView.configure(favoriteTopic: topic, indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        // Perform a segue to TopicVC.
        performSegue(withIdentifier: segueToTopicIdentifier, sender: topic)
    }
}
