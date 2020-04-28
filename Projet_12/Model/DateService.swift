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
     Function which transforms a given string to a date.
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
    
    /**
     Function that transforms a date into a string.
     - Parameter date: The date to transform into a string.
     - Returns: The date transformed into string.
    */
    func transformDateToString(date: Date) -> String {
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        
        if day < 10 && month < 10 {
            return "0\(day)/0\(month)"
        } else if day < 10 {
            return "0\(day)/\(month)"
        } else if month < 10 {
            return "\(day)/0\(month)"
        } else {
            return "\(day)/\(month)"
        }
    }

    /**
     Function that transforms a hour into a string.
     - Parameter date: The date containing the hour to transform into a string.
     - Returns: The hour transformed into string.
     */
    func transformHourToString(date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        let minute = Calendar.current.component(.minute, from: date)
        
        if hour < 10 && minute < 10 {
            return "0\(hour):0\(minute)"
        } else if hour < 10 {
            return "0\(hour):\(minute)"
        } else if minute < 10 {
            return "\(hour):0\(minute)"
        } else {
            return "\(hour):\(minute)"
        }
    }
}
