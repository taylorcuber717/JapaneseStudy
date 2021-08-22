//
//  StudyObject.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
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
