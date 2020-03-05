//
//  Post.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 03/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class Post {
    let userId: String
    let date: Date
    let text: String
    
    init(userId: String, date: Date, text: String) {
        self.userId = userId
        self.date = date
        self.text = text
    }
}
