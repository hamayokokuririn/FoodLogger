//
//  ContentsService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation


actor ContentsService<Env: Environment> {
    
    let inputDataStore = InputedMealDataStore()
    let shouldCheckDataStore: ShouldCheckFoodDataStore<Env.Reader>
    
    init(env: Env) throws {
        self.shouldCheckDataStore = try ShouldCheckFoodDataStore(reader: env.reader)
    }
    
    func fetchShouldCheckFoodList() async -> [ShouldCheckFood] {
        return await shouldCheckDataStore.getFoodList()
    }
    
    
}
