//
//  LinguisticService.swift
//  VisionTest
//
//  Created by 齋藤健悟 on 2023/01/13.
//

import Foundation
import NaturalLanguage
import Algorithms

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
    
    typealias TextTag = (text: String, tag: NLTag)
    
    func makeTagByNL(text: String) -> [TextTag] {
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.setLanguage(NLLanguage.japanese, range: text.startIndex..<text.endIndex)
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
    
func ommitPunctuation(array: [TextTag]) -> [String] {
    return array.chunked(by: {
        $0.tag == $1.tag
    }).filter {
        $0.first?.tag == .otherWord
        || $0.first?.tag == .noun
    }.map {
        $0.reduce("") { $0 + $1.text }
    }
}
    
}
