//
//  SettingsController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/19/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller holds the settings that the user can modify to customize their experience.
//  This includes having supplementary vocabulary in the study controller, whether to include vocab, kanji, or
//  both in the daily quizzes, and whether to randomize quizzes.  Also where a user logs out and has Icons8 info
//

import UIKit
import Firebase

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
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.rowHeight = 50
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        tableView.isScrollEnabled = false
        
    }
    
    // UI and back button
    private func configureNavigationBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .red
        navigationItem.title = "Settings"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onBack))
        
    }
    
    @objc private func onBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// The table view is constructed using the SettingsSections enumerator
extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Study: return SettingsStudyOptions.allCases.count
        case .Quiz: return SettingsQuizOptions.allCases.count
        case .Account: return SettingsAccountOptions.allCases.count
        case .Icons8: return SettingsIcons8Options.allCases.count
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
        cell.selectionStyle = .none
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Study:
            let study = SettingsStudyOptions(rawValue: indexPath.row)
            cell.settingsSectionType = study
        case .Quiz:
            let quiz = SettingsQuizOptions(rawValue: indexPath.row)
            cell.settingsSectionType = quiz
        case .Account:
            let account = SettingsAccountOptions(rawValue: indexPath.row)
            cell.settingsSectionType = account
        case .Icons8:
            let icons8 = SettingsIcons8Options(rawValue: indexPath.row)
            cell.settingsSectionType = icons8
        }
        
        return cell
        
    }
    
    // The settings cells will generally either save a setting in User Defaults or do nothing.
    // The exception being icons link cell which opens a link to the Icon8 homepage
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Study:
            guard let studyOption = SettingsStudyOptions(rawValue: indexPath.row) else { return }
            let defaults = UserDefaults.standard
            switch studyOption.identifier {
            case "studySupVocab":
                let currentValue = defaults.bool(forKey: "studySupVocab")
                defaults.setValue(!currentValue, forKey: "studySupVocab")
            case "includeKanjiDaily":
                let currentValue = defaults.bool(forKey: "includeKanjiDaily")
                defaults.setValue(!currentValue, forKey: "includeKanjiDaily")
            case "includeVocabDaily":
                let currentValue = defaults.bool(forKey: "includeVocabDaily")
                defaults.setValue(!currentValue, forKey: "includeVocabDaily")
            default:
                print("Error: SettingsController.didSelectRowAt bad value for studyOption identifier")
            }
        case .Quiz:
            guard let quizOption = SettingsQuizOptions(rawValue: indexPath.row) else { return }
            let defaults = UserDefaults.standard
            switch quizOption.identifier {
            case "quizSupVocab":
                let currentValue = defaults.bool(forKey: "quizSupVocab")
                defaults.setValue(!currentValue, forKey: "quizSupVocab")
            case "randomizeQuizOrder":
                let currentValue = defaults.bool(forKey: "randomizeQuizOrder")
                defaults.setValue(!currentValue, forKey: "randomizeQuizOrder")
            default:
                print("Error: SettingsController.didSelectRowAt bad value for quizOption identifier")
            }
        case .Account:
            guard let accountOption = SettingsAccountOptions(rawValue: indexPath.row) else { return }
            if accountOption.identifier == "logOut" {
                
                do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                  print("Error: SettingsController.didSelelectRowAt signing out: %@", signOutError)
                }
                
                let landingPageController = LandingPageController()
                landingPageController.modalPresentationStyle = .fullScreen
                self.present(landingPageController, animated: true, completion: nil)
                
            }
        case .Icons8:
            guard let accountOption = SettingsIcons8Options(rawValue: indexPath.row) else { return }
            if accountOption.identifier == "iconsLink" {
                if let url = URL(string: "https://icons8.com") {
                    UIApplication.shared.open(url)
                }
            }
        }
        tableView.reloadData()
    }
}
