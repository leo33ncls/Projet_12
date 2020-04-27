//
//  ForumViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController {
    @IBOutlet weak var topicsTableView: UITableView!
    @IBOutlet weak var serieNameLabel: UILabel!

    var serie: Serie?
    var topics = [Topic]()
    let segueToTopicEditingIdentifier = "segueToTopicEditingVC"
    let segueToTopicIdentifier = "segueToTopicVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        topicsTableView.delegate = self
        topicsTableView.dataSource = self

        guard let currentSerie = serie else { return }
        serieNameLabel.text = "Forum: \(currentSerie.name)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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
            topicEditingVC.serie = currentSerie
        } else if segue.identifier == segueToTopicIdentifier,
            let topicVC = segue.destination as? TopicViewController,
            let topic = sender as? Topic {
            topicVC.topic = topic
        }
    }

    @IBAction func goToTopicEditingPage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueToTopicEditingIdentifier, sender: nil)
    }
}

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
        performSegue(withIdentifier: segueToTopicIdentifier, sender: topic)
    }
}
