//
//  StudyObject.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This is used so that we can hold either the information for a kanji or a vocabulary word.
//  As in most of our views we want to be able to handle lists of one or the other or both.
//

import Foundation

public class StudyObject: NSObject {
    
    init(identifier: String, object: String) {
        self.identifier = identifier
        self.object = object
    }
    
    var identifier = ""
    
    var object = ""
    
}
