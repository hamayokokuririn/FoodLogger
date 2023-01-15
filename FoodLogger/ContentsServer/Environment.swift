//
//  Environment.swift
//  FoodLogger
//
//  Created by 齋藤健悟 on 2023/01/15.
//

import Foundation

class Environment {
    static let shared = Environment()
    let contentService: ContentsService<ReadJSONForSaitamaSyokuhin>
    
    private init() {
        do {
            self.contentService = try ContentsService(reader: ReadJSONForSaitamaSyokuhin())
        } catch {
            fatalError()
        }
    }
}
