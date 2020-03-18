//
//  Genres.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 19/02/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// Class that manages the genres of serie
class Genres {
    
    // An array of all the serie genres
    static let genres: [(id: Int, genre: String)] = [(10759, "Action & Adventure"),
                                                     (16, "Animation"),
                                                     (35, "Comedy"),
                                                     (80, "Crime"),
                                                     (99, "Documentary"),
                                                     (18, "Drama"),
                                                     (10751, "Family"),
                                                     (10762, "Kids"),
                                                     (9648, "Mystery"),
                                                     (10763, "News"),
                                                     (10764, "Reality"),
                                                     (10765, "Sci-Fi & Fantasy"),
                                                     (10766, "Soap"),
                                                     (10767, "Talk"),
                                                     (10768, "War & Politics"),
                                                     (37, "Western")]
    
    /**
     Function which returns a string of the genres from an array of genre id
     - Parameter genreId: The genres id we want the string.
     - Returns: A string with the genres.
     */
    static func getStringGenre(genreId: [Int]) -> String {
        var genres = [String]()
        for index in 0..<genreId.count {
            for i in 0..<Genres.genres.count {
                if genreId[index] == Genres.genres[i].id {
                    genres.append(Genres.genres[i].genre)
                }
            }
        }
        
        return genres.joined(separator: ", ")
    }
}
