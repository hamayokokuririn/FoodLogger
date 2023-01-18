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
        // TODO: データ側で処理したい
        self.shouldCheckFoodList = Self.addOtherNames(preData: foodList)
    }
    
    private static func addOtherNames(preData: [ShouldCheckFood]) -> [ShouldCheckFood] {
        var foodList = preData
        foodList[0].otherNames = ["コメ"]
        if let index = foodList.firstIndex(where: {$0.name == "人参"}) {
            foodList[index].otherNames = ["にんじん", "ニンジン"]
        }
        return foodList
    }
    
    func insert(foodList: [ShouldCheckFood]) {
        shouldCheckFoodList += foodList
    }
    
    func getFoodList() -> [ShouldCheckFood] {
        shouldCheckFoodList
    }
    
    func updateFoodList(foodList: [(name: String, checked: Bool)]) {
        for otherFood in foodList {
            if let index = shouldCheckFoodList.firstIndex(where: { food in
                food.hasSameName(with: otherFood.name)
            }) {
                shouldCheckFoodList[index].checked = otherFood.checked
            }
        }
    }
}
