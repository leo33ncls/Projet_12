//
//  DateService.swift
//  Projet_12
//
//  Created by Léo NICOLAS on 05/03/2020.
//  Copyright © 2020 Léo NICOLAS. All rights reserved.
//

import Foundation

class DateService {
    
    func stringToDate(_ string: String) -> Date? {
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZZ"
        if let date = dateFomatter.date(from: string) {
            return date
        } else {
            return nil
        }
    }
}
