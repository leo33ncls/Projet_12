//
//  User.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class User {
    var id: String
    var nickname: String
    var email: String
    var fullName: String
    
    init(id: String, nickname: String, email: String, fullName: String) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.fullName = fullName
    }
}
