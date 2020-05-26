//
//  SeriesServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//
// swiftlint:disable type_body_length

@testable import Projet_12
import XCTest

class SeriesServiceTestCase: XCTestCase {
    let genre = 18
    let searchText = "Game"
    let serieId = 456
    let language = "en"
    let serieImageUrl = "https://serieImage"

    //=====================
    // Test function getSeriesList

    func testGetSeriesListShouldPostFailedCallbackIfError() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSeriesListShouldPostFailedCallbackIfNoData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSeriesListShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SeriesListCorrectData,
                                                                      response: FakeResponseData.responseKO,
                                                                      error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSeriesListShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.incorrectData,
                                                                      response: FakeResponseData.responseOK,
                                                                      error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSeriesListShouldPostSuccesCallbackIfNoErrorAndCorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SeriesListCorrectData,
                                                                      response: FakeResponseData.responseOK,
                                                                      error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre, language: language) { (success, seriesList) in
            // Then
            let id = 80743
            let popularity = 344.528
            let name = "The Flash"
            let posterPath = "/6t6r1VGQTTQecN4V0sZeqsmdU9g.jpg"
            let voteAverage = 5.9

            XCTAssertTrue(success)
            XCTAssertNotNil(seriesList)

            XCTAssertEqual(id, seriesList?.results[0].id)
            XCTAssertEqual(popularity, seriesList?.results[1].popularity)
            XCTAssertEqual(name, seriesList?.results[2].name)
            XCTAssertEqual(posterPath, seriesList?.results[3].posterPath)
            XCTAssertEqual(voteAverage, seriesList?.results[4].voteAverage)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    //=====================
    // Test function searchSeries

    func testSearchSeriesShouldPostFailedCallbackIfError() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.searchSeries(searchText: searchText, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchSeriesShouldPostFailedCallbackIfNoData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.searchSeries(searchText: searchText, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchSeriesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SeriesListCorrectData,
                                                                  response: FakeResponseData.responseKO,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.searchSeries(searchText: searchText, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchSeriesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.incorrectData,
                                                                  response: FakeResponseData.responseOK,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.searchSeries(searchText: searchText, language: language) { (success, seriesList) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(seriesList)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchSeriesShouldPostSuccesCallbackIfNoErrorAndCorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SeriesListCorrectData,
                                                                  response: FakeResponseData.responseOK,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.searchSeries(searchText: searchText, language: language) { (success, seriesList) in
            // Then
            let id = 80743
            let popularity = 344.528
            let name = "The Flash"
            let posterPath = "/6t6r1VGQTTQecN4V0sZeqsmdU9g.jpg"
            let voteAverage = 5.9

            XCTAssertTrue(success)
            XCTAssertNotNil(seriesList)

            XCTAssertEqual(id, seriesList?.results[0].id)
            XCTAssertEqual(popularity, seriesList?.results[1].popularity)
            XCTAssertEqual(name, seriesList?.results[2].name)
            XCTAssertEqual(posterPath, seriesList?.results[3].posterPath)
            XCTAssertEqual(voteAverage, seriesList?.results[4].voteAverage)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    //=====================
    // Test function getSerie

    func testGetSerieShouldPostFailedCallbackIfError() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerie(serieId: serieId, language: language) { (success, serie) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(serie)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieShouldPostFailedCallbackIfNoData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerie(serieId: serieId, language: language) { (success, serie) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(serie)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SeriesListCorrectData,
                                                                  response: FakeResponseData.responseKO,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerie(serieId: serieId, language: language) { (success, serie) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(serie)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.incorrectData,
                                                                  response: FakeResponseData.responseOK,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerie(serieId: serieId, language: language) { (success, serie) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(serie)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieShouldPostSuccesCallbackIfNoErrorAndCorrectData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.SerieCorrectData,
                                                                  response: FakeResponseData.responseOK,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerie(serieId: serieId, language: language) { (success, serie) in
            // Then
            let popularity = 115.628
            let name = "The Simpsons"
            let posterPath = "/qcr9bBY6MVeLzriKCmJOv1562uY.jpg"
            let firstAirDate = "1989-12-17"

            XCTAssertTrue(success)
            XCTAssertNotNil(serie)

            XCTAssertEqual(popularity, serie?.popularity)
            XCTAssertEqual(name, serie?.name)
            XCTAssertEqual(posterPath, serie?.posterPath)
            XCTAssertEqual(firstAirDate, serie?.firstAirDate)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    //===================
    // Test function getSerieImage

    func testGetSerieImageShouldPostFailedCompletionHandlerIfError() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerieImage(imageUrl: serieImageUrl) { (data) in
            // Then
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieImageShouldPostFailedCompletionHandlerIfNoData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerieImage(imageUrl: serieImageUrl) { (data) in
            // Then
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieImageShouldPostFailedCompletionHandlerIfIncorrectResponse() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.imageData,
                                                                  response: FakeResponseData.responseKO,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerieImage(imageUrl: serieImageUrl) { (data) in
            // Then
            XCTAssertNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetSerieImageShouldReturnDataIfNoErrorAndImageData() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: FakeResponseData.imageData,
                                                                  response: FakeResponseData.responseOK,
                                                                  error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSerieImage(imageUrl: serieImageUrl) { (data) in
            // Then
            XCTAssertNotNil(data)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
}
