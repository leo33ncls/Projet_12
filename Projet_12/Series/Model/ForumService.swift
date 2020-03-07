//
//  ForumService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ForumService {
    static let forumRef = Database.database().reference().child("Forum")
    
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
                            print("Post saved successfully")
                            }
                    })
                }
        }
    }
    
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
    
    static func getPosts(serie: Result, topic: Topic, callback: @escaping ([Post]?) -> Void) {
        guard let topicId = topic.topicId else {
            callback(nil)
            return
        }
        forumRef.child(String(serie.id)).child(topicId)
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
