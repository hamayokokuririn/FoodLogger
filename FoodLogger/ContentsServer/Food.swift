//
//  Food.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation

protocol Food {
    var name: String { get }
}

struct ShouldCheckFood: Food {
    let name: String
    var checked: Bool = false
    var otherNames: [String] = []
}

struct InputedFood: Food {
    let name: String
    var shouldCheck: Bool = false
    var registeredDate: Date?
}
