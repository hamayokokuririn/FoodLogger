//
//  FoodOtherNamesDataStore.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/19.
//

import Foundation

struct FoodOtherNamesDataStore {
    let listOfOtherNamesSet: [Set<String>] = [Set(["人参", "にんじん", "ニンジン"])]
    
    func getOtherName(for name: String) -> [String] {
        guard let index = listOfOtherNamesSet.firstIndex(where: { otherNamesSet in
            otherNamesSet.contains(name)
        }) else {
            return []
        }
        var set = listOfOtherNamesSet[index]
        set.remove(name)
        return set.sorted()
    }
}
