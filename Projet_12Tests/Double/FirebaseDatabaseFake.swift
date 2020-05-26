//
//  FirebaseDatabaseFake.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 19/05/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import Foundation
import FirebaseDatabase

// A Class that doubles the Firebase Database class
class DatabaseFake: Database {
    var dataSnapshot: DataSnapshotFake

    init(dataSnapshot: DataSnapshotFake) {
        self.dataSnapshot = dataSnapshot
    }

    override func reference() -> DatabaseReference {
        return DatabaseReferenceFake(dataSnapshot: dataSnapshot)
    }
}

// A Class that doubles the Firebase DatabaseReference class
class DatabaseReferenceFake: DatabaseReference {
    var dataSnapshot: DataSnapshotFake

    init(dataSnapshot: DataSnapshotFake) {
        self.dataSnapshot = dataSnapshot
    }

    override func child(_ pathString: String) -> DatabaseReference {
        return self
    }

    override func observe(_ eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) -> UInt {
        block(dataSnapshot)
        return 1
    }

    override func observeSingleEvent(of eventType: DataEventType, with block: @escaping (DataSnapshot) -> Void) {
        block(dataSnapshot)
    }
}

// A Class that doubles the Firebase DataSnapshot class
class DataSnapshotFake: DataSnapshot {
    var data: NSDictionary
    var stringKey: String
    var exist: Bool

    init(data: NSDictionary, stringKey: String, exist: Bool) {
        self.data = data
        self.stringKey = stringKey
        self.exist = exist
    }
    override var value: Any? {
        return data
    }
    override var key: String {
        return stringKey
    }
    override func exists() -> Bool {
        return exist
    }
}
