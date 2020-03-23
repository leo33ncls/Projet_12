//
//  FavoriteTopicService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 23/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages the favorite topics
class FavoriteTopicService {

    // The reference for the Favorite Topic database
    static let favoriteTopicRef = Database.database().reference().child("FavoriteTopic")

    /**
     Function which saves a topic on a serie in the FavoriteTopic database.
     Calling this function saves the user id, the serie id and the topic id in the FavoriteTopic dabatabase.
     
     - Parameter topic: The topic to save as favorite in the db.
     */
    static func saveTopicAsFavorite(topic: Topic) {
        guard let topicID = topic.topicId else { return }

        favoriteTopicRef.child("\(topic.userId)")
            .child("\(topic.serieId)")
            .child(topicID)
            .setValue(topicID) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Topic saved successfully as favorite")
                }
        }
    }

    static func isAFavoriteTopic(topic: Topic, callback: @escaping (Bool) -> Void) {
        guard let topicID = topic.topicId else {
            callback(false)
            return
        }

        favoriteTopicRef.child("\(topic.userId)")
            .child("\(topic.serieId)").child("\(topicID)")
            .observeSingleEvent(of: .value) { (datasnapshot) in
                if datasnapshot.exists() {
                    callback(true)
                } else {
                    callback(false)
                }
        }
    }

    static func removeFavoriteTopic(topic: Topic) {
        guard let topicID = topic.topicId else { return }

        favoriteTopicRef.child("\(topic.userId)")
            .child("\(topic.serieId)").child("\(topicID)").removeValue { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Topic removed from favorite")
                }
        }
    }
}
