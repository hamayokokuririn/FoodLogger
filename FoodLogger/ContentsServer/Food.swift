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
    
    func hasSameName(with input: String) -> Bool {
        let all = otherNames + [name]
        return all.contains { $0 == input }
    }
}

struct InputedFood: Food {
    let name: String
    var shouldCheck: Bool = false
    var registeredDate: Date?
}
