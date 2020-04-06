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

    var seriesResult: SeriesList?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText != "" else {
            return
        }
        print(searchText)
        SeriesService(session: URLSession(configuration: .default))
            .searchSeries(searchText: searchText) { (success, seriesList) in
                if success, let seriesList = seriesList {
                    self.seriesResult = seriesList
                    print(self.seriesResult)
                    print(seriesList)
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
