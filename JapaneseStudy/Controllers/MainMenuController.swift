//
//  MainMenuController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

protocol MenuControllerDelegate: class {
    func didSelect(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool)
}

private let reuseIdentifier = "MainMenuOptionCell"

class MainMenuController: UIViewController {
    
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
    }
    
}

extension MainMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MainMenuSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = MainMenuSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Study: return StudyOptions.allCases.count
        case .Quiz: return QuizOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        guard let mainMenuSection = MainMenuSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch mainMenuSection {
        case .Study:
            let study = StudyOptions(rawValue: indexPath.row)
            cell.menuOption = study
        case .Quiz:
            let quiz = QuizOptions(rawValue: indexPath.row)
            cell.menuOption = quiz
        }
        
//        let mainMenuOption = MainMenuOption(startingRow: indexPath.row)
//        
//        cell.descriptionLabel.text = mainMenuOption.description
//        cell.iconImageView.image = mainMenuOption.image
//        cell.expandArrowImageView.image = mainMenuOption.expandImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .gray
        title.text = MainMenuSection(rawValue: section)?.description
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let mainMenuSection = MainMenuSection(rawValue: indexPath.section) else { return }
        
        switch mainMenuSection {
        case .Study:
            guard let studyOption = StudyOptions(rawValue: indexPath.row) else { return }
            let shouldExpand = studyOption.hasExpandArrow
            delegate?.didSelect(forMenuOption: studyOption, forShouldExpand: shouldExpand)
            pushToStudyController(studyOption: studyOption)
        case .Quiz:
            guard let quizOption = QuizOptions(rawValue: indexPath.row) else { return }
            let shouldExpand = quizOption.hasExpandArrow
            delegate?.didSelect(forMenuOption: quizOption, forShouldExpand: shouldExpand)
            pushToQuizController(quizOption: quizOption)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        // If the mainMenuOption's expandImage is not empty then homeview should not return
        
        
        // If shoudldExpand = false then a new view controller should be presented in this nav controller
        
        
    }
    
    func pushToStudyController(studyOption: StudyOptions) {
        
        switch studyOption {
        case .vocab:
            let vocabularyStudyMenuController = VocabularyStudyMenuController()
            vocabularyStudyMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(vocabularyStudyMenuController, animated: true)
        case .kanji:
            let kanjiStudyMenuController = KanjiStudyMenuController()
            kanjiStudyMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(kanjiStudyMenuController, animated: true)
        }
    }
    
    func pushToQuizController(quizOption: QuizOptions) {
        
        switch quizOption {
        case .vocab:
            let vocabularyQuizMenuController = VocabularyQuizMenuController()
            vocabularyQuizMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(vocabularyQuizMenuController, animated: true)
        case .kanji:
            let kanjiQuizMenuController = KanjiQuizMenuController()
            kanjiQuizMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(kanjiQuizMenuController, animated: true)
        case .daily:
            let vocabularyQuizMenuController = VocabularyQuizMenuController()
            vocabularyQuizMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(vocabularyQuizMenuController, animated: true)
        case .studyList:
            let kanjiQuizMenuController = KanjiQuizMenuController()
            kanjiQuizMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(kanjiQuizMenuController, animated: true)
        }
        
    }
    
}
