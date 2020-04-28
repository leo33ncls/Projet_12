//
//  ForumViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View Controller to display the forum (list of topics).
class ForumViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var topicsTableView: UITableView!
    @IBOutlet weak var serieNameLabel: UILabel!

    // MARK: - View Properties
    // The serie received from SerieDetailsVC.
    var serie: Serie?
    var topics = [Topic]()
    let segueToTopicEditingIdentifier = "segueToTopicEditingVC"
    let segueToTopicIdentifier = "segueToTopicVC"

    // =====================
    // MARK: - View Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        topicsTableView.delegate = self
        topicsTableView.dataSource = self

        guard let currentSerie = serie else { return }
        serieNameLabel.text = "Forum: \(currentSerie.name)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        // Gets the topics of the serie.
        guard let currentSerie = serie else { return }
        ForumService.getTopics(serie: currentSerie) { (topicArray) in
            if let topicArray = topicArray {
                self.topics = topicArray
                self.topicsTableView.reloadData()
            } else {
                UIAlertController().showAlert(title: "Désolé !",
                                              message: "Aucun sujet pour le moment !",
                                              viewController: self)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentSerie = serie else { return }
        if segue.identifier == segueToTopicEditingIdentifier,
            let topicEditingVC = segue.destination as? TopicEditingViewController {
            // Give the serie to TopicEditingVC.
            topicEditingVC.serie = currentSerie
        } else if segue.identifier == segueToTopicIdentifier,
            let topicVC = segue.destination as? TopicViewController,
            let topic = sender as? Topic {
            // Give the topic to TopicVC.
            topicVC.topic = topic
        }
    }

    // =====================
    // MARK: - View Actions
    // Action that performs a segue to TopicEditingVC.
    @IBAction func goToTopicEditingPage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueToTopicEditingIdentifier, sender: nil)
    }
}

// MARK: - TableView
extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as? TopicCell else {
            return UITableViewCell()
        }
        let topic = topics[indexPath.row]
        cell.topicCellView.configure(topic: topic, indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        // Perform a segue to TopicVC.
        performSegue(withIdentifier: segueToTopicIdentifier, sender: topic)
    }
}
