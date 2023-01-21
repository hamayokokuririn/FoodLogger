//
//  FoodOtherNamesDataStoreTests.swift
//  FoodLoggerTests
//
//  Created by 齋藤健悟 on 2023/01/19.
//

import Foundation
import XCTest
@testable import FoodLogger

final class FoodOtherNamesDataStoreTests: XCTestCase {
    let dataStore = FoodOtherNamesDataStore()
    
    func testGetOtherName() {
        XCTAssertNil(dataStore.getOtherName(for: "a"))
        
        XCTAssertEqual(dataStore.getOtherName(for: "人参"),
                       ["にんじん", "ニンジン"])
        XCTAssertEqual(dataStore.getOtherName(for: "にんじん"),
                       ["ニンジン", "人参"])
    }
    
}
