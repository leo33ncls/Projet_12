//
//  SeriesServiceTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import XCTest

class SeriesServiceTestCase: XCTestCase {
    let genre = "Drama"
    
    //=====================
    // Test function getSeriesList
    
    func testGetSeriesListShouldPostFailedCallbackIfError() {
        // Given
        let seriesService = SeriesService(session: URLSessionFake(data: nil,
                                                                  response: nil,
                                                                  error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        seriesService.getSeriesList(genre: genre) { (success, seriesList) in
            //Then
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
        seriesService.getSeriesList(genre: genre) { (success, seriesList) in
            //Then
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
        seriesService.getSeriesList(genre: genre) { (success, seriesList) in
            //Then
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
        seriesService.getSeriesList(genre: genre) { (success, seriesList) in
            //Then
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
        seriesService.getSeriesList(genre: genre) { (success, seriesList) in
            //Then
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
}
