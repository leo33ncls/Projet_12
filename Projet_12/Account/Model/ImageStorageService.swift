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

    /**
     Function which saves an account image for a given user in the UserImage Storage.
     Calling this function saves an image data with a user id in the UserImage Storage,
     and updates the imageUrl value for the user in the User Database.
     
     - Parameters:
     - userId: The id of the user for which we want to save the image.
     - data: The data of the image we want to save.
     */
    static func saveUserImage(userId: String, data: Data) {
        let userRef = userImageStorageRef.child(userId)
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

    /**
     Function which saves a background image for a given user in the UserBackground Storage.
     Calling this function saves an image data with a user id in the UserBackground Storage,
     and updates the backgroundUrl value for the user in the User Database.
     
     - Parameters:
     - userId: The id of the user for which we want to save the image.
     - data: The data of the image we want to save.
     */
    static func saveUserBackground(userId: String, data: Data) {
        let userRef = userBackgroundStorageRef.child(userId)
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

    /**
     Function which returns a callback with the user background image.
     Calling this function gets the image data of a given user in the UserBackground Storage,
     and returns it in a callback.
     
     - Parameters:
     - userId: The id of the user we want the background image data.
     - callback: The callback returning the user background image data.
     */
    static func getUserBackground(userId: String, callback: @escaping (Data?) -> Void) {
        userBackgroundStorageRef.child(userId).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard let data = data else {
                callback(nil)
                return
            }
            callback(data)
        }
    }

    /**
     Function which returns a callback with the user image.
     Calling this function gets the image data of a given user in the UserImage Storage,
     and returns it in a callback.
     
     - Parameters:
     - userId: The id of the user we want the image data.
     - callback: The callback returning the user image data.
     */
    static func getUserImage(userId: String, callback: @escaping (Data?) -> Void) {
        userImageStorageRef.child(userId).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            guard let data = data else {
                callback(nil)
                return
            }
            callback(data)
        }
    }

}
