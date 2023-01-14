//
//  ContetsService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation


actor ContentsService<Reader: JSONReader> {
    let reader: Reader
    init(reader: Reader) {
        self.reader = reader
    }
    
    func fetchShouldCheckFoodList(fileName: Reader.FileName) async throws -> [ShouldCheckFood] {
        let readData = try reader.read(fileName: fileName)
        let foodList = readData.map {
            ShouldCheckFood(name: $0)
        }
        
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
