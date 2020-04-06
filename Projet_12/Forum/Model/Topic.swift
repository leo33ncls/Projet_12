//
//  Topic.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// A topic on a serie
class Topic {

    // The id of the serie that the topic is about
    let serieId: Int

    // The id of the topic
    var topicId: String?

    // The id of the user who creates the topic
    let userId: String

    // The date of the topic creation
    let date: Date

    // The name of the serie that the topic is about
    let serieName: String

    // The title of the topic
    let title: String

    // The posts of the topic
    var post: [Post]

    /**
     Initializes a new topic on a serie with some informations.

     - Parameters:
        - serieId: The id of the serie that the topic is about.
        - topicId: The id of the topic.
        - userId: The id of the user who creates the topic.
        - date: The date of the topic creation.
        - serieName: The name of the serie that the topic is about
        - title: The title of the topic.
        - post: The first post of the topic.
    */
    init(serieId: Int, topicId: String?, userId: String, date: Date,
         serieName: String, title: String, post: [Post]) {
        self.serieId = serieId
        self.topicId = topicId
        self.userId = userId
        self.date = date
        self.serieName = serieName
        self.title = title
        self.post = post
    }
}
