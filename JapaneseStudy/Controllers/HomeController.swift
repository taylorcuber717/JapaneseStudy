//
//  ViewController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/1/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

protocol MainControllersDelegate: AnyObject {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool)
    func moveToSettings()
}

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: MainControllersDelegate?
    
    let japWorkIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "JapWorkAppIcon")
        return imageView
    }()
    
    let japWorkLabel: UILabel = {
        let label = UILabel()
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 50)!
        ]
        let attributedTitle = NSAttributedString(string: "Welcome to\nJapWork", attributes: attrs)
        label.attributedText = attributedTitle
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        setupGestureRecognizers()
        setupConstraints()
    }
    
    //MARK: - Handlers
    
    private func setupGestureRecognizers() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: false)
    }
    
    @objc func handleToggleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: true)
    }
    
    @objc func moveToSettings() {
        delegate?.moveToSettings()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .red
        
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        let button = UIButton(type: .custom)
        button.frame = container.frame
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 30)!
        ]
        let attributedTitle = NSAttributedString(string: "JapWork", attributes: attrs)
        button.setAttributedTitle(attributedTitle, for: .normal)
        container.addSubview(button)
        navigationItem.titleView = container
        
        let menuButton = UIButton()
        menuButton.setImage(#imageLiteral(resourceName: "hamburger_icon").withTintColor(.red), for: .normal)
        menuButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
        menuButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: menuButton), animated: false)
        
        let settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settings_icon").withTintColor(.red), for: .normal)
        settingsButton.addTarget(self, action: #selector(moveToSettings), for: .touchUpInside)
        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: settingsButton), animated: false)
        
    }
    
    func setupConstraints() {
        
        view.addSubview(japWorkIconImageView)
        japWorkIconImageView.translatesAutoresizingMaskIntoConstraints = false
        japWorkIconImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 175, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 300, height: 300)
        
        view.addSubview(japWorkLabel)
        japWorkLabel.translatesAutoresizingMaskIntoConstraints = false
        japWorkLabel.anchor(top: japWorkIconImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: -25, paddingBottom: 0, width: 0, height: 0)
        
    }
 
}


