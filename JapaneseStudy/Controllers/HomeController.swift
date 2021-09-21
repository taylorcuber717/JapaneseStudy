//
//  ViewController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/1/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: main page of this view controller doesn't hold any functionality, just welcomes the user.  The navigation bar is how
//  the user navigates to the menu and the settings page
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
    
    // Use this so that they user can go back to the home controller without selecting anyting on the menu
    private func setupGestureRecognizers() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func closeMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: false)
    }
    
    @objc private func handleToggleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: true)
    }
    
    @objc private func moveToSettings() {
        delegate?.moveToSettings()
    }
    
    /**
     This function creates the menu, settings, and home button in the navigation bar and sets up the style of the navigation bar
     */
    private func configureNavigationBar() {
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
    
    private func setupConstraints() {
        
        view.addSubview(japWorkIconImageView)
        japWorkIconImageView.translatesAutoresizingMaskIntoConstraints = false
        japWorkIconImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, centerX: view.centerXAnchor, centerY: nil, paddingTop: 175, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 300, height: 300)
        
        view.addSubview(japWorkLabel)
        japWorkLabel.translatesAutoresizingMaskIntoConstraints = false
        japWorkLabel.anchor(top: japWorkIconImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingRight: -25, paddingBottom: 0, width: 0, height: 0)
        
    }
 
}


