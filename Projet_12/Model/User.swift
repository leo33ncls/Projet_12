//
//  User.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class User {
    var nickname: String
    var email: String
    var lastName: String
    var firstName: String
    var phone: String
    
    init(nickname: String, email: String, lastName: String, firstName: String, phone: String) {
        self.nickname = nickname
        self.email = email
        self.lastName = lastName
        self.firstName = firstName
        self.phone = phone
    }
}
