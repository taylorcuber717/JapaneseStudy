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
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(handleToggleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings_icon").withTintColor(.white), style: .plain, target: self, action: #selector(moveToSettings))
    }
 
}


