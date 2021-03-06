//
//  KanjiMenuController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/9/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "KanjiStudyMenuOptionCell"

class KanjiStudyMenuController: UIViewController {
    
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
        
        navigationItem.title = "Kanji"
    }
    
}

extension KanjiStudyMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KanjiStudyOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let kanjiStudyOption = KanjiStudyOptions(rawValue: indexPath.row)
        cell.menuOption = kanjiStudyOption
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let kanjiStudyOption = KanjiStudyOptions(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        // If the kanjiStudyOption has an expand arrow then shouldExpand
        let shouldExpand = kanjiStudyOption.hasExpandArrow
        delegate?.didSelect(forMenuOption: kanjiStudyOption, forShouldExpand: shouldExpand)
    }
    
}
