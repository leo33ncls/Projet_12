//
//  UsersService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 18/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase

// Class that manages users
class UsersService {

    // The reference for the Users database
    static let usersDTBRef = Database.database().reference().child("Users")
    
    /**
     Function which saves a user in the Users database.
     Calling this function saves the user's nickname, email and fullName in the Users dabatabase.
     
     - Parameter user: The user to save in the db.
    */
    static func saveUser(user: User) {
        let userDictionary: NSDictionary = ["nickname": user.nickname,
                                            "email": user.email,
                                            "fullName": user.fullName]
        usersDTBRef.child(user.id).setValue(userDictionary) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User saved successfully")
            }
        }
    }
    
    /**
     Function which returns a callback with the nickname of a given user.
     Calling this function observes the value of a user in the database
     kepts and returns his nickname value with a callback.
     
     - Parameters:
            - userId: The user Id of the user that we want the nickname.
            - callback: The callback returning the nickname.
     */
    static func getUserNickname(userId: String, callback: @escaping (String)-> Void) {
        usersDTBRef.child(userId).observe(.value) { (snapshot) in
            guard let dictUser = snapshot.value as? [String: Any],
                let nickname = dictUser["nickname"] as? String else {
                    callback("Unknown")
                    return
            }
            callback(nickname)
        }
    }
}
