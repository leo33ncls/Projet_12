//
//  UsersService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UsersService {
    static let usersDTBRef = Database.database().reference().child("Users")
    
    static func saveUser(user: User) {
        let userDictionary: NSDictionary = ["Nickname": user.nickname,
                                            "email": user.email,
                                            "LastName": user.lastName,
                                            "FirstName": user.firstName,
                                            "Phone": user.phone]
        usersDTBRef.child(user.id).setValue(userDictionary) { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "Error saving user")
            } else {
                print("User saved successfully")
            }
        }
    }
}
