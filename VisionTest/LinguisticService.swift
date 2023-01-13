//
//  LinguisticService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/13.
//

import Foundation
import NaturalLanguage

struct LinguisticService {
    
    func makeTag(text: String) -> [(String, NSLinguisticTag)] {
        let linguisticTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "ja"), options: 0)
        linguisticTagger.string = text
        
        var array = [(String, NSLinguisticTag?)]()
        linguisticTagger.enumerateTags(in: NSRange(location: 0, length: text.count),
                                       scheme: NSLinguisticTagScheme.tokenType,
                                       options: [.omitWhitespace, .joinNames]) {
            tag, tokenRange, sentenceRange, stop in
            let subString = (text as NSString).substring(with: tokenRange)
            print("\(subString) : \(String(describing: tag))")
            array.append((subString, tag))
        }
        return array.compactMap { str, tag in
            guard let tag else {
                return nil
            }
            return (str, tag)
        }
    }
    
    func makeTagByNL(text: String) -> [(String, NLTag)] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        let options: NLTagger.Options = [.joinNames, .omitWhitespace]
        
        var array = [(String, NLTag)]()
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                array.append((String(text[tokenRange]), tag))
            }
            return true
        }
        
        return array
    }
    
    func ommitPunctuation(array: [(String, NLTag)]) -> [String] {
        var oneWordArray = [String]()
        var oneWordResult = [String]()
        for wordAndTag in array {
            if wordAndTag.1 == NLTag.punctuation {
               if oneWordArray.count > 0 {
                   let reduced = oneWordArray.reduce("") { $0 + $1 }
                   oneWordResult.append(reduced)
                   oneWordArray.removeAll()
               }
               continue
            }
               
            oneWordArray.append(wordAndTag.0)
        }
        if !oneWordArray.isEmpty {
            let reduced = oneWordArray.reduce("") { $0 + $1 }
            oneWordResult.append(reduced)
        }
        
        return oneWordResult
    }
    
    
}
