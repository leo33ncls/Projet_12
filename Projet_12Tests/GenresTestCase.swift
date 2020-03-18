//
//  GenresTestCase.swift
//  Projet_12Tests
//
//  Created by Léo NICOLAS on 18/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

@testable import Projet_12
import XCTest

class GenresTestCase: XCTestCase {

    func testGivenTwoValidGenreId_WhenCallingGetStringGenre_ThenShouldStringGenresShouldBeEqualToGenres() {
        // Given
        let genresId = [16, 80]
        let genres = "Animation, Crime"
        
        // When
        let stringGenres = Genres.getStringGenre(genreId: genresId)
        
        // Then
        XCTAssertEqual(genres, stringGenres)
    }
    
    func testGivenNoGenreId_WhenCallingGetStringGenre_ThenShouldReturnEmptyString() {
        // Given
        let genresId = [Int]()
        
        // When
        let stringGenres = Genres.getStringGenre(genreId: genresId)
        
        // Then
        XCTAssertEqual("", stringGenres)
    }
    
    func testGivenUnvalidGenreId_WhenCallingGetStringGenre_ThenShouldReturnEmptyString() {
        // Given
        let genresId = [90, 502, 72]
        
        // When
        let stringGenres = Genres.getStringGenre(genreId: genresId)
        
        // Then
        XCTAssertEqual("", stringGenres)
    }
    
    func testGivenAUnvalidGenreIdAndAValidGenreId_WhenCallingGetStringGenre_ThenShouldStringGenresShouldBeEqualToGenres() {
        // Given
        let genresId = [90, 16]
        let genres = "Animation"
        
        // When
        let stringGenres = Genres.getStringGenre(genreId: genresId)
        
        // Then
        XCTAssertEqual(genres, stringGenres)
    }
}
