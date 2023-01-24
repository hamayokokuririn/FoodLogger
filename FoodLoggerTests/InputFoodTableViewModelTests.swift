//
//  InputFoodTableViewModelTests.swift
//  FoodLoggerTests
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation
import XCTest
@testable import FoodLogger

final class InputFoodTableViewModelTests: XCTestCase {
    let wordList = ["a", "b", "c"]
    let dateString = "2023年1月1日"
    lazy var inputedList: [MatchingInputFood] = {
        return [MatchingInputFood(inputedFood: InputedFood(name: "a", registeredDate: testDate))]
    }()
    
    lazy var shouldCheckList: [ShouldCheckFood] = {
        return [ShouldCheckFood(name: "a"),
                ShouldCheckFood(name: "d", otherNames: ["b"]),
                ShouldCheckFood(name: "e", otherNames: ["f"]),
        ]
    }()
    
    func testInit_nameはそのまま得られる() async {
        let viewModel = await InputFoodTableViewModel(wordList: wordList, inputedList: inputedList, shouldCheckList: shouldCheckList)
        let result = viewModel.cellShowDataList
        
        XCTAssertEqual(result[0].name, "a")
        XCTAssertEqual(result[1].name, "b")
        XCTAssertEqual(result[2].name, "c")
    }
    
    func testInit_input済みならばDateの表示() async {
        let viewModel = await InputFoodTableViewModel(wordList: wordList, inputedList: inputedList, shouldCheckList: shouldCheckList)
        let result = viewModel.cellShowDataList
        let empty = InputFoodTableViewModel.emptyDateString
        
        XCTAssertEqual(result[0].dateString, dateString)
        XCTAssertEqual(result[1].dateString, empty)
        XCTAssertEqual(result[2].dateString, empty)
    }
    
    func testInit_checkListにある場合にtrue() async {
        let viewModel = await InputFoodTableViewModel(wordList: wordList, inputedList: inputedList, shouldCheckList: shouldCheckList)
        let result = viewModel.cellShowDataList
        
        XCTAssertTrue(result[0].shouldCheck)
        XCTAssertTrue(result[1].shouldCheck)
        XCTAssertFalse(result[2].shouldCheck)
    }
    
    lazy var testDate: Date = {
        let df = DateFormatter().customDate
        
        return df.date(from: dateString)!
    }()
    
}
