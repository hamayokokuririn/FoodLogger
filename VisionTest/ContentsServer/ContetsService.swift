//
//  ContetsService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation


actor ContentsService {
    
    func fetchShouldCheckFoodList() async throws -> [ShouldCheckFood] {
        let reader = ReadJSONForSaitamaSyokuhin()
        let readData = try reader.read(fileName: .food_1)
        let foodList = readData.map {
            ShouldCheckFood(name: $0)
        }
        return foodList
    }
}
