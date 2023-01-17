//
//  InputFoodTableViewModel.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

struct InputFoodTableViewModel {
    struct CellShowData {
        let name: String
        let dateString: String
        let shouldCheck: Bool
    }
    
    var inputedList = [InputedFood]()
    var cellShowDataList: [CellShowData]
    
    @MainActor
    init(wordList: [String], inputedList: [InputedFood], shouldCheckList: [ShouldCheckFood]) {
    
        self.inputedList = inputedList
        self.cellShowDataList = wordList.map { word in
            let date = Self.dateForName(word: word, inputedList: inputedList)
            let shouldCheck = Self.shouldCheckForName(word: word, shouldCheckList: shouldCheckList)
            return CellShowData(name: word,
                                dateString: date,
                                shouldCheck: shouldCheck)
        }
        
    }
    
    static let emptyDateString = "---"
    
    static func dateForName(word: String, inputedList: [InputedFood]) -> String {
        let date: String
        if let first = inputedList.first(where: { food in
            food.name == word
        }) {
            date = self.date(input: first)
        } else {
            date = emptyDateString
        }
        return date
    }
    
    private static func date(input: InputedFood) -> String {
        if let date = input.registeredDate {
            return DateFormatter().custom.string(from: date)
        }
        return emptyDateString
    }
    
    
    static func shouldCheckForName(word: String, shouldCheckList: [ShouldCheckFood]) -> Bool {
        
        return shouldCheckList.contains { food in
            if food.name == word {
                return true
            }
            return food.otherNames.contains(where: { $0 == word })
        }
    }
    
    
}
