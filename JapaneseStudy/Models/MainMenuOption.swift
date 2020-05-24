//
//  MainMenuOption.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

class MainMenuOption: MenuOption {
    
    var hasExpandArrow: Bool {
        return false
    }
    
    var identifier: String = "MainMenuOption"
    
    var row: Row?
        
    enum Row: Int {
        case vocabulary
        case kanji
    }
    
    var description: String {
        
        switch row {
        case .vocabulary: return "Vocabulary"
        case .kanji: return "Kanji"
        case .none:
            print("Error: row is none in vocabulary menu: sent in description")
            return String()
        }
    }
    
    var image: UIImage {
        switch row {
        case .vocabulary: return UIImage(named: "hiragana_icon")?.withTintColor(.white) ?? UIImage()
        case .kanji: return UIImage(named: "kanji_icon")?.withTintColor(.white) ?? UIImage()
        case .none:
            print("Error: row is none in vocabulary menu: sent in image")
            return UIImage()
        }
    }
    
    var expandImage: UIImage {
        return UIImage(named: "expand_arrow_icon")?.withTintColor(.white) ?? UIImage()
    }
    
    required init(startingRow: Int) {
        row = Row(rawValue: startingRow)
    }
    
}

//enum MainMenOption: Int, CustomStringConvertible {
//
//    case vocabulary
//    case kanji
//
//    var description: String {
//        switch self {
//        case .vocabulary: return "Vocabulary"
//        case .kanji: return "Kanji"
//        }
//    }
//
//    var image: UIImage {
//        switch self {
//        case .vocabulary: return UIImage(named: "hiragana_icon")?.withTintColor(.white) ?? UIImage()
//        case .kanji: return UIImage(named: "kanji_icon")?.withTintColor(.white) ?? UIImage()
//        }
//    }
//
//}
