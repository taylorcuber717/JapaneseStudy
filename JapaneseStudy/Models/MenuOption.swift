//
//  MenuOption.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/7/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

protocol MenuOption {
    
    var identifier: String { get }
    
    var description: String { get }
    
    var image: UIImage { get }
    
    var hasExpandArrow: Bool { get }
    
}
