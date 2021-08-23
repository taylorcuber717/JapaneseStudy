//
//  ContainerController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ContainerController: UIViewController {
    
    // MARK: Properties
    
    var menuController: MainMenuController!
    var centerController: UIViewController!
    var isExpanded = false
    static let ref = Database.database().reference()
    
    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
     
    //MARK: - Handlers
    
    func configureHomeController() {
        let homeController = HomeController()
        homeController.view.backgroundColor = .green
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
                
        view.addSubview(centerController.view)
        addChild(centerController)
        
        centerController.didMove(toParent: self )
        
    }
    
    func configureMenuNavController() {
        if menuController == nil {
            // Add menu controller here
            menuController = MainMenuController()
            let menuNavController = UINavigationController(rootViewController: menuController)
            menuNavController.navigationBar.tintColor = .darkGray
            menuController.delegate = self
            view.insertSubview(menuNavController.view, at: 0)
            addChild(menuNavController)
            menuController.didMove(toParent: self)
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
        if shouldExpand {
            // show view
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        } else {
            // hide view
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                if let menuOption = menuOption {
                    print("animate panel did sleect menu option")
                    self.didSelectMenuOption(menuOption: menuOption)
                }
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        // Identify which menu table view was used
        print(menuOption.identifier)
        switch menuOption.identifier {
        case "StudyOption":
            // Handle selecting rows in main menu table view
            let studyOptions = menuOption as! StudyOptions
            switch studyOptions {
            case .vocab:
                print("show vocabulary")
            case .kanji:
                print("show kanji")
            case .studyList:
                print("show study list")
            }
        case "QuizOption":
            let quizOptions = menuOption as! QuizOptions
            switch quizOptions {
            case .vocab:
                print("quiz vocab")
            case .kanji:
                print("quiz kanji")
            case .daily:
                print("quiz daily")
            case .studyList:
                print("quiz study list")
            }
        case "VocabularyStudyMenuOption":
            // Handle selecting rows in vocabulary menu table view
            //let vocabOptions = menuOption as! VocabOptions
            let vocabOptions = menuOption as! VocabStudyOptions
            //let vocabularyMenuOption = menuOption as! VocabularyMenuOption
            switch vocabOptions {
            case .chapter2:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter2AllVocab, type: "Vocab")
            case .chapter3:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter3AllVocab, type: "Vocab")
            case .chapter4:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter4AllVocab, type: "Vocab")
            case .chapter5:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter5AllVocab, type: "Vocab")
            case .chapter6:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter6AllVocab, type: "Vocab")
            case .chapter7:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter7AllVocab, type: "Vocab")
            case .chapter8:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter8AllVocab, type: "Vocab")
            case .chapter9:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter9AllVocab, type: "Vocab")
            case .chapter10:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter10AllVocab, type: "Vocab")
            case .chapter11:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter11AllVocab, type: "Vocab")
            case .chapter12:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter12AllVocab, type: "Vocab")
            }
        case "KanjiStudyMenuOption":
            // Handle selecting rows in vocabulary menu table view
            let kanjiOptions = menuOption as! KanjiStudyOptions
            switch kanjiOptions {
            case .chapter4:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter4Kanji, type: "Kanji")
            case .chapter5:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter5Kanji, type: "Kanji")
            case .chapter6:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter6Kanji, type: "Kanji")
            case .chapter7:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter7Kanji, type: "Kanji")
            case .chapter8:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter8Kanji, type: "Kanji")
            case .chapter9:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter9Kanji, type: "Kanji")
            case .chapter10:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter10Kanji, type: "Kanji")
            case .chapter11:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter11Kanji, type: "Kanji")
            case .chapter12:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter12Kanji, type: "Kanji")
            }
        case "StudyListStudyMenuOption":
            print("here is happening")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var studyObjects: [StudyObject] = []
            StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                var i = 0
                for case let child as DataSnapshot in dataSnapshot.children {
                    let snapshotData = child.value as! [String: Any]
                    if snapshotData["type"] as! String == "Kanji" {
                        guard let kanjiMeaning = snapshotData["kanjiMeaning"] as? String else {
                            print("error with kanjiMeaning")
                            return
                        }
                        guard let imaMeaning = snapshotData["imaMeaning"] as? [String] else {
                            print("error with imaMeaning")
                            return
                        }
                        guard let kunMeaning = snapshotData["kunMeaning"] as? [String] else {
                            print("error with kunMeaning")
                            return
                        }
                        guard let onMeaning = snapshotData["onMeaning"] as? [String] else {
                            print("error with onMeaning")
                            return
                        }
                        let kanji = Kanji(identifier: "Kanji", objectText: kanjiMeaning, imaAnswer: imaMeaning, kunAnswer: kunMeaning, onAnswer: onMeaning)
                        studyObjects.append(kanji)
                    } else {
                        guard let vocabMeaning = snapshotData["vocabMeaning"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        guard let imaMeaning = snapshotData["imaMeaning"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        guard let extraInfo = snapshotData["extraInfo"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        let word = Word(identifier: "Vocab", objectText: vocabMeaning, imaAnswer: imaMeaning, extraInfo: extraInfo)
                        studyObjects.append(word)
                    }
                    if i == dataSnapshot.childrenCount - 1 {
                        self.moveToStudyController(studyObjects: studyObjects, type: "StudyList")
                    }
                    i += 1
                }
            }
        case "VocabularyQuizMenuOption":
            let vocabOptions = menuOption as! VocabQuizOptions
            //let vocabularyMenuOption = menuOption as! VocabularyMenuOption
            switch vocabOptions {
            case .chapter2:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter2AllVocab, type: "Vocab")
            case .chapter3:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter3AllVocab, type: "Vocab")
            case .chapter4:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter4AllVocab, type: "Vocab")
            case .chapter5:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter5AllVocab, type: "Vocab")
            case .chapter6:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter6AllVocab, type: "Vocab")
            case .chapter7:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter7AllVocab, type: "Vocab")
            case .chapter8:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter8AllVocab, type: "Vocab")
            case .chapter9:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter9AllVocab, type: "Vocab")
            case .chapter10:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter10AllVocab, type: "Vocab")
            case .chapter11:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter11AllVocab, type: "Vocab")
            case .chapter12:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter12AllVocab, type: "Vocab")
            }
        case "KanjiQuizMenuOption":
            // Handle selecting rows in vocabulary menu table view
            let kanjiOptions = menuOption as! KanjiQuizOptions
            switch kanjiOptions {
            case .chapter4:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter4Kanji, type: "Kanji")
            case .chapter5:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter5Kanji, type: "Kanji")
            case .chapter6:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter6Kanji, type: "Kanji")
            case .chapter7:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter7Kanji, type: "Kanji")
            case .chapter8:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter8Kanji, type: "Kanji")
            case .chapter9:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter9Kanji, type: "Kanji")
            case .chapter10:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter10Kanji, type: "Kanji")
            case .chapter11:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter11Kanji, type: "Kanji")
            case .chapter12:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter12Kanji, type: "Kanji")
            }
        case "DailyQuizMenuOption":
            print("handle daily menu option")
        case "StudyListQuizMenuOption":
            guard let uid = Auth.auth().currentUser?.uid else { return }
            var studyObjects: [StudyObject] = []
            StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                var i = 0
                for case let child as DataSnapshot in dataSnapshot.children {
                    let snapshotData = child.value as! [String: Any]
                    if snapshotData["type"] as! String == "Kanji" {
                        guard let kanjiMeaning = snapshotData["kanjiMeaning"] as? String else {
                            print("error with kanjiMeaning")
                            return
                        }
                        guard let imaMeaning = snapshotData["imaMeaning"] as? [String] else {
                            print("error with imaMeaning")
                            return
                        }
                        guard let kunMeaning = snapshotData["kunMeaning"] as? [String] else {
                            print("error with kunMeaning")
                            return
                        }
                        guard let onMeaning = snapshotData["onMeaning"] as? [String] else {
                            print("error with onMeaning")
                            return
                        }
                        let kanji = Kanji(identifier: "Kanji", objectText: kanjiMeaning, imaAnswer: imaMeaning, kunAnswer: kunMeaning, onAnswer: onMeaning)
                        studyObjects.append(kanji)
                    } else {
                        guard let vocabMeaning = snapshotData["vocabMeaning"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        guard let imaMeaning = snapshotData["imaMeaning"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        guard let extraInfo = snapshotData["extraInfo"] as? String else {
                            print("error with vocabMeaning")
                            return
                        }
                        let word = Word(identifier: "Vocab", objectText: vocabMeaning, imaAnswer: imaMeaning, extraInfo: extraInfo)
                        studyObjects.append(word)
                    }
                    if i == dataSnapshot.childrenCount - 1 {
                        self.moveToQuizController(quizObjects: studyObjects, type: "StudyList")
                    }
                    i += 1
                }
            }
        default:
            print("Unknown identifier")
            print(menuOption.identifier)
        }
    }
    
    func moveToStudyController(studyObjects: [StudyObject], type: String) {
        let controller = StudyController()
        controller.delegate = self
        controller.wordKanjiInfo = studyObjects
        
        
        centerController.willMove(toParent: nil)
        centerController.view.removeFromSuperview()
        centerController.removeFromParent()
        centerController = UINavigationController(rootViewController: controller)
                
        view.addSubview(centerController.view)
        addChild(centerController)
        
        centerController.didMove(toParent: self)
    }
    
    func moveToQuizController(quizObjects: [StudyObject], type: String) {
        let controller = QuizController()
        controller.delegate = self
        controller.wordKanjiInfo = quizObjects
        if type == "StudyList" {
            controller.isStudyList = true
        }
        
        centerController.willMove(toParent: nil)
        centerController.view.removeFromSuperview()
        centerController.removeFromParent()
        centerController = UINavigationController(rootViewController: controller)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        
        centerController.didMove(toParent: self)
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    

}

//MARK: - HomeControllerDelegate

extension ContainerController: MainControllersDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool) {
        
        if !isExpanded {
            configureMenuNavController()
        }
        
        animatePanel(shouldExpand: shouldExpand, menuOption: menuOption)
    }
    
    func moveToSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
}

//MARK: - MenuControllerDelegate

extension ContainerController: MenuControllerDelegate {
    func didSelect(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool) {
        if !isExpanded {
            configureMenuNavController()
        }
        
        animatePanel(shouldExpand: shouldExpand, menuOption: menuOption)
    }
}

