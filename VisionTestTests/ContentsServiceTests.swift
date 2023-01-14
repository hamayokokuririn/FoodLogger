//
//  ContentsServiceTests.swift
//  VisionTestTests
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation
import XCTest
@testable import VisionTest

final class ContentsServiceTests: XCTestCase {
    let service = ContentsService(reader: TestReader())
    
    func testFetchShouldCheckFoodList() async throws {
        let result = try await service.fetchShouldCheckFoodList(fileName: "")
        XCTAssertEqual(result[0].name, "米")
        XCTAssertEqual(result[0].otherNames, ["コメ"])
        XCTAssertEqual(result[1].name, "かぼちゃ")
        XCTAssertEqual(result[1].otherNames, [])
        XCTAssertEqual(result[2].name, "人参")
        XCTAssertEqual(result[2].otherNames, ["にんじん", "ニンジン"])
    }
    
    class TestReader: JSONReader {
        typealias FileName = String
        func read(fileName: String) throws -> [String] {
            return ["米", "かぼちゃ", "人参"]
        }
    }
    
}
