//
//  SuccessPopUpWindow.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/23/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This is a cool pop up view for a success message.  Must implement delegate to handle the continue function.
//

import UIKit

protocol SuccessPopUpDelegate {
    func onContinue()
}

class SuccessPopUpWindow: UIView {
    
    //MARK: - Properties:
    
    var delegate: SuccessPopUpDelegate?
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "a;sldfhaaasdfh"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(onContinue), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 3
        return button
    }()
    
    //MARK: - Init:
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers:
    
    func configureUI() {
        
        self.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        continueButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: 12).isActive = true
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
    }
    
    @objc func onContinue() {
        delegate?.onContinue()
    }
    
}
