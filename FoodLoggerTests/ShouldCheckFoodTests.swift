//
//  ShouldCheckFood.swift
//  FoodLoggerTests
//
//  Created by 齋藤健悟 on 2023/01/17.
//

import Foundation
import XCTest
@testable import FoodLogger

final class ShouldCheckFoodTests: XCTestCase {
    
    func testHasSameName() {
        let food = ShouldCheckFood(name: "apple", otherNames: ["a", "app"])
        
        XCTAssertTrue(food.hasSameName(with: "apple"))
        XCTAssertFalse(food.hasSameName(with: "bean"))
        
        XCTAssertTrue(food.hasSameName(with: "a"))
        XCTAssertTrue(food.hasSameName(with: "app"))
        XCTAssertFalse(food.hasSameName(with: "b"))
    }
    
}
