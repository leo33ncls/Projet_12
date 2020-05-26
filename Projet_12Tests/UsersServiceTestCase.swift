//
//  UsersServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 19/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import XCTest

class UsersServiceTestCase: XCTestCase {
    let userId = "Nehf34jf3jD9Mn"
    let evaluation = Evaluation(userID: "Nehf34jf3jD9Mn", serieID: 456, evaluation: 13)

    // =========================
    // Test Function GetUserInformation

    func testGetUserInformationShouldPostFailedCallbackIfIncorrectSnap() {
        // Given
        let usersService = UsersService(FIRDatabase: DatabaseFake(dataSnapshot: DataSnapshotFake(
            data: FakeSnapshot.incorrectSnap, stringKey: userId, exist: true)))

        // When
        usersService.getUserInformation(userId: userId) { (user) in
            // Then
            XCTAssertNil(user)
        }
    }

    func testGetUserInformationShouldGiveAUserWithoutDescriptionIfCorrectUserSnapWithoutDescription() {
        // Given
        let usersService = UsersService(FIRDatabase: DatabaseFake(dataSnapshot: DataSnapshotFake(
            data: FakeSnapshot.userWithoutDescriptionSnap, stringKey: userId, exist: true)))

        // When
        usersService.getUserInformation(userId: userId) { (user) in
            // Then
            let email = "leo.33320@hotmail.fr"
            let fullName = "LU00e9o NICOLAS"
            let nickname = "LeoOC"

            XCTAssertNotNil(user)

            XCTAssertEqual(nil, user?.description)
            XCTAssertEqual(email, user?.email)
            XCTAssertEqual(fullName, user?.fullName)
            XCTAssertEqual(nickname, user?.nickname)
        }
    }

    func testGetUserInformationShouldGiveAUserIfCorrectUserSnap() {
        // Given
        let usersService = UsersService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.userSnap, stringKey: userId, exist: true)))

        // When
        usersService.getUserInformation(userId: userId) { (user) in
            // Then
            let description = "Ceci est une description"
            let email = "leo.33320@hotmail.fr"
            let fullName = "LU00e9o NICOLAS"
            let nickname = "LeoOC"

            XCTAssertNotNil(user)

            XCTAssertEqual(description, user?.description)
            XCTAssertEqual(email, user?.email)
            XCTAssertEqual(fullName, user?.fullName)
            XCTAssertEqual(nickname, user?.nickname)
        }
    }

    // =========================
    // Test Function GetUserNickname

    func testGetUserNicknameShouldPostFailedCallbackIfIncorrectSnap() {
        // Given
        let usersService = UsersService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.incorrectSnap, stringKey: userId, exist: true)))

        // When
        usersService.getUserNickname(userId: userId) { (nickname) in
            // Then
            XCTAssertNil(nickname)
        }
    }

    func testGetUserNicknameShouldGiveANicknameIfCorrectUserSnap() {
        // Given
        let usersService = UsersService(FIRDatabase: DatabaseFake(
            dataSnapshot: DataSnapshotFake(data: FakeSnapshot.userSnap, stringKey: userId, exist: true)))

        // When
        usersService.getUserNickname(userId: userId) { (nickname) in
            // Then
            let userNickname = "LeoOC"

            XCTAssertNotNil(nickname)
            XCTAssertEqual(nickname, userNickname)
        }
    }
}
