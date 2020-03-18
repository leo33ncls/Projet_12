//
//  DateService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

// Class that manages the date
class DateService {

    /**
     Function which transforms a given string to a date
     - Parameter string: The string we want to change in a date.
     - Returns: A date
     */
    func stringToDate(_ string: String) -> Date? {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        guard let date = dateFomatter.date(from: string) else {
            return nil
        }
        return date
    }
}
