//
//  ContetsService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation


actor ContentsService<Env: Environment> {
    
    let inputDataStore = InputedFoodDataStore()
    let shouldCheckDataStore: ShouldCheckFoodDataStore<Env.Reader>
    
    init(env: Env) throws {
        self.shouldCheckDataStore = try ShouldCheckFoodDataStore(reader: env.reader)
    }
    
    func fetchShouldCheckFoodList() async -> [ShouldCheckFood] {
        let foodList = await shouldCheckDataStore.getFoodList()
        // TODO: データ側で処理したい
        let addedList = addOtherNames(preData: foodList)
        
        return addedList
    }
    
    private func addOtherNames(preData: [ShouldCheckFood]) -> [ShouldCheckFood] {
        var foodList = preData
        foodList[0].otherNames = ["コメ"]
        if let index = foodList.firstIndex(where: {$0.name == "人参"}) {
            foodList[index].otherNames = ["にんじん", "ニンジン"]
        }
        return foodList
    }
}
