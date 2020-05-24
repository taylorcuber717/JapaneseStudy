//
//  Kanji.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import Foundation

class Kanji: StudyObject {
    
    init(identifier: String, objectText: String, imaAnswer: [String], kunAnswer: [String], onAnswer: [String]) {
        self.identifier = identifier
        self.object = objectText
        self.imaAnswer = imaAnswer
        self.kunAnswer = kunAnswer
        self.onAnswer = onAnswer
        
    }
    
    var identifier: String

    var object: String
    
    var imaAnswer: [String]
    
    var kunAnswer: [String]
    
    var onAnswer: [String]
    
    var shouldStudy = false
    
    
}
