//
//  Kanji.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: Holds the information for one kanji
//

import Foundation

class Kanji: StudyObject {
    
    init(identifier: String, objectText: String, imaAnswer: [String], kunAnswer: [String], onAnswer: [String]) {
        super.init(identifier: identifier, object: objectText)
        self.imaAnswer = imaAnswer
        self.kunAnswer = kunAnswer
        self.onAnswer = onAnswer
        
    }
    
    var imaAnswer = [""]
    
    var kunAnswer = [""]
    
    var onAnswer = [""]
    
    var shouldStudy = false
    
    
}
