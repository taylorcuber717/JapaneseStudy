//
//  Word.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import Foundation

class Word: StudyObject {
    
    init(identifier: String, objectText: String, imaAnswer: String, extraInfo: String) {
        self.identifier = identifier
        self.object = objectText
        self.imaAnswer = imaAnswer
        self.extraInfo = extraInfo
    }
    
    var identifier: String
    
    var object: String
    
    var imaAnswer: String
    
    var extraInfo: String
    
    var shouldStudy = false
    
}
