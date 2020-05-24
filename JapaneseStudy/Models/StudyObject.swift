//
//  StudyObject.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/15/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import Foundation

protocol StudyObject {
    
    var identifier: String { get }
    
    var object: String { get }
    
    var shouldStudy: Bool { get }
    
}
