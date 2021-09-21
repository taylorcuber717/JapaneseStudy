//
//  ContainerController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/2/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller holds the home controller and menu controller.  The home controller is in front of the
//  controller and will be moved aside when the menu controller is activated.  This class also handles the "didSelect"
//  function, which handles the selections of rows in the menu controller.  This involes either opening the kanji and
//  vocabulary menus, or opening the study or quiz controller with the appropriate data.
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
        setupDefaultValues()
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
    
    /**
     Create the home controller then set it as the root controller of the center controller
     */
    private func configureHomeController() {
        let homeController = HomeController()
        homeController.view.backgroundColor = .black
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
                
        view.addSubview(centerController.view)
        addChild(centerController)
        
        centerController.didMove(toParent: self)
        
    }
    
    /**
     This function creates the menu controller and adds it to the navigation controller, it only does so if the menu controller has not been created yet
     (this is the first time the menu has been accessed)
     */
    private func configureMenuNavController() {
        if menuController == nil {
            // Add menu controller here
            menuController = MainMenuController()
            let menuNavController = UINavigationController(rootViewController: menuController)
            menuController.delegate = self
            view.insertSubview(menuNavController.view, at: 0)
            addChild(menuNavController)
            menuController.didMove(toParent: self)
        }
    }
    
    /**
     @parameter: shouldExpand - A boolean, if true then move the center view to the side to show the menu view behind it with an animation, if false, move the center view back
     @parameter: menuOption - the menu option that was selected
     Moves the center view, if moving it back, then call didSelectMenuOption to handle the selection.
     */
    private func animatePanel(shouldExpand: Bool, menuOption: MenuOption?) {
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
                    self.didSelectMenuOption(menuOption: menuOption)
                }
            }
        }
        
        animateStatusBar()
    }
    
    /**
     @parameter: menuOption - the menu option (row of the menu table view) that was selected
     Handle the selection of the menu options: kanji study, vocab study, studyList study, kanji quiz, vocab quiz,
     daily quiz, and studyList quiz.  These all relate to populating the study or quiz controller with the correct
     data, for the daily quiz and studyList this is more complicated.
     */
    func didSelectMenuOption(menuOption: MenuOption) {
        // Identify which menu table view was used
        switch menuOption.identifier {
        case "VocabularyStudyMenuOption":
            // Handle selecting rows in vocabulary study menu table view
            let vocabOptions = menuOption as! VocabStudyOptions
            let defaults = UserDefaults.standard
            switch vocabOptions {
            case .chapter2:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter2AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter2MainVocab, type: "Vocab")
                }
            case .chapter3:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter3AllVocab, type: "Vocab")
            case .chapter4:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter4AllVocab, type: "Vocab")
            case .chapter5:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter5AllVocab, type: "Vocab")
            case .chapter6:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter6AllVocab, type: "Vocab")
            case .chapter7:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter7AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter7MainVocab, type: "Vocab")
                }
            case .chapter8:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter8AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter8MainVocab, type: "Vocab")
                }
            case .chapter9:
                moveToStudyController(studyObjects: WordKanjiDatabase().chapter9AllVocab, type: "Vocab")
            case .chapter10:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter10AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter10MainVocab, type: "Vocab")
                }
            case .chapter11:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter11AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter11MainVocab, type: "Vocab")
                }
            case .chapter12:
                if defaults.bool(forKey: "studySupVocab") {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter12AllVocab, type: "Vocab")
                } else {
                    moveToStudyController(studyObjects: WordKanjiDatabase().chapter12MainVocab, type: "Vocab")
                }
            }
        case "KanjiStudyMenuOption":
            // Handle selecting rows in kanji study menu table view
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
            prepareStudyList()
            
        case "VocabularyQuizMenuOption":
            // Handle selecting rows in vocabulary quiz menu table view
            let vocabOptions = menuOption as! VocabQuizOptions
            let defaults = UserDefaults.standard
            switch vocabOptions {
            case .chapter2:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter2AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter2MainVocab, type: "Vocab")
                }
            case .chapter3:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter3AllVocab, type: "Vocab")
            case .chapter4:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter4AllVocab, type: "Vocab")
            case .chapter5:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter5AllVocab, type: "Vocab")
            case .chapter6:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter6AllVocab, type: "Vocab")
            case .chapter7:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter7AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter7MainVocab, type: "Vocab")
                }
            case .chapter8:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter8AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter8MainVocab, type: "Vocab")
                }
            case .chapter9:
                moveToQuizController(quizObjects: WordKanjiDatabase().chapter9AllVocab, type: "Vocab")
            case .chapter10:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter10AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter10MainVocab, type: "Vocab")
                }
            case .chapter11:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter11AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter11MainVocab, type: "Vocab")
                }
            case .chapter12:
                if defaults.bool(forKey: "quizSupVocab") {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter12AllVocab, type: "Vocab")
                } else {
                    moveToQuizController(quizObjects: WordKanjiDatabase().chapter12MainVocab, type: "Vocab")
                }
            }
        case "KanjiQuizMenuOption":
            // Handle selecting rows in kanji quiz menu table view
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
            prepareDailyQuiz()
            
        case "StudyListQuizMenuOption":
            prepareStudyListQuiz()
            
        default:
            print("Error: ContainerController.didSelectMenuOption() Unknown identifier")
            print(menuOption.identifier)
        }
    }
    
    /**
     @parameter: quizObjects - the list of kanji or vocab that populate the quiz controller
     @parameter: type - the type of list (Kanji, Vocab, DailyQuiz, StudyList, etc.)
     Segue to the studyController
     */
    private func moveToStudyController(studyObjects: [StudyObject], type: String) {
        let controller = StudyController()
        controller.delegate = self
        controller.wordKanjiInfo = studyObjects
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
    
    
    /**
     @parameter: quizObjects - the list of kanji or vocab that populate the quiz controller
     @parameter: type - the type of list (Kanji, Vocab, DailyQuiz, StudyList, etc.) currently only used to set the quizController to studylist
     Segue to the quizController
     */
    private func moveToQuizController(quizObjects: [StudyObject], type: String) {
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
    
    
    /**
     Animate the movement of the status bar moving, so that it moves with the main screen (always called from animatePanel)
     */
    private func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    
    /**
     Set defaults values for each of the settings, whose values will be saved locally
     */
    private func setupDefaultValues() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "studySupVocab") == nil {
            defaults.setValue(true, forKey: "studySupVocab")
        }
        if defaults.object(forKey: "quizSupVocab") == nil {
            defaults.setValue(true, forKey: "quizSupVocab")
        }
        if defaults.object(forKey: "randomizeQuizOrder") == nil {
            defaults.setValue(true, forKey: "randomizeQuizOrder")
        }
        if defaults.object(forKey: "includeKanjiDaily") == nil {
            defaults.setValue(true, forKey: "includeKanjiDaily")
        }
        if defaults.object(forKey: "includeVocabDaily") == nil {
            defaults.setValue(true, forKey: "includeVocabDaily")
        }
    }
    
    
    /**
     To create a random daily quiz, I save four different random quizzes for the permutation of potential settings, kanji and vocab,
     just kanji, just vocab, and vocab without supplementary vocab.  I also save the most recent date the quiz was accessed.
     When a user opens the daily quiz I check if the current is equal to the most recently accessed date, if it is then I get the locally
     saved quiz, if it isn't then I create four new random quizzes and save them locally as well as updating the most recently accessed
     date.  Once I have the correct quiz I move to the quiz controller with that quiz.
     */
    private func prepareDailyQuiz() {
        var totalRandomNumList: [Int] = []
        var i = 0
        while i < 50 {
            let randomNum = Int.random(in: 0..<WordKanjiDatabase().allStudyObjects.count)
            if !totalRandomNumList.contains(randomNum) {
                totalRandomNumList.append(randomNum)
                i += 1
            }
        }
        
        var kanjiRandomNumList: [Int] = []
        i = 0
        while i < 50 {
            let randomNum = Int.random(in: 0..<WordKanjiDatabase().allKanji.count)
            if !kanjiRandomNumList.contains(randomNum) {
                kanjiRandomNumList.append(randomNum)
                i += 1
            }
        }
        
        var vocabRandomNumList: [Int] = []
        i = 0
        while i < 50 {
            let randomNum = Int.random(in: 0..<WordKanjiDatabase().allVocab.count)
            if !vocabRandomNumList.contains(randomNum) {
                vocabRandomNumList.append(randomNum)
                i += 1
            }
        }
        
        var mainVocabRandomNumList: [Int] = []
        i = 0
        while i < 50 {
            let randomNum = Int.random(in: 0..<WordKanjiDatabase().allMainVocab.count)
            if !mainVocabRandomNumList.contains(randomNum) {
                mainVocabRandomNumList.append(randomNum)
                i += 1
            }
        }
        
        var dailyQuizDatabase: [StudyObject] = []
        var randomNumList: [Int] = []
        var randomNumListKey = ""
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "includeKanjiDaily") && defaults.bool(forKey: "includeVocabDaily") {
            dailyQuizDatabase = WordKanjiDatabase().allStudyObjects
            randomNumList = totalRandomNumList
            randomNumListKey = "totalQuizList"
        } else if defaults.bool(forKey: "includeKanjiDaily") {
            dailyQuizDatabase = WordKanjiDatabase().allKanji
            randomNumList = kanjiRandomNumList
            randomNumListKey = "kanjiQuizList"
        } else if defaults.bool(forKey: "includeVocabDaily") {
            if defaults.bool(forKey: "quizSupVocab") {
                dailyQuizDatabase = WordKanjiDatabase().allVocab
                randomNumList = vocabRandomNumList
                randomNumListKey = "vocabQuizList"
            } else {
                dailyQuizDatabase = WordKanjiDatabase().allMainVocab
                randomNumList = mainVocabRandomNumList
                randomNumListKey = "mainVocabQuizList"
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "You don't have vocab or kanji included in the daily quiz, please include at least one to take the quiz", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = .red
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d YYYY"
        let date = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        
        if formatter.string(from: date) == defaults.string(forKey: "mostRecentQuizDay") {
            randomNumList = defaults.array(forKey: randomNumListKey) as! [Int]
        } else {
            defaults.setValue(formatter.string(from: date), forKey: "mostRecentQuizDay")
            defaults.setValue(totalRandomNumList, forKey: "totalQuizList")
            defaults.setValue(kanjiRandomNumList, forKey: "kanjiQuizList")
            defaults.setValue(vocabRandomNumList, forKey: "vocabQuizList")
            defaults.setValue(mainVocabRandomNumList, forKey: "mainVocabQuizList")
        }
        
        var quizObjects: [StudyObject] = []
        
        // Since the "Supplementary Start" is in the WordKanjiDatabase, remove any in the quiz
        for num in randomNumList {
            if dailyQuizDatabase[num].object != "Supplementary Start" {
                quizObjects.append(dailyQuizDatabase[num])
            }
        }
        
        moveToQuizController(quizObjects: quizObjects, type: "DailyQuiz")
    }
    
    /**
     Retrieve the user's study list from Firebase, then for object from Firebase convert it into either a Kanji ro Vocab object,
     add those objects to a list and segue to the study controller with that list
     */
    private func prepareStudyList() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var studyObjects: [StudyObject] = []
        StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
            var i = 0
            for case let child as DataSnapshot in dataSnapshot.children {
                let snapshotData = child.value as! [String: Any]
                if snapshotData["type"] as! String == "Kanji" {
                    guard let kanjiMeaning = snapshotData["kanjiMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyList() problem with kanjiMeaning")
                        return
                    }
                    guard let imaMeaning = snapshotData["imaMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyList() problem with kanjiImaMeaning")
                        return
                    }
                    guard let kunMeaning = snapshotData["kunMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyList() problem with kunMeaning")
                        return
                    }
                    guard let onMeaning = snapshotData["onMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyList() problem with onMeaning")
                        return
                    }
                    let kanji = Kanji(identifier: "Kanji", objectText: kanjiMeaning, imaAnswer: imaMeaning, kunAnswer: kunMeaning, onAnswer: onMeaning)
                    studyObjects.append(kanji)
                } else {
                    guard let vocabMeaning = snapshotData["vocabMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyList() problem with vocabMeaning")
                        return
                    }
                    guard let imaMeaning = snapshotData["imaMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyList() problem with vocabImaMeaning")
                        return
                    }
                    guard let extraInfo = snapshotData["extraInfo"] as? String else {
                        print("Error: ContainerController.prepareStudyList() problem with extraInfo")
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
    }
    
    /**
     Retrieve the user's study list from Firebase, then for object from Firebase convert it into either a Kanji ro Vocab object,
     add those objects to a list and segue to the quiz controller with that list
     */
    private func prepareStudyListQuiz() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var studyObjects: [StudyObject] = []
        StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
            var i = 0
            for case let child as DataSnapshot in dataSnapshot.children {
                let snapshotData = child.value as! [String: Any]
                if snapshotData["type"] as! String == "Kanji" {
                    guard let kanjiMeaning = snapshotData["kanjiMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with kanjiMeaning")
                        return
                    }
                    guard let imaMeaning = snapshotData["imaMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with kanjiImaMeaning")
                        return
                    }
                    guard let kunMeaning = snapshotData["kunMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with kunMeaning")
                        return
                    }
                    guard let onMeaning = snapshotData["onMeaning"] as? [String] else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with onMeaning")
                        return
                    }
                    let kanji = Kanji(identifier: "Kanji", objectText: kanjiMeaning, imaAnswer: imaMeaning, kunAnswer: kunMeaning, onAnswer: onMeaning)
                    studyObjects.append(kanji)
                } else {
                    guard let vocabMeaning = snapshotData["vocabMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with vocabMeaning")
                        return
                    }
                    guard let imaMeaning = snapshotData["imaMeaning"] as? String else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with vocabImaMeaning")
                        return
                    }
                    guard let extraInfo = snapshotData["extraInfo"] as? String else {
                        print("Error: ContainerController.prepareStudyListQuiz() problem with extraInfo")
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
    }

}

//MARK: - HomeControllerDelegate

extension ContainerController: MainControllersDelegate {
    
    // Handle moving the home controller when a menu row is selected
    func handleMenuToggle(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool) {
        
        if !isExpanded {
            configureMenuNavController()
        }
        
        animatePanel(shouldExpand: shouldExpand, menuOption: menuOption)
    }
    
    // Sets up the navigation bar and then segues to the settingsController
    func moveToSettings() {
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        navController.navigationBar.tintColor = .red
        
        self.present(navController, animated: true, completion: nil)
    }
}

//MARK: - MenuControllerDelegate

extension ContainerController: MenuControllerDelegate {
    
    // Handle the user selecting a men row (this usually involves opening and populating the study or quiz controller)
    func didSelect(forMenuOption menuOption: MenuOption?, forShouldExpand shouldExpand: Bool) {
        if !isExpanded {
            configureMenuNavController()
        }
        
        animatePanel(shouldExpand: shouldExpand, menuOption: menuOption)
    }
}

