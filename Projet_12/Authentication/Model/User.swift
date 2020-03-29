//
//  User.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// An user which is registered in the db
class User {

    // The user id
    let id: String

    // The user nickname
    var nickname: String

    // The user email
    let email: String

    // The user full name
    var fullName: String

    /**
     Initializes a new user with some informations.

     - Parameters:
        - id: The user id.
        - nickname: The user nickname.
        - email: The user email.
        - fullName: The user full name.
     */
    init(id: String, nickname: String, email: String, fullName: String) {
        self.id = id
        self.nickname = nickname
        self.email = email
        self.fullName = fullName
    }
}
