//
//  SettingsSection.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import Foundation

protocol SettingsSectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var isOn: Bool { get }
    var identifier: String { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Study
    case Quiz
    case Account
    case Icons8
    
    var description: String {
        switch self {
        case .Study: return "Study"
        case .Quiz: return "Quiz"
        case .Account: return "Account"
        case .Icons8: return "Icons8"
        }
    }
    
}

enum SettingsStudyOptions: Int, CaseIterable, SettingsSectionType {
    case includeSupplementary
    case includeKanjiDaily
    case includeVocabDaily
    
    var containsSwitch: Bool {
        switch self {
        case .includeSupplementary: return true
        case .includeKanjiDaily: return true
        case .includeVocabDaily: return true
        }
    }
    
    var description: String {
        switch self {
        case .includeSupplementary: return "Include Supplementary Vocab"
        case .includeKanjiDaily: return "Include Kanji on Daily Quiz"
        case .includeVocabDaily: return "Include Vocab on Daily Quiz"
        }
    }
    
    var isOn: Bool {
        let defaults = UserDefaults.standard
        switch  self {
        case .includeSupplementary: return defaults.bool(forKey: "studySupVocab")
        case .includeKanjiDaily: return defaults.bool(forKey: "includeKanjiDaily")
        case .includeVocabDaily: return defaults.bool(forKey: "includeVocabDaily")
        }
    }
    
    var identifier: String {
        switch self {
        case .includeSupplementary: return "studySupVocab"
        case .includeKanjiDaily: return "includeKanjiDaily"
        case .includeVocabDaily: return "includeVocabDaily"
        }
    }
    
}

enum SettingsQuizOptions: Int, CaseIterable, SettingsSectionType {
    case includeSupplementary
    case randomizeQuiz
    
    var description: String {
        switch self {
        case .includeSupplementary: return "Include Supplementary Vocab"
        case .randomizeQuiz: return "Randomize Quiz Order"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .includeSupplementary: return true
        case .randomizeQuiz: return true
        }
    }
    
    var isOn: Bool {
        let defaults = UserDefaults.standard
        switch  self {
        case .includeSupplementary: return defaults.bool(forKey: "quizSupVocab")
        case .randomizeQuiz: return defaults.bool(forKey: "randomizeQuizOrder")
        }
    }
    
    var identifier: String {
        switch self {
        case .includeSupplementary: return "quizSupVocab"
        case .randomizeQuiz: return "randomizeQuizOrder"
        }
    }
}

enum SettingsAccountOptions: Int, CaseIterable, SettingsSectionType {
    case logOut
    
    var description: String {
        switch self {
        case .logOut: return "Logout"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .logOut: return false
        }
    }
    
    var isOn: Bool {
        switch  self {
        case .logOut: return false
        }
    }
    
    var identifier: String {
        switch self {
        case .logOut: return "logOut"
        }
    }
}

enum SettingsIcons8Options: Int, CaseIterable, SettingsSectionType {
    case description
    case link
    
    var description: String {
        switch self {
        case .description: return "All Icon's in this app are from Icons8"
        case .link: return "https://icons8.com"
        }
    }
    
    var containsSwitch: Bool {
        switch self {
        case .description: return false
        case .link: return false
        }
    }
    
    var isOn: Bool {
        switch  self {
        case .description: return false
        case .link: return false
        }
    }
    
    var identifier: String {
        switch self {
        case .description: return "iconsDescription"
        case .link: return "iconsLink"
        }
    }
}
