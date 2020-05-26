//
//  FakeSnapshot.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 19/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class FakeSnapshot {

    static var userSnap: NSDictionary {
        let data: NSDictionary = ["backgroundUrl": "https://firebasestorage.google",
                                  "description": "Ceci est une description",
                                  "email": "leo.33320@hotmail.fr",
                                  "fullName": "LU00e9o NICOLAS",
                                  "imageUrl": "nil",
                                  "nickname": "LeoOC"]
        return data
    }

    static var userWithoutDescriptionSnap: NSDictionary {
        let data: NSDictionary = ["backgroundUrl": "https://firebasestorage.google",
                                  "description": "nil",
                                  "email": "leo.33320@hotmail.fr",
                                  "fullName": "LU00e9o NICOLAS",
                                  "imageUrl": "nil",
                                  "nickname": "LeoOC"]
        return data
    }

    static var incorrectSnap: NSDictionary = ["error": "incorrect"]
}
