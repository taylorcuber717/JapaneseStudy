//
//  VocabularyMenuController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/7/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "VocabularyMenuOptionCell"

class VocabularyStudyMenuController: UIViewController {
    
    //MARK: - Properties
    
    var tableView: UITableView!
    var delegate: MenuControllerDelegate?
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    //MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .darkGray
        
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "Vocabulary"
    }
    
}

extension VocabularyStudyMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let vocabularyMenuOption = VocabularyMenuOption(startingRow: indexPath.row)
        
        cell.descriptionLabel.text = vocabularyMenuOption.description
        cell.iconImageView.image = vocabularyMenuOption.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vocabularyMenuOption = VocabularyMenuOption(startingRow: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        // If the mainMenuOption's expandImage is not empty then homeview should not return
        let shouldExpand = vocabularyMenuOption.expandImage == #imageLiteral(resourceName: "expand_arrow_icon").withTintColor(.white)
        delegate?.didSelect(forMenuOption: vocabularyMenuOption, forShouldExpand: shouldExpand)
    }
    
}

