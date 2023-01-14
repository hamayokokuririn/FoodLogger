//
//  ReadJSONForSaitamaSyokuhin.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/14.
//

import Foundation

protocol JSONReader {
    associatedtype FileName
    func read(fileName: FileName) throws -> [String]
}


struct ReadJSONForSaitamaSyokuhin: JSONReader {
    typealias FileName = File
    
    private let extensionName = "json"
    
    func read(fileName: File) throws -> [String] {
        guard let fileURL = Bundle.main.url(forResource: fileName.rawValue, withExtension: extensionName) else {
            throw NSError()
        }
        let fileContents = try String(contentsOf: fileURL, encoding: .utf8)
        let json = try JSONDecoder().decode(JSON.self, from: fileContents.data(using: .utf8)!)
        
        return Array(json.data.joined())
    }
    
    struct JSON: Decodable {
        let columns: [String]
        let index: [Int]
        let data: [[String]]
    }
    
    enum File: String {
        case food_1
    }
    
}
