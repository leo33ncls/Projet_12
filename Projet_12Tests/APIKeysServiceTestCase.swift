//
//  APIKeysServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 05/04/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import XCTest
@testable import Projet_12

class APIKeysServiceTestCase: XCTestCase {

    func testGivenCorrectKeyAndFileName_WhenValueForAPIKeyIsCalled_ThenApiKeyShouldBeEqualToTest123() {
        let keyName = "testKey"
        let fileName = "APIKeysTest"

        let apiKey = APIKeysService.valueForAPIKey(named: keyName, fileName: fileName,
                                                   bundleClass: APIKeysServiceTestCase.self)

        XCTAssertEqual(apiKey, "test123")
    }

    func testGivenIncorrectKeyName_WhenValueForAPIKeyIsCalled_ThenApiKeyShouldBeNil() {
        let incorrectKeyName = "incorrectKey"
        let fileName = "APIKeysTest"

        let apiKey = APIKeysService.valueForAPIKey(named: incorrectKeyName, fileName: fileName,
                                                   bundleClass: APIKeysServiceTestCase.self)

        XCTAssertNil(apiKey)
    }

    func testGivenIncorrectFileName_WhenValueForAPIKeyIsCalled_ThenApiKeyShouldBeNil() {
        let keyName = "testKey"
        let incorrectFileName = "incorrectKeysTest"

        let apiKey = APIKeysService.valueForAPIKey(named: keyName, fileName: incorrectFileName,
                                                   bundleClass: APIKeysServiceTestCase.self)

        XCTAssertNil(apiKey)
    }
}
