//
//  ReadJSONTests.swift
//  VisionTestTests
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation
@testable import VisionTest
import XCTest

final class ReadJSONTests: XCTestCase {
    let reader = ReadJSONForSaitamaSyokuhin()
    
    func testRead() {
        do {
            let result = try reader.read(fileName: .food_1)
            XCTAssertEqual("米(うるち米・もち米・米粉)", result[0])
        } catch {
            XCTFail()
        }
    }
    
}
