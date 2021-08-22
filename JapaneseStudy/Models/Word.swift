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
        super.init(identifier: identifier, object: objectText)
        self.imaAnswer = imaAnswer
        self.extraInfo = extraInfo
    }
    
    var imaAnswer = ""
    
    var extraInfo = ""
    
    var shouldStudy = false
    
}
