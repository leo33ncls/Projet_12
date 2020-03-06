//
//  Topic.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class Topic {
    let serieId: Int
    var topicId: String?
    let userId: String
    let date: Date
    let title: String
    var post: [Post]
    
    init(serieId: Int, topicId: String?, userId: String, date: Date, title: String, post: [Post]) {
        self.serieId = serieId
        self.topicId = topicId
        self.userId = userId
        self.date = date
        self.title = title
        self.post = post
    }
}
