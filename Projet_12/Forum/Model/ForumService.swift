//
//  ForumService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages the forum
class ForumService {

    // The reference for the Forum database
    static let forumRef = Database.database().reference().child("Forum")

    /**
     Function which saves a topic on a serie in the Forum database.
     Calling this function creates a topic id on the serie id,
     saves the user id, the title, the date and the first post in the Forum database.

     - Parameter topic: The topic to save in the db.
     */
    static func saveTopic(topic: Topic) {
        let topicRef = forumRef.child(String(topic.serieId)).childByAutoId()
        let topicDictionary: NSDictionary = ["userId": topic.userId,
                                             "title": topic.title,
                                             "date": "\(topic.date)"]
        let postDictionary: NSDictionary = ["userId": topic.post[0].userId,
                                            "text": topic.post[0].text,
                                            "date": "\(topic.post[0].date)"]
        topicRef.setValue(topicDictionary) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    topicRef.child("Post").childByAutoId()
                        .setValue(postDictionary, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Topic saved successfully")
                        }
                    })
                }
        }
    }

    /**
     Function which saves a post on a topic in the Forum database.
     Calling this function creates a post id on the topic id, and
     saves the user id, the text and the date for the new post id in the Forum database.

     - Parameters:
        - topic: The topic that the post is about.
        - post: The post to save in the db.
     */
    static func savePost(topic: Topic, post: Post) {
        guard let topicId = topic.topicId else {
            print("Topic doesn't exit")
            return
        }
        let topicRef = forumRef.child(String(topic.serieId)).child(topicId)
        let postRef = topicRef.child("Post").childByAutoId()
        let postDictionary: NSDictionary = ["userId": post.userId,
                                            "text": post.text,
                                            "date": "\(post.date)"]
        postRef.setValue(postDictionary) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Post saved successfully")
            }
        }
    }

    /**
     Function which returns a callback with the topics of a given serie.
     Calling this function observes the topics of a serie in the Forum database
     and returns all his topics in a callback.

     - Parameters:
        - serie: The serie we want the topics.
        - callback: The callback returning all the topics of the serie.
     */
    static func getTopics(serie: Result, callback: @escaping ([Topic]?) -> Void) {
        forumRef.child(String(serie.id)).observe(.value) { (snapshot) in
            var topics = [Topic]()
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                    let dictTopic = snap.value as? [String: Any],
                    let userId = dictTopic["userId"] as? String,
                    let title = dictTopic["title"] as? String,
                    let dateString = dictTopic["date"] as? String,
                    let date = DateService().stringToDate(dateString) else {
                        callback(nil)
                        return
                }
                let topic = Topic(serieId: serie.id,
                                  topicId: snap.key,
                                  userId: userId ,
                                  date: date ,
                                  title: title ,
                                  post: [])
                topics.append(topic)
                callback(topics)
            }
        }
    }

    /**
     Function which returns a callback with the posts of a given topic on a given serie.
     Calling this function observes the posts of a given topic in the Forum database
     and returns all his posts in a callback.

     - Parameters:
        - serie: The serie that the topic is about.
        - topic: The topic we want the posts.
        - callback: The callback returning all the topics of the serie.
     */
    static func getPosts(topic: Topic, callback: @escaping ([Post]?) -> Void) {
        guard let topicId = topic.topicId else {
            callback(nil)
            return
        }
        forumRef.child(String(topic.serieId)).child(topicId)
            .child("Post").observe(.value) { (snapshot) in
            var posts = [Post]()
                for child in snapshot.children {
                    guard let snap = child as? DataSnapshot,
                        let dictPost = snap.value as? [String: Any],
                        let userId = dictPost["userId"] as? String,
                        let text = dictPost["text"] as? String,
                        let dateString = dictPost["date"] as? String,
                        let date = DateService().stringToDate(dateString) else {
                        callback(nil)
                            return
                    }
                    let post = Post(userId: userId, date: date, text: text)
                    posts.append(post)
                    callback(posts)
                }
        }
    }
}
