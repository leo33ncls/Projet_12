//
//  SeriesList.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 11/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// MARK: - SeriesList
// The series list object that the API themoviedb sends back
struct SeriesList: Decodable {
    let page, totalResults, totalPages: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Result: Decodable {
    let originalName: String
    let genreIDS: [Int]?
    let genres: [Genre]?
    let name: String
    let popularity: Double
    let originCountry: [String]
    let voteCount: Int
    let firstAirDate: String
    let backdropPath: String?
    let originalLanguage: String
    let id: Int
    let voteAverage: Double
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case genreIDS = "genre_ids"
        case genres, name, popularity
        case originCountry = "origin_country"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case id
        case voteAverage = "vote_average"
        case overview
        case posterPath = "poster_path"
    }
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}
