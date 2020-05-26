//
//  FavoriteTopicsServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 26/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import XCTest

class FavoriteTopicsServiceTestCase: XCTestCase {
    let userId = "Nehf34jf3jD9Mn"
    let stringKey = "hfjeb34GJef"
    let topic = Topic(serieId: 456, topicId: "hfjeb34GJef", userId: "Nehf34jf3jD9Mn",
                      date: Date(), serieName: "The Simpsons", title: "Test",
                      post: [Post(userId: "Nehf34jf3jD9Mn", date: Date(), text: "Bonjour")])
    let favoriteTopic = FavoriteTopicInfos(serieId: 456, topicId: "hfjeb34GJef")

    // ==============================
    // Test Function isAFavoriteTopic

    func testIsAFavoriteTopicShouldPostFailedCallbackIfNoTopicId() {
        // Given
        let favoriteTopicService = FavoriteTopicService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.incorrectSnap, stringKey: stringKey, exist: false)))
        topic.topicId = nil

        // When
        favoriteTopicService.isAFavoriteTopic(userId: userId, topic: topic) { (success) in
            // Then
            XCTAssertFalse(success)
        }
    }

    func testIsAFavoriteTopicShouldPostFailedCallbackIfSnapNoExists() {
        // Given
        let favoriteTopicService = FavoriteTopicService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.incorrectSnap, stringKey: stringKey, exist: false)))

        // When
        favoriteTopicService.isAFavoriteTopic(userId: userId, topic: topic) { (success) in
            // Then
            XCTAssertFalse(success)
        }
    }

    func testIsAFavoriteTopicShouldPostSuccessCallbackIfSnapExists() {
        // Given
        let favoriteTopicService = FavoriteTopicService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.userSnap, stringKey: stringKey, exist: true)))

        // When
        favoriteTopicService.isAFavoriteTopic(userId: userId, topic: topic) { (success) in
            // Then
            XCTAssertTrue(success)
        }
    }
}
