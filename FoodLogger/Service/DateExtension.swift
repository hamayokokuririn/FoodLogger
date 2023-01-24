//
//  DateExtension.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/16.
//

import Foundation

extension DateFormatter {
    var customDate: DateFormatter {
        calendar = Calendar(identifier: .gregorian)
        locale = Locale(identifier: "ja_JP")
        timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateStyle = .long
        return self
    }
    
    var customDateAndTime: DateFormatter {
        calendar = Calendar(identifier: .gregorian)
        locale = Locale(identifier: "ja_JP")
        timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateStyle = .long
        timeStyle = .short
        return self
    }
}
