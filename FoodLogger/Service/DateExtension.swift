//
//  DateExtension.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/16.
//

import Foundation

extension DateFormatter {
    var custom: DateFormatter {
        calendar = Calendar(identifier: .gregorian)
        locale = Locale(identifier: "ja_JP")
        timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateStyle = .long
        return self
    }
}
