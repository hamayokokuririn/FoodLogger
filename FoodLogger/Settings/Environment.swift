//
//  Environment.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

protocol Environment {
    associatedtype Reader: JSONReader
    associatedtype InputDataStore
    
    var reader: Reader { get }
}

struct InMemory: Environment {
    typealias Reader = JSONReaderForSaitamaSyokuhin
    typealias InputDataStore = InputedMealDataStore
    
    let reader = JSONReaderForSaitamaSyokuhin()
}
