//
//  UpComingCell.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/17/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

class UpComingCell: UITableViewCell {
    
    //MARK: - Properties:
    
    var studyObjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    //MARK: - Init:
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        
        self.addSubview(studyObjectLabel)
        studyObjectLabel.translatesAutoresizingMaskIntoConstraints = false
        studyObjectLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        studyObjectLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        studyObjectLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        studyObjectLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers:
    
}
