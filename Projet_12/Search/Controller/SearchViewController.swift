//
//  SearchViewController.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 06/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

// View Controller to search series.
class SearchViewController: UIViewController {

    // MARK: - View Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var seriesTableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!

    // MARK: - View Properties
    var seriesResult: SeriesList?
    let segueToSerieDetailsIdentifier = "segueToSerieDetailsFromSearch"

    // ========================
    // MARK: - View Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        seriesTableView.delegate = self
        seriesTableView.dataSource = self
        self.navigationItem.title = NSLocalizedString("SEARCH", comment: "")

        // Blur TapGestureRecognizer
        let blurTapGesture = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurView.addGestureRecognizer(blurTapGesture)
    }

    /// Function that dismisses the keyboard.
    @objc private func blurTapped() {
        searchBar.resignFirstResponder()
        blurView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Give a serie to SerieDetailsVC.
        if segue.identifier == segueToSerieDetailsIdentifier,
            let serieDetailsVC = segue.destination as? SerieDetailsViewController {
            serieDetailsVC.serie = sender as? Serie
        }
    }

    // ========================
    // MARK: - View Functions

    /**
     Function that gets a seriesList according to the user search.
     
     Calling this function sends a request with the text in the searchBar
     and gets some series from the API response.
     
     - Parameters:
        - searchText: The text that the API will search.
        - language: The language in which we want the response.
     */
    private func searchSeries(searchText: String, language: String) {
        SeriesService(session: URLSession(configuration: .default))
            .searchSeries(searchText: searchText, language: language) { (success, seriesList) in
                if success, let seriesList = seriesList {
                    self.seriesResult = seriesList
                    self.seriesTableView.restore()
                    self.seriesTableView.reloadData()
                } else {
                    self.seriesTableView.setEmptyView(title: NSLocalizedString("SEARCH_TABLEVIEW_ALERT_TITLE",
                                                                               comment: "No result"),
                                                      message: NSLocalizedString("SEARCH_TABLEVIEW_ALERT_MESSAGE",
                                                                                 comment: "Advice"))
                }
        }
    }

}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {

    // Send a searchSeries request with the text in the searchBar when the searchButton is clicked
    // and get some series from the response.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        blurView.isHidden = true
        guard let searchText = searchBar.text, searchText != "" else { return }
        if NSLocale.current.languageCode == "fr" {
            searchSeries(searchText: searchText, language: "fr")
        } else {
            searchSeries(searchText: searchText, language: "en")
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        blurView.isHidden = false
        self.searchBar.showsCancelButton = true
    }

    // Refresh searchBar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        blurView.isHidden = true
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let series = seriesResult, series.results.count != 0 else {
            self.seriesTableView.setEmptyView(title: NSLocalizedString("SEARCH_TABLEVIEW_ALERT_TITLE",
                                                                       comment: "No result"),
                                              message: NSLocalizedString("SEARCH_TABLEVIEW_ALERT_MESSAGE",
                                                                         comment: "Advice"))
            return 0
        }
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

        // Perform a segue to SerieDetailsVC
        performSegue(withIdentifier: segueToSerieDetailsIdentifier, sender: serie)
    }
}
