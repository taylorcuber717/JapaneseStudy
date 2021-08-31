//
//  SettingsController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

private var reuseIdentifier = "SettingsCell"

class SettingsController: UIViewController {
    
    //MARK: - Properties:
    
    var tableView: UITableView!
    //var delegate: SettingsControllerDelegate!
    
    //MARK: - Init:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNavigationBar()
        
    }
    
    //MARK: - Hanlders:
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .red
        navigationItem.title = "Settings"
//        let leftMenuItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onBack))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onBack))
        
    }
    
    @objc private func onBack() {
        print("this is running")
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Study: return SettingsStudyOptions.allCases.count
        case .Quiz: return SettingsQuizOptions.allCases.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Study:
            let study = SettingsStudyOptions(rawValue: indexPath.row)
            cell.settingsSectionType = study
        case .Quiz:
            let quiz = SettingsQuizOptions(rawValue: indexPath.row)
            cell.settingsSectionType = quiz
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Study: print(SettingsStudyOptions(rawValue: indexPath.row)?.description)
        case .Quiz: print(SettingsQuizOptions(rawValue: indexPath.row)?.description)
        }
    }
}
