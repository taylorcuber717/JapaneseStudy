//
//  SettingsSection.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

protocol SettingsSectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case Study
    case Quiz
    
    var description: String {
        switch self {
        case .Study: return "Study"
        case .Quiz: return "Quiz"
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
}
