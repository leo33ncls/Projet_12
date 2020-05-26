//
//  FavoriteTopicService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 23/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages the favorite topics.
class FavoriteTopicService {

    /// The reference for the Favorite Topic database.
    var favoriteTopicRef = Database.database().reference().child("FavoriteTopic")

    /// The reference for the Forum database.
    var forumRef = Database.database().reference().child("Forum")

    /// An initializer which is used for the unit test.
    init(FIRDatabase: Database) {
        self.favoriteTopicRef = FIRDatabase.reference().child("FavoriteTopic")
        self.forumRef = FIRDatabase.reference().child("Forum")
    }

    /**
     Function which saves a topic on a serie in the FavoriteTopic database.
     - Calling this function saves the user id, the serie id and the topic id in the FavoriteTopic dabatabase.
     
     - Parameters:
        - userId: The id of the user saving the topic as favorite.
        - topic: The topic to save as favorite in the db.
     */
    func saveTopicAsFavorite(userId: String, topic: Topic) {
        guard let topicID = topic.topicId else { return }

        favoriteTopicRef.child(userId)
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

    /**
     Function which returns a callback with a boolean that tells if the topic is a favorite.

     Calling this function observes if the topic exists in the FavoriteTopic database for a given user
     and returns a boolean in a callback to tells if the topic exists.
     
     - Parameters:
        - userId: The id of the user we want to check if the topic is one of his favorites.
        - topic: The topic we want check if it's a favorite.
        - callback: The callback returning a boolean that tells if the topic is a favorite.
     */
    func isAFavoriteTopic(userId: String, topic: Topic, callback: @escaping (Bool) -> Void) {
        guard let topicID = topic.topicId else {
            callback(false)
            return
        }

        favoriteTopicRef.child(userId)
            .child("\(topic.serieId)")
            .child("\(topicID)")
            .observeSingleEvent(of: .value) { (datasnapshot) in
                if datasnapshot.exists() {
                    callback(true)
                } else {
                    callback(false)
                }
        }
    }

    /**
     Function which removes a topic in the FavoriteTopic database.

     Calling this function removes a given topic on a serie from a user thanks to their id
     in the FavoriteTopic dabatabase.
     
     - Parameters:
        - userId: The id of the user we want to remove the topic from his favorites.
        - topic: The topic to remove from favorite in the db.
     */
    func removeFavoriteTopic(userId: String, topic: Topic) {
        guard let topicID = topic.topicId else { return }

        favoriteTopicRef.child(userId)
            .child("\(topic.serieId)").child("\(topicID)").removeValue { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Topic removed from favorite")
                }
        }
    }

    func getFavoriteTopicsInfos(userId: String,
                                callback: @escaping ([FavoriteTopicInfos]?) -> Void) {
        favoriteTopicRef.child(userId).observe(.value) { (snapshot) in
            guard snapshot.exists() else {
                callback(nil)
                return
            }

            var favoriteTopics = [FavoriteTopicInfos]()
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                    let serieId = Int(snap.key),
                    let dictTopic = snap.value as? [String: Any],
                    dictTopic.count == 1 else {
                        callback(nil)
                        return
                }
                let favoriteTopic = FavoriteTopicInfos(serieId: serieId,
                                                       topicId: dictTopic.keys.joined())
                favoriteTopics.append(favoriteTopic)
                callback(favoriteTopics)
            }
        }
    }

    /**
     Function which returns a callback with the favorite topics of a given user.

     Calling this function observes the favorite topics of a user in the FavoriteTopic database
     and returns all his favorite topics in a callback.
     
     - Parameters:
        - userId: The id of the user we want the favorite topics.
        - callback: The callback returning all the favorite topics of the user.
     */
    func getFavoriteTopics(userId: String, callback: @escaping ([Topic]?) -> Void) {
        getFavoriteTopicsInfos(userId: userId) { (favoriteTopicsInfos) in
            guard let favoriteTopicsInfos = favoriteTopicsInfos else {
                callback(nil)
                return
            }

            var favoriteTopics = [Topic]()
            for favoriteTopicInfos in favoriteTopicsInfos {
                self.forumRef.child(String(favoriteTopicInfos.serieId))
                    .child(favoriteTopicInfos.topicId).observe(.value, with: { (snapshot) in
                        guard snapshot.exists() else {
                            callback(nil)
                            return
                        }
                        guard let dictTopic = snapshot.value as? [String: Any],
                            let topicUserId = dictTopic["userId"] as? String,
                            let serieName = dictTopic["serieName"] as? String,
                            let title = dictTopic["title"] as? String,
                            let dateString = dictTopic["date"] as? String,
                            let date = DateService().stringToDate(dateString) else {
                                callback(nil)
                                return
                        }
                        let topic = Topic(serieId: favoriteTopicInfos.serieId,
                                          topicId: favoriteTopicInfos.topicId,
                                          userId: topicUserId,
                                          date: date,
                                          serieName: serieName,
                                          title: title,
                                          post: [])
                        favoriteTopics.append(topic)
                        callback(favoriteTopics)
                })
            }
        }
    }
}
