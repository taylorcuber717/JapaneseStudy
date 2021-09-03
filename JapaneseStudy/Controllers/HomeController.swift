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
    
    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        setupGestureRecognizers()
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
 
}


