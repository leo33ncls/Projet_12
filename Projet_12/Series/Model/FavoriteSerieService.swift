//
//  FavoriteSerieService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 15/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages the favorite series.
class FavoriteSerieService {

    /// The reference for the Favorite Serie database.
    static let favoriteSerieRef = Database.database().reference().child("FavoriteSerie")

    /// The reference for the Forum database.
    static let forumRef = Database.database().reference().child("Forum")

    /**
     Function which saves a serie for a user in the FavoriteSerie database.
     - Calling this function saves the user id and the serie id in the FavoriteSerie dabatabase.

     - Parameters:
        - userId: The id of the user saving the serie as favorite.
        - serie: The serie to save as favorite in the db.
     */
    static func saveSerieAsFavorite(userId: String, serie: Serie) {
        favoriteSerieRef.child(userId)
            .child(String(serie.id))
            .setValue(serie.id) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Serie saved successfully as favorite")
                }
        }
    }

    /**
     Function which returns a callback with a boolean that tells if the serie is a favorite.

     Calling this function observes if the serie exists in the FavoriteSerie database for a given user
     and returns a boolean in a callback to tells if the serie exists.

     - Parameters:
        - userId: The id of the user for which we want to check if the serie is one of his favorites.
        - serie: The serie we want check if it's a favorite.
        - callback: The callback returning a boolean that tells if the topic is a favorite.
     */
    static func isAFavoriteSerie(userId: String, serie: Serie, callback: @escaping (Bool) -> Void) {
        favoriteSerieRef.child(userId)
            .child(String(serie.id))
            .observeSingleEvent(of: .value) { (datasnapshot) in
                if datasnapshot.exists() {
                    callback(true)
                } else {
                    callback(false)
                }
        }
    }

    /**
     Function which removes a serie in the FavoriteSerie database.

     Calling this function removes a given serie for a given user thanks to their id
     in the FavoriteSerie dabatabase.

     - Parameters:
        - userId: The id of the user for which we want to remove the serie from his favorites.
        - serie: The serie to remove from favorite in the db.
     */
    static func removeFavoriteSerie(userId: String, serie: Serie) {
        favoriteSerieRef.child(userId)
            .child(String(serie.id)).removeValue { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Serie removed from favorite")
                }
        }
    }

    /**
     Function which returns a callback with the IDs of the favorite series of a given user.

     Calling this function observes the IDs of the favorite series of the user in the FavoriteSerie database
     and returns all the IDs of his favorite series in a callback.
     
     - Parameters:
        - userId: The id of the user for which we want the favorite series.
        - callback: The callback returning all the favorite series IDs of the user.
     */
    static func getFavoriteSerieId(userId: String,
                                   callback: @escaping ([Int]?) -> Void) {
        favoriteSerieRef.child(userId).observe(.value) { (snapshot) in
            var favoritesSeries = [Int]()
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                    let serieId = Int(snap.key) else {
                        callback(nil)
                        return
                }
                favoritesSeries.append(serieId)
            }
            callback(favoritesSeries)
        }
    }
}
