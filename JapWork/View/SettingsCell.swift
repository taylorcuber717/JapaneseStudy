//
//  SettingsCell.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This cell holds the contents one of the options of the settings page
//

import UIKit
import FirebaseAuth

class SettingsCell: UITableViewCell {
    
    //MARK: - Properties:
    
    var settingsSectionType: SettingsSectionType? {
        didSet {
            guard let sectionType = settingsSectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
            switchControl.isOn = sectionType.isOn
            
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        switchControl.onTintColor = .red
        return switchControl
    }()
    
    //MARK: - Init:
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(switchControl)
        switchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        switchControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers:
    
}
