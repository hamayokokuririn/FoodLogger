//
//  ContentsServiceTests.swift
//  VisionTestTests
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation
import XCTest
@testable import FoodLogger

final class ContentsServiceTests: XCTestCase {
    var service: ContentsService<TestReader>! = nil
    
    override func setUp() async throws {
        self.service = try ContentsService(reader: TestReader())
    }
    
    func testFetchShouldCheckFoodList() async throws {
        let result = await service.fetchShouldCheckFoodList()
        XCTAssertEqual(result[0].name, "米")
        XCTAssertEqual(result[0].otherNames, ["コメ"])
        XCTAssertEqual(result[1].name, "かぼちゃ")
        XCTAssertEqual(result[1].otherNames, [])
        XCTAssertEqual(result[2].name, "人参")
        XCTAssertEqual(result[2].otherNames, ["にんじん", "ニンジン"])
    }
    
    class TestReader: JSONReader {
        typealias FileName = File
        func read() throws -> [String] {
            return ["米", "かぼちゃ", "人参"]
        }
        enum File: String, CaseIterable {
            case test
        }
    }
    
}
