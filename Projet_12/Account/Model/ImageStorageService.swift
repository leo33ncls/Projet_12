//
//  ImageStorageService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 14/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class ImageStorageService {

    // The reference for the User image storage
    static let userImageStorageRef = Storage.storage().reference().child("UserImage")

    // The reference for the User background image storage
    static let userBackgroundStorageRef = Storage.storage().reference().child("UserBackground")

    static func saveUserImage(userId: String, data: Data) {
        let userRef = userImageStorageRef.child(String(userId))
        userRef.putData(data, metadata: nil) { (metadata, error) in
            userRef.downloadURL(completion: { (url, error) in
                if let urlString = url?.absoluteString {
                    let imageDict = ["imageUrl": urlString]
                    UsersService.usersDTBRef.child(userId).updateChildValues(imageDict)
                } else {
                    print("Error saving user image")
                }
            })
        }
    }

    static func saveUserBackground(userId: String, data: Data) {
        let userRef = userBackgroundStorageRef.child(String(userId))
        userRef.putData(data, metadata: nil) { (metadata, error) in
            userRef.downloadURL(completion: { (url, error) in
                if let urlString = url?.absoluteString {
                    let backgroundDict = ["backgroundUrl": urlString]
                    UsersService.usersDTBRef.child(userId).updateChildValues(backgroundDict)
                } else {
                    print("Error saving user image")
                }
            })
        }
    }
}
