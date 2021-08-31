//
//  FailurePopUpWindow.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/21/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

protocol FailurePopUpDelegate {
    func onTryAgain()
    func onShowAnswers()
}

class FailurePopUpWindow: UIView {
    
    //MARK: - Properties:
    
    var delegate: FailurePopUpDelegate?
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "a;sldfhaaasdfh"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    var tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.addTarget(self, action: #selector(onTryAgain), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 3
        return button
    }()
    
    var showAnswersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show Answers", for: .normal)
        button.addTarget(self, action: #selector(onShowAnswers), for: .touchUpInside)
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
        
        self.addSubview(tryAgainButton)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        tryAgainButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        tryAgainButton.rightAnchor.constraint(equalTo: centerXAnchor, constant: -6).isActive = true
        tryAgainButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(showAnswersButton)
        showAnswersButton.translatesAutoresizingMaskIntoConstraints = false
        showAnswersButton.leftAnchor.constraint(equalTo: centerXAnchor, constant: 6).isActive = true
        showAnswersButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        showAnswersButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        showAnswersButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: tryAgainButton.topAnchor, constant: 12).isActive = true
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
    }
    
    @objc func onTryAgain() {
        delegate?.onTryAgain()
    }
    
    @objc func onShowAnswers() {
        delegate?.onShowAnswers()
    }
    
}
