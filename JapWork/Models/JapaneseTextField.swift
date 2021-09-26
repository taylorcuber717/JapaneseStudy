//
//  JapaneseTextField.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/20/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This is an extension of the UITextField that attempts to set the keyboard to japanese.
//  This will only work if the user has installed this keyboard, prints an error if they do not.
//

import UIKit

class JapaneseTextField: UITextField {
    
//    func tryLoggingPrimaryLanguageInfoOnKeyboard() {
//        for keyboardInputModes in UITextInputMode.activeInputModes{
//            if let language = keyboardInputModes.primaryLanguage{
//               //dump(language)
//            }
//        }
//    }
    
    var languageCode: String?{
        didSet {
            if self.isFirstResponder{
                self.resignFirstResponder()
                self.becomeFirstResponder()
            }
        }
    }
    
    override var textInputMode: UITextInputMode? {
        
        if let languageCode = self.languageCode {
            for keyboardInputModes in UITextInputMode.activeInputModes {
                if let language = keyboardInputModes.primaryLanguage {
                    if language == languageCode {
                        return keyboardInputModes;
                    }
                }
            }
        }
        print("Error: JapaneseTextField.textInputMode could not get keyboard input language")
        return super.textInputMode
    }
    
}
