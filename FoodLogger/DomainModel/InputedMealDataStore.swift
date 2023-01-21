//
//  InputedFoodDataStore.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

actor InputedMealDataStore {
    
    private var inputedMealList: [Meal] = []
    
    func insert(meal: Meal) {
        inputedMealList.append(meal)
    }
    
    func getMealList() -> [Meal] {
        inputedMealList
    }
}
