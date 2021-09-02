//
//  SettingsCell.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
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
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
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
    
    @objc func handleSwitchAction(sender: UISwitch) {
        
        print("handle is running")
        
        if sender.isOn {
            print("on")
        } else {
            print("off")
        }
        
    }
    
}
