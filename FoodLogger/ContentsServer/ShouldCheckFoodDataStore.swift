//
//  ShouldCheckFoodDataStore.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

actor ShouldCheckFoodDataStore<Reader: JSONReader> {
    let reader: Reader
    
    private var shouldCheckFoodList: [ShouldCheckFood] = []
    
    init(reader: Reader) throws {
        self.reader = reader
        let readData = try reader.read()
        let foodList = readData.map {
            ShouldCheckFood(name: $0)
        }
        self.shouldCheckFoodList = foodList
    }
    
    func insert(foodList: [ShouldCheckFood]) {
        shouldCheckFoodList += foodList
    }
    
    func getFoodList() -> [ShouldCheckFood] {
        shouldCheckFoodList
    }
}
