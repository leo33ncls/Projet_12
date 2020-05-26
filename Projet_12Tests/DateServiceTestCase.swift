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

    func createDate(month: Int, day: Int, hour: Int, minute: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.timeZone = Calendar.current.timeZone
        dateComponents.year = 2020
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 16

        let date = Calendar.current.date(from: dateComponents)
        return date
    }

    // ==========================
    // Test function stringToDate

    func testGivenAValidDateString_WhenCallingStringToDate_ThenTestDateShouldBeEqualToDate() {
        // Given
        let validStringDate = "2020-03-10 13:02:16 +0000"

        // When
        let testDate = DateService().stringToDate(validStringDate)

        // Then
        XCTAssertNotNil(testDate)
    }

    func testGivenAUnvalidDateString_WhenCallingStringToDate_ThenShouldReturnNil() {
        // Given
        let unvalidStringDate = "2020-03-10"

        // When
        let testDate = DateService().stringToDate(unvalidStringDate)

        // Then
        XCTAssertNil(testDate)
    }

    // ==========================
    // Test function transformDateToString

    func testGivenDateMonth03AndDay04_WhenCallingTransformDateToString_ThenStringDateShouldBeEqualToStrDate() {
        // Given
        guard let date = createDate(month: 3, day: 4, hour: 10, minute: 10) else { return }
        let strDate = "04/03"

        // When
        let stringDate = DateService().transformDateToString(date: date)

        // Then
        XCTAssertEqual(stringDate, strDate)
    }

    func testGivenDateMonth10AndDay05_WhenCallingTransformDateToString_ThenStringDateShouldBeEqualToStrDate() {
        // Given
        guard let date = createDate(month: 10, day: 5, hour: 10, minute: 10) else { return }
        let strDate = "05/10"

        // When
        let stringDate = DateService().transformDateToString(date: date)

        // Then
        XCTAssertEqual(stringDate, strDate)
    }

    func testGivenDateMonth02AndDay18_WhenCallingTransformDateToString_ThenStringDateShouldBeEqualToStrDate() {
        // Given
        guard let date = createDate(month: 2, day: 18, hour: 10, minute: 10) else { return }
        let strDate = "18/02"

        // When
        let stringDate = DateService().transformDateToString(date: date)

        // Then
        XCTAssertEqual(stringDate, strDate)
    }

    func testGivenDateMonth12AndDay30_WhenCallingTransformDateToString_ThenStringDateShouldBeEqualToStrDate() {
        // Given
        guard let date = createDate(month: 12, day: 30, hour: 10, minute: 10) else { return }
        let strDate = "30/12"

        // When
        let stringDate = DateService().transformDateToString(date: date)

        // Then
        XCTAssertEqual(stringDate, strDate)
    }

    // ==========================
    // Test function transformHourToString

    func testGivenHour01AndMinute09_WhenCallingTransformHourToString_ThenStringHourShouldBeEqualToStrHour() {
        // Given
        guard let date = createDate(month: 10, day: 10, hour: 1, minute: 9) else { return }
        let strHour = "01:09"

        // When
        let stringHour = DateService().transformHourToString(date: date)

        // Then
        XCTAssertEqual(stringHour, strHour)
    }

    func testGivenHour06AndMinute42_WhenCallingTransformHourToString_ThenStringHourShouldBeEqualToStrHour() {
        // Given
        guard let date = createDate(month: 10, day: 10, hour: 6, minute: 42) else { return }
        let strHour = "06:42"

        // When
        let stringHour = DateService().transformHourToString(date: date)

        // Then
        XCTAssertEqual(stringHour, strHour)
    }

    func testGivenHour11AndMinute07_WhenCallingTransformHourToString_ThenStringHourShouldBeEqualToStrHour() {
        // Given
        guard let date = createDate(month: 10, day: 10, hour: 11, minute: 7) else { return }
        let strHour = "11:07"

        // When
        let stringHour = DateService().transformHourToString(date: date)

        // Then
        XCTAssertEqual(stringHour, strHour)
    }

    func testGivenHour10AndMinute54_WhenCallingTransformHourToString_ThenStringHourShouldBeEqualToStrHour() {
        // Given
        guard let date = createDate(month: 10, day: 10, hour: 10, minute: 54) else { return }
        let strHour = "10:54"

        // When
        let stringHour = DateService().transformHourToString(date: date)

        // Then
        XCTAssertEqual(stringHour, strHour)
        XCTAssertEqual(10, Calendar.current.component(.hour, from: date))
    }
}
