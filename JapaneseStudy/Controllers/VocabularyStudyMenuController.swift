//
//  VocabularyMenuController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/7/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller creates a table view that holds each of the vocabulary chapters and will open either the
//  study controller when one is selected
//

import UIKit

private let reuseIdentifier = "VocabularyStudyMenuOptionCell"

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
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .darkGray
        
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.title = "Vocabulary"
    }
    
}

extension VocabularyStudyMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VocabStudyOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let vocabStudyOption = VocabStudyOptions(rawValue: indexPath.row)
        cell.menuOption = vocabStudyOption
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vocabStudyOption = VocabStudyOptions(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        // If the vocabStudyOption has an expand arrow then shouldExpand
        let shouldExpand = vocabStudyOption.hasExpandArrow
        delegate?.didSelect(forMenuOption: vocabStudyOption, forShouldExpand: shouldExpand)
    }
    
}

