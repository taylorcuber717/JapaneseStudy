//
//  MenuOptionCell.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This cell holds the contents one of the options of the main menu.
//

import UIKit
import FirebaseAuth

class MenuOptionCell: UITableViewCell {

    //MARK: - Properties
    
    var menuOption: MenuOption? {
        didSet {
            guard let menuOption = menuOption else { return }
            descriptionLabel.text = menuOption.description
            expandArrowImageView.isHidden = !menuOption.hasExpandArrow
            iconImageView.image = menuOption.image
            
            if Auth.auth().currentUser?.uid == nil && (menuOption.identifier == "StudyListStudyMenuOption" || menuOption.identifier == "StudyListQuizMenuOption") {
                descriptionLabel.textColor = .darkGray
                self.isUserInteractionEnabled = false
            }
            
        }
    }
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }() 
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let expandArrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "expand_arrow_icon")?.withTintColor(.white)
        return iv
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(expandArrowImageView)
        expandArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        expandArrowImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
        expandArrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        expandArrowImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        expandArrowImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers

}
