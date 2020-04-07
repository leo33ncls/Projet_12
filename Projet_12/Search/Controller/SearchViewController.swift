//
//  SearchViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var seriesTableView: UITableView!

    var seriesResult: SeriesList?
    let segueIdentifier = "segueToSerieDetailsFromSearch"

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        seriesTableView.delegate = self
        seriesTableView.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let serieDetailsVC = segue.destination as? SerieDetailsViewController {
            serieDetailsVC.serie = sender as? Result
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText != "" else {
            return
        }
        print(searchText)
        SeriesService(session: URLSession(configuration: .default))
            .searchSeries(searchText: searchText) { (success, seriesList) in
                if success, let seriesList = seriesList {
                    self.seriesResult = seriesList
                    self.seriesTableView.reloadData()
                } else {
                    print("Search Series Request Error")
                }
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let series = seriesResult else { return 0 }
        return series.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let series = seriesResult else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSerieCell", for: indexPath)
            as? SearchSerieCell else {
            return UITableViewCell()
        }
        let serie = series.results[indexPath.row]
        cell.searchSerieView.configure(serie: serie)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let series = seriesResult else { return }
        let serie = series.results[indexPath.row]
        performSegue(withIdentifier: segueIdentifier, sender: serie)
    }
}
