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
    
    var serie: Result?
    let segueToTopicEditingIdentifier = "segueToTopicEditingVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        
        guard let currentSerie = serie else { return }
        serieNameLabel.text = "Forum: \(currentSerie.name)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentSerie = serie else { return }
        if segue.identifier == segueToTopicEditingIdentifier,
            let topicEditingVC = segue.destination as? TopicEditingViewController {
            topicEditingVC.serie = currentSerie
        }
    }
    
    @IBAction func goToTopicEditingPage(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segueToTopicEditingIdentifier, sender: nil)
    }
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
