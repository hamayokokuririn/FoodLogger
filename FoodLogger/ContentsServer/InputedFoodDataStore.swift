//
//  InputedFoodDataStore.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

actor InputedFoodDataStore {
    
    private var inputedFoodList: [InputedFood] = []
    
    func insert(foodList: [InputedFood]) {
        inputedFoodList += foodList
    }
    
    func getFoodList() -> [InputedFood] {
        inputedFoodList
    }
}
