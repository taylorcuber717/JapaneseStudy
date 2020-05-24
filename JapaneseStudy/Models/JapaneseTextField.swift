//
//  JapaneseTextField.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/20/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

class JapaneseTextField: UITextField {
    
    func tryLoggingPrimaryLanguageInfoOnKeyboard() {
        for keyboardInputModes in UITextInputMode.activeInputModes{
            if let language = keyboardInputModes.primaryLanguage{
               //dump(language)
            }
        }
    }
    
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
        print("failed")
        return super.textInputMode
    }
    
}
