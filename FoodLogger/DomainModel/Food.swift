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

protocol MatchingFood: Food {
    var otherNames: [String] { get }
}

extension MatchingFood {
    func hasSameName(with input: String) -> Bool {
        let all = otherNames + [name]
        return all.contains { $0 == input }
    }
}

struct ShouldCheckFood: MatchingFood {
    let name: String
    var checked: Bool = false
    var otherNames: [String] = []
}

struct InputedFood: Food {
    let name: String
    var shouldCheck: Bool = false
    var registeredDate: Date?
}

struct MatchingInputFood: MatchingFood {
    let name: String
    var shouldCheck: Bool = false
    var registeredDate: Date?
    let otherNames: [String]
    
    init(inputedFood: InputedFood) {
        self.name = inputedFood.name
        self.shouldCheck = inputedFood.shouldCheck
        self.registeredDate = inputedFood.registeredDate
        
        let dataStore = FoodOtherNamesDataStore()
        otherNames = dataStore.getOtherName(for: inputedFood.name)
    }
}

struct Meal {
    let date: Date
    let foods: [InputedFood]
}
