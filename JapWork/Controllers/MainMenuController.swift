//
//  MainMenuController.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller creates the menu that navigates to the study and quiz controllers with the appropriate data.
//  Most of the functionality lies within the didSelect function within the container controller.
//

import UIKit

protocol MenuControllerDelegate: AnyObject {
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
        view.backgroundColor = .black
    }
    
    //MARK: - Handlers
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.backgroundColor = .black
        
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 0, height: 0)
        view.backgroundColor = .black
        tableView.backgroundColor = .black
    }
    
    // setup style of navigation bar
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .red
    }
    
}

extension MainMenuController: UITableViewDelegate, UITableViewDataSource {
    
    // These functions all use the enumerators in the Model files to populate the cells
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .red
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = .white
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
            if indexPath.row == 2 { // if studylist
                guard let studyOption = StudyOptions(rawValue: indexPath.row) else { return }
                let shouldExpand = studyOption.hasExpandArrow
                delegate?.didSelect(forMenuOption: studyOption, forShouldExpand: shouldExpand)
            } else {
                guard let studyOption = StudyOptions(rawValue: indexPath.row) else { return }
                let shouldExpand = studyOption.hasExpandArrow
                delegate?.didSelect(forMenuOption: studyOption, forShouldExpand: shouldExpand)
                pushToStudyController(studyOption: studyOption)
            }
        case .Quiz:
            guard let quizOption = QuizOptions(rawValue: indexPath.row) else { return }
            let shouldExpand = quizOption.hasExpandArrow
            if indexPath.row == 2 { // if daily quiz
                delegate?.didSelect(forMenuOption: quizOption, forShouldExpand: shouldExpand)
            } else if indexPath.row == 3 { // if studylist quiz
                delegate?.didSelect(forMenuOption: quizOption, forShouldExpand: shouldExpand)
            } else {
                delegate?.didSelect(forMenuOption: quizOption, forShouldExpand: shouldExpand)
                pushToQuizController(quizOption: quizOption)
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    /**
     The study list case will never run, it is required since it is an option in the enum, but unilke vocab and kanji selectors it does not
     open a second window to the select the chapter, thus it only needs to call didSelect in the didSelectRowAt function
     */
    private func pushToStudyController(studyOption: StudyOptions) {
        
        switch studyOption {
        case .vocab:
            let vocabularyStudyMenuController = VocabularyStudyMenuController()
            vocabularyStudyMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(vocabularyStudyMenuController, animated: true)
        case .kanji:
            let kanjiStudyMenuController = KanjiStudyMenuController()
            kanjiStudyMenuController.delegate = self.delegate
            self.navigationController?.pushViewController(kanjiStudyMenuController, animated: true)
        case .studyList:
            print("Warning: MainMenuController.pushToStudyController() .studyList case ran and it should not run")
        }
    }
    
    /**
     The daily and study list cases will never run, they are required since they are options in the enum, but unilke vocab and kanji
     selectors they do not open a second window to the select the chapter, thus they only need to call did select in the didSelectRowAt
     function
     */
    private func pushToQuizController(quizOption: QuizOptions) {
        
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
            print("Warning: MainMenuController.pushToQuizController() .daily case ran and it should not run")
        case .studyList:
            print("Warning: MainMenuController.pushToQuizController() .studyList case ran and it should not run")
        }
        
    }
    
}
