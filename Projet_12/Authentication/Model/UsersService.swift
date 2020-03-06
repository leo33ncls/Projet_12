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
