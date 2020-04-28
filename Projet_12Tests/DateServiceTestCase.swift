//
//  DateServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 18/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import XCTest

class DateServiceTestCase: XCTestCase {

    func createDate() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 03
        dateComponents.day = 10
        dateComponents.hour = 13
        dateComponents.minute = 02
        dateComponents.second = 16
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")

        let date = Calendar.current.date(from: dateComponents)
        return date
    }

    func testGivenAValidDateString_WhenCallingStringToDate_ThenShouldTestDateShouldBeEqualToDate() {
        // Given
        guard let date = createDate() else { return }
        let validStringDate = "2020-03-10 13:02:16 +0000"

        // When
        let testDate = DateService().stringToDate(validStringDate)

        // Then
        XCTAssertEqual(date, testDate)
    }

    func testGivenAUnvalidDateString_WhenCallingStringToDate_ThenShouldReturnNil() {
        // Given
        let unvalidStringDate = "2020-03-10"

        // When
        let testDate = DateService().stringToDate(unvalidStringDate)

        // Then
        XCTAssertNil(testDate)
    }
}
