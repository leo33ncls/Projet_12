//
//  Post.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// A user's post on a topic
class Post {

    // The id of the user who creates the post
    let userId: String
    
    // The publication date of the post
    let date: Date

    // The text of the post
    let text: String
    
    /**
     Initializes a new post on a topic with an user id, a date and a text.
     
     - Parameters:
        - userId: The id of the user who creates the post.
        - date: The publication date of the post.
        - text: The text of the post.
     */
    init(userId: String, date: Date, text: String) {
        self.userId = userId
        self.date = date
        self.text = text
    }
}
