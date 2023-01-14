//
//  LinguisticServiceTests.swift
//  VisionTestTests
//
//  Created by 齋藤健悟 on 2023/01/13.
//

import Foundation
import XCTest
@testable import FoodLogger
import NaturalLanguage

class LinguisticServiceTests: XCTestCase {
    
    let text = """
    野菜（じゃがいも（国産）、にん
    じん、とうもろこし）、トマトペースト、コーンスターチ、炒めたまねぎ、チキンエキス、ぶなしめじ、鶏レバーそぼろ、砂糖、オイスターソース
    """
    
    
    func testMakeTag() {
        let s = LinguisticService()
        
        let result = s.makeTag(text: text)
        XCTAssertEqual(result[0].0, "野菜")
        XCTAssertEqual(result[0].1, NSLinguisticTag.word)
    }
    
    func testMakeTagByNL() {
        let s = LinguisticService()
        let result = s.makeTagByNL(text: text)
        XCTAssertEqual(result[0].text, "野菜")
        XCTAssertEqual(result[0].tag, NLTag.otherWord)
        
        XCTAssertEqual(result[1].text, "（")
        XCTAssertEqual(result[1].tag, NLTag.punctuation)
    }
    
    func testOmmitOunctuation() {
        let s = LinguisticService()
        let tags = s.makeTagByNL(text: text)
        let result = s.ommitPunctuation(array: tags)
        XCTAssertEqual(result[0], "野菜")
        XCTAssertEqual(result[1], "じゃがいも")
        XCTAssertEqual(result[2], "国産")
        XCTAssertEqual(result[3], "にんじん")
    }
    
}
