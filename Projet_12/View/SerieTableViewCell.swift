//
//  SerieTableViewCell.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import UIKit

class SerieTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var genreLabel: UILabel!
    
    var serieList: SeriesList?
    //static var serieSelected: Result?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(genreInd: Int) {
        genreLabel.text = Genres.genres[genreInd].genre
        
        SeriesService(session: URLSession(configuration: .default))
            .getSeriesList(genre: Genres.genres[genreInd].id) { (success, seriesList) in
                if success, let seriesList = seriesList {
                    self.serieList = seriesList
                    self.collectionView.reloadData()
                } else {
                    print(Genres.genres[genreInd].id)
                    print("SeriesList Request Error")
                }
        }
    }
    
    /*static func getSerieSelected(callback: (Bool, Result?) -> Void) {
        guard let serie = serieSelected else {
            callback(false, nil)
            return
        }
        callback(true, serie)
    }*/
}

extension SerieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let series = serieList else { return 0 }
        return series.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let series = serieList else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SerieCVCell", for: indexPath) as? SerieCollectionViewCell else {
            return UICollectionViewCell()
        }
        let serie = series.results[indexPath.row]
        cell.configure(serie: serie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let series = serieList else { return }
        let serieSelected = series.results[indexPath.row]
        
        let serieDict: [String: Result] = ["serie": serieSelected]
        let notifName = NSNotification.Name("CollectionViewSelected")
        NotificationCenter.default.post(name: notifName, object: nil, userInfo: serieDict)
    }
}
