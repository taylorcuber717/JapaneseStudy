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
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Study
    case Quiz
    case Account
    
    var description: String {
        switch self {
        case .Study: return "Study"
        case .Quiz: return "Quiz"
        case .Account: return "Account"
        }
    }
    
}

enum SettingsStudyOptions: Int, CaseIterable, SettingsSectionType {
    case includeSupplementary
    case studyTest
    
    var containsSwitch: Bool {
        switch self {
        case .includeSupplementary: return true
        case .studyTest: return false
        }
    }
    
    var description: String {
        switch self {
        case .includeSupplementary: return "Include Supplementary Vocab"
        case .studyTest: return "Study test"
        }
    }
    
    var isOn: Bool {
        let defaults = UserDefaults.standard
        switch  self {
        case .includeSupplementary: return defaults.bool(forKey: "studySupVocab")
        case .studyTest: return false
        }
    }
    
    var identifier: String {
        switch self {
        case .includeSupplementary: return "studySupVocab"
        case .studyTest: return "studyTest"
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
        let defaults = UserDefaults.standard
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
