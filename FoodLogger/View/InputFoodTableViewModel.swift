//
//  InputFoodTableViewModel.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation
import UIKit

struct InputFoodTableViewModel {
    struct CellShowData {
        let name: String
        let dateString: String
        var shouldCheck: Bool
    }
    
    var cellShowDataList: [CellShowData]
    
    @MainActor
    init(wordList: [String], inputedList: [MatchingInputFood], shouldCheckList: [ShouldCheckFood]) {
    
        self.cellShowDataList = wordList.map { word in
            let date = Self.dateForName(word: word, inputedList: inputedList)
            let shouldCheck = Self.shouldCheckForName(word: word, inputShouldCheckList: shouldCheckList)
            return CellShowData(name: word,
                                dateString: date,
                                shouldCheck: shouldCheck)
        }
    }
    
    static let emptyDateString = "---"
    
    static func dateForName(word: String, inputedList: [MatchingInputFood]) -> String {
        let date: String
        if let first = inputedList.first(where: { food in
            food.hasSameName(with: word)
        }) {
            date = self.date(input: first.registeredDate)
        } else {
            date = emptyDateString
        }
        return date
    }
    
    private static func date(input: Date?) -> String {
        if let date = input {
            return DateFormatter().custom.string(from: date)
        }
        return emptyDateString
    }
    
    
    static func shouldCheckForName(word: String, inputShouldCheckList: [ShouldCheckFood]) -> Bool {
        
        return inputShouldCheckList.contains { food in
            return food.hasSameName(with: word)
        }
    }
    
    func onPrepare() async {
        let inputedList = cellShowDataList.map {
            InputedFood(name: $0.name, registeredDate: Date())
        }
        let meal = Meal(date: Date(),
                        foods: inputedList)
        await UIApplication.shared.contentsService.inputDataStore.insert(meal: meal)
        
        let list = cellShowDataList.map {
            return ($0.name, $0.shouldCheck)
        }
        await UIApplication.shared.contentsService.shouldCheckDataStore.updateFoodList(foodList: list)
    }
    
    mutating func updateShouldCheck(name: String, checked: Bool) {
        if let index = cellShowDataList.firstIndex(where: {$0.name == name}) {
            self.cellShowDataList[index].shouldCheck = checked
        }
    }
    
}
