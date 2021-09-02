//
//  MenuSection.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol MenuSection {
    var hasExpandArrow: Bool { get }
}

enum MainMenuSection: Int, CaseIterable {
    case Study
    case Quiz
    
    var description: String {
        switch self {
        case .Study: return "Study"
        case .Quiz: return "Quiz"
        }
    }
    
}

enum StudyOptions: Int, CaseIterable, MenuOption {
    case vocab
    case kanji
    case studyList
    
    var identifier: String {
        switch self {
        case .vocab: return "StudyOption"
        case .kanji: return "StudyOption"
        case .studyList: return "StudyListStudyMenuOption"
        }
    }
    
    var image: UIImage {
        switch self {
        case .vocab: return UIImage(named: "hiragana_icon")?.withTintColor(.white) ?? UIImage()
        case .kanji: return UIImage(named: "kanji_icon")?.withTintColor(.white) ?? UIImage()
        case .studyList:
            if Auth.auth().currentUser?.uid == nil {
                return #imageLiteral(resourceName: "good").withTintColor(.darkGray)
            } else {
                return #imageLiteral(resourceName: "good").withTintColor(.white)
            }
        }
    }
    
    var description: String {
        switch self {
        case .vocab: return "Vocab"
        case .kanji: return "Kanji"
        case .studyList: return "Study List"
        }
    }
    
    var hasExpandArrow: Bool {
        switch self {
        case .vocab: return true
        case .kanji: return true
        case .studyList: return false
        }
    }
}

enum QuizOptions: Int, CaseIterable, MenuOption {
    case vocab
    case kanji
    case daily
    case studyList
    
    var identifier: String {
        switch self {
        case .vocab: return "VocabularyQuizMenuOption"
        case .kanji: return "KanjiQuizMenuOption"
        case .daily: return "DailyQuizMenuOption"
        case .studyList: return "StudyListQuizMenuOption"
        }
    }
    
    var image: UIImage {
        switch self {
        case .vocab: return UIImage(named: "hiragana_icon")?.withTintColor(.white) ?? UIImage()
        case .kanji: return UIImage(named: "kanji_icon")?.withTintColor(.white) ?? UIImage()
        case .daily: return #imageLiteral(resourceName: "daily_not_visited")
        case .studyList:
            if Auth.auth().currentUser?.uid == nil {
                return #imageLiteral(resourceName: "good").withTintColor(.darkGray)
            } else {
                return #imageLiteral(resourceName: "good").withTintColor(.white)
            }
        }
    }
    
    var description: String {
        switch self {
        case .vocab: return "Vocab"
        case .kanji: return "Kanji"
        case .daily: return "Daily"
        case .studyList: return "Study List"
        }
    }
    
    var hasExpandArrow: Bool {
        switch self {
        case .vocab: return true
        case .kanji: return true
        case .daily: return false
        case .studyList: return false
        }
    }
}

enum VocabStudyOptions: Int, CaseIterable, MenuOption {
    case chapter2
    case chapter3
    case chapter4
    case chapter5
    case chapter6
    case chapter7
    case chapter8
    case chapter9
    case chapter10
    case chapter11
    case chapter12
    
    var identifier: String {
        return "VocabularyStudyMenuOption"
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    var description: String {
        switch self {
        case .chapter2: return "Chapter 2"
        case .chapter3: return "Chapter 3"
        case .chapter4: return "Chapter 4"
        case .chapter5: return "Chapter 5"
        case .chapter6: return "Chapter 6"
        case .chapter7: return "Chapter 7"
        case .chapter8: return "Chapter 8"
        case .chapter9: return "Chapter 9"
        case .chapter10: return "Chapter 10"
        case .chapter11: return "Chapter 11"
        case .chapter12: return "Chapter 12"
        }
    }
    
    var hasExpandArrow: Bool {
        return false
    }
}

enum KanjiStudyOptions: Int, CaseIterable, MenuOption {
    case chapter4
    case chapter5
    case chapter6
    case chapter7
    case chapter8
    case chapter9
    case chapter10
    case chapter11
    case chapter12
    
    var identifier: String {
        return "KanjiStudyMenuOption"
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    var description: String {
        switch self {
        case .chapter4: return "Chapter 4"
        case .chapter5: return "Chapter 5"
        case .chapter6: return "Chapter 6"
        case .chapter7: return "Chapter 7"
        case .chapter8: return "Chapter 8"
        case .chapter9: return "Chapter 9"
        case .chapter10: return "Chapter 10"
        case .chapter11: return "Chapter 11"
        case .chapter12: return "Chapter 12"
        }
    }
    
    var hasExpandArrow: Bool {
        return false
    }
}

enum VocabQuizOptions: Int, CaseIterable, MenuOption {
    case chapter2
    case chapter3
    case chapter4
    case chapter5
    case chapter6
    case chapter7
    case chapter8
    case chapter9
    case chapter10
    case chapter11
    case chapter12
    
    var identifier: String {
        return "VocabularyQuizMenuOption"
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    var description: String {
        switch self {
        case .chapter2: return "Chapter 2"
        case .chapter3: return "Chapter 3"
        case .chapter4: return "Chapter 4"
        case .chapter5: return "Chapter 5"
        case .chapter6: return "Chapter 6"
        case .chapter7: return "Chapter 7"
        case .chapter8: return "Chapter 8"
        case .chapter9: return "Chapter 9"
        case .chapter10: return "Chapter 10"
        case .chapter11: return "Chapter 11"
        case .chapter12: return "Chapter 12"
        }
    }
    
    var hasExpandArrow: Bool {
        return false
    }
}

enum KanjiQuizOptions: Int, CaseIterable, MenuOption {
    case chapter4
    case chapter5
    case chapter6
    case chapter7
    case chapter8
    case chapter9
    case chapter10
    case chapter11
    case chapter12
    
    var identifier: String {
        return "KanjiQuizMenuOption"
    }
    
    var image: UIImage {
        return UIImage()
    }
    
    var description: String {
        switch self {
        case .chapter4: return "Chapter 4"
        case .chapter5: return "Chapter 5"
        case .chapter6: return "Chapter 6"
        case .chapter7: return "Chapter 7"
        case .chapter8: return "Chapter 8"
        case .chapter9: return "Chapter 9"
        case .chapter10: return "Chapter 10"
        case .chapter11: return "Chapter 11"
        case .chapter12: return "Chapter 12"
        }
    }
    
    var hasExpandArrow: Bool {
        return false
    }
}
