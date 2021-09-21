//
//  StudyController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/9/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller presents either a Kanji or Vocab object to the user.  The user can go to the next study object, the previous,
//  select a particular one via the UpcomingController, or save the study object to a personal study list.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth

class StudyController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: MainControllersDelegate?
    var wordKanjiInfo: [StudyObject]!
    static let ref = Database.database().reference()
    var isStudyList = false
    var isKanji: Bool!
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // Index to keep track of which StudyObject to use
    var studyObjectIndex = 0
    
    var displayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var displayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 150)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    var kanjiImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var kanjiImaAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var vocabImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var vocabImaAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var kunAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var kunAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = "くん: "
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var onAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var onAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = "おん: "
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var extraInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var extraInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 30)
        label.text = "Extra info: "
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    var bottomToolBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "next_icon").withTintColor(.white), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(onNextClick), for: .touchUpInside)
        return button
    }()
    
    var previousButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "previous_icon").withTintColor(.white), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(onPreviousClick), for: .touchUpInside)
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "list_icon").withTintColor(.white), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(moveToList), for: .touchUpInside)
        return button
    }()
    
    var studyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "good").withTintColor(.white), for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(addToStudyList), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        configureNavigationBar()
        setupConstraints()
        if self.isStudyList {
            setupStudyListView()
        }
        view.backgroundColor = .white
        addStart()
        changeStudyObject()
        view.setupSpinner(spinner: spinner)
        self.spinner.color = .red
        setupBorders()
        setupGestureRecognizers()
        if Auth.auth().currentUser?.uid == nil {
            makeGuestChanges()
        }
    }
    
    //MARK: - Handlers
    
    private func disableSaveButton() {
        studyButton.isEnabled = false
        //TODO: change color and stuff too
    }
    
    private func checkIfLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            disableSaveButton()
        }
    }
    
    
    // This screen has UI elements that are used for only the vocabulary view, only the kanji view, and some user in both views.
    // Setup all of them and then hide the UI elements by calling either changeToKanjiView or changeToVocabView
    private func setupConstraints() {
        
        // setup kanji view constraints
        view.addSubview(displayView)
        displayView.translatesAutoresizingMaskIntoConstraints = false
        displayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        displayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        displayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        displayView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
        
        displayView.addSubview(displayLabel)
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
        displayLabel.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true

        view.addSubview(kanjiImaAnswerView)
        kanjiImaAnswerView.translatesAutoresizingMaskIntoConstraints = false
        kanjiImaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        kanjiImaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        kanjiImaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        kanjiImaAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        kanjiImaAnswerView.addSubview(kanjiImaAnswerLabel)
        kanjiImaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        kanjiImaAnswerLabel.leftAnchor.constraint(equalTo: kanjiImaAnswerView.leftAnchor, constant: 12).isActive = true
        kanjiImaAnswerLabel.rightAnchor.constraint(equalTo: kanjiImaAnswerView.rightAnchor, constant: -12).isActive = true
        kanjiImaAnswerLabel.centerYAnchor.constraint(equalTo: kanjiImaAnswerView.centerYAnchor).isActive = true

        view.addSubview(kunAnswerView)
        kunAnswerView.translatesAutoresizingMaskIntoConstraints = false
        kunAnswerView.topAnchor.constraint(equalTo: kanjiImaAnswerView.bottomAnchor).isActive = true
        kunAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        kunAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        kunAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        kunAnswerView.addSubview(kunAnswerLabel)
        kunAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        kunAnswerLabel.leftAnchor.constraint(equalTo: kunAnswerView.leftAnchor, constant: 12).isActive = true
        kunAnswerLabel.rightAnchor.constraint(equalTo: kunAnswerView.rightAnchor, constant: -12).isActive = true
        kunAnswerLabel.centerYAnchor.constraint(equalTo: kunAnswerView.centerYAnchor).isActive = true

        view.addSubview(onAnswerView)
        onAnswerView.translatesAutoresizingMaskIntoConstraints = false
        onAnswerView.topAnchor.constraint(equalTo: kunAnswerView.bottomAnchor).isActive = true
        onAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        onAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        onAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        onAnswerView.addSubview(onAnswerLabel)
        onAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        onAnswerLabel.leftAnchor.constraint(equalTo: onAnswerView.leftAnchor, constant: 12).isActive = true
        onAnswerLabel.rightAnchor.constraint(equalTo: onAnswerView.rightAnchor, constant: -12).isActive = true
        onAnswerLabel.centerYAnchor.constraint(equalTo: onAnswerView.centerYAnchor).isActive = true
        
        setupToolBarConstraints(bottom: onAnswerView.bottomAnchor)
        
        // setup vocab view constraints
        view.addSubview(vocabImaAnswerView)
        vocabImaAnswerView.translatesAutoresizingMaskIntoConstraints = false
        vocabImaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        vocabImaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vocabImaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vocabImaAnswerView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        vocabImaAnswerView.addSubview(vocabImaAnswerLabel)
        vocabImaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        vocabImaAnswerLabel.leftAnchor.constraint(equalTo: vocabImaAnswerView.leftAnchor, constant: 12).isActive = true
        vocabImaAnswerLabel.rightAnchor.constraint(equalTo: vocabImaAnswerView.rightAnchor, constant: -12).isActive = true
        vocabImaAnswerLabel.centerYAnchor.constraint(equalTo: vocabImaAnswerView.centerYAnchor).isActive = true
        vocabImaAnswerLabel.font = UIFont(name: vocabImaAnswerLabel.font?.fontName ?? "System", size: 30)

        view.addSubview(extraInfoView)
        extraInfoView.translatesAutoresizingMaskIntoConstraints = false
        extraInfoView.topAnchor.constraint(equalTo: vocabImaAnswerView.bottomAnchor).isActive = true
        extraInfoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        extraInfoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        extraInfoView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        extraInfoView.addSubview(extraInfoLabel)
        extraInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        extraInfoLabel.leftAnchor.constraint(equalTo: extraInfoView.leftAnchor, constant: 12).isActive = true
        extraInfoLabel.rightAnchor.constraint(equalTo: extraInfoView.rightAnchor, constant: -12).isActive = true
        extraInfoLabel.centerYAnchor.constraint(equalTo: extraInfoView.centerYAnchor).isActive = true
        
        if wordKanjiInfo[0].identifier == "Kanji" {
            changeToKanjiView()
        } else if wordKanjiInfo[0].identifier == "Vocab" {
            changeToVocabView()
        }
        
    }
    
    // Hide each of the UI elements only related to the vocab view and unhide the ones related to the kanji view
    private func changeToKanjiView() {
        self.isKanji = true
        self.displayLabel.font = UIFont(name: displayLabel.font?.fontName ?? "System", size: 150)
        self.vocabImaAnswerView.isHidden = true
        self.vocabImaAnswerLabel.isHidden = true
        self.extraInfoView.isHidden = true
        self.extraInfoLabel.isHidden = true
        self.kanjiImaAnswerView.isHidden = false
        self.kanjiImaAnswerLabel.isHidden = false
        self.kunAnswerView.isHidden = false
        self.kunAnswerLabel.isHidden = false
        self.onAnswerView.isHidden = false
        self.onAnswerLabel.isHidden = false
    }
    
    // Hide each of the UI elements only related to the kanji view and unhide the ones related to the vocab view
    private func changeToVocabView() {
        self.isKanji = false
        self.displayLabel.font = UIFont(name: displayLabel.font?.fontName ?? "System", size: 45)
        self.vocabImaAnswerView.isHidden = false
        self.vocabImaAnswerLabel.isHidden = false
        self.extraInfoView.isHidden = false
        self.extraInfoLabel.isHidden = false
        self.kanjiImaAnswerView.isHidden = true
        self.kanjiImaAnswerLabel.isHidden = true
        self.kunAnswerView.isHidden = true
        self.kunAnswerLabel.isHidden = true
        self.onAnswerView.isHidden = true
        self.onAnswerLabel.isHidden = true
    }
    
    // Change the icon of the studyButton to a trash can if in data is from study list
    private func setupStudyListView() {
        self.studyButton.setImage(#imageLiteral(resourceName: "delete_icon").withTintColor(.white), for: .normal)
    }
    
    // Theis is the view at the bottom that holds the next and previous buttons, the save to study list button, and the upcoming button
    private func setupToolBarConstraints(bottom: NSLayoutYAxisAnchor) {
        view.addSubview(bottomToolBarView)
        bottomToolBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomToolBarView.topAnchor.constraint(equalTo: bottom).isActive = true
        bottomToolBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomToolBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomToolBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        bottomToolBarView.addSubview(bottomStackView)
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.leftAnchor.constraint(equalTo: bottomToolBarView.leftAnchor, constant: 12).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: bottomToolBarView.rightAnchor, constant: -12).isActive = true
        bottomStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomStackView.topAnchor.constraint(equalTo: bottomToolBarView.topAnchor, constant: 50).isActive = true

        bottomStackView.addArrangedSubview(studyButton)
        bottomStackView.addArrangedSubview(previousButton)
        bottomStackView.addArrangedSubview(nextButton)
        bottomStackView.addArrangedSubview(listButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        previousButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        listButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

        studyButton.translatesAutoresizingMaskIntoConstraints = false
        studyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        studyButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    // Move to the next study object, then call change studyObject to present it
    @objc private func onNextClick() {
        if studyObjectIndex < (wordKanjiInfo.count - 1) {
            studyObjectIndex += 1
        } else {
            studyObjectIndex = 0
        }
        changeStudyObject()
    }
    
    // Move to the previous study object, then call change studyObject to present it
    @objc private func onPreviousClick() {
        if studyObjectIndex > 0 {
            studyObjectIndex -= 1
        } else {
            studyObjectIndex = (wordKanjiInfo.count) - 1
        }
        changeStudyObject()
    }
    
    // Appropriately change each of the labels to show the kanji or vocab info depending on which is currently being presented
    private func changeStudyObject() {
        
        self.kanjiImaAnswerLabel.text = ""
        self.kunAnswerLabel.text = "くん: "
        self.onAnswerLabel.text = "おん: "
        self.extraInfoLabel.text = "Extra info: "
        if !(wordKanjiInfo.isEmpty) {
            // figure out why this crashes
            if studyObjectIndex >= wordKanjiInfo.count {
                return
            }
            if wordKanjiInfo[studyObjectIndex].identifier == "Kanji" {
                changeToKanjiView()
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                self.displayLabel.text = kanjiInfo[studyObjectIndex].object
                for answer in kanjiInfo[studyObjectIndex].imaAnswer {
                    self.kanjiImaAnswerLabel.text = self.kanjiImaAnswerLabel.text! + answer
                    if answer != kanjiInfo[studyObjectIndex].imaAnswer.last {
                        self.kanjiImaAnswerLabel.text = self.kanjiImaAnswerLabel.text! + ", "
                    }
                }
                for answer in kanjiInfo[studyObjectIndex].kunAnswer {
                    self.kunAnswerLabel.text = self.kunAnswerLabel.text! + answer
                    if answer != kanjiInfo[studyObjectIndex].kunAnswer.last {
                        self.kunAnswerLabel.text = self.kunAnswerLabel.text! + ", "
                    }
                }
                for answer in kanjiInfo[studyObjectIndex].onAnswer {
                    self.onAnswerLabel.text = self.onAnswerLabel.text! + answer
                    if answer != kanjiInfo[studyObjectIndex].onAnswer.last {
                        self.onAnswerLabel.text = self.onAnswerLabel.text! + ", "
                    }
                }
            } else if wordKanjiInfo[studyObjectIndex].identifier == "Vocab" {
                changeToVocabView()
                let vocabInfo = wordKanjiInfo as! [Word]
                self.displayLabel.text = vocabInfo[studyObjectIndex].object
                self.vocabImaAnswerLabel.text = vocabInfo[studyObjectIndex].imaAnswer
                self.extraInfoLabel.text = vocabInfo[studyObjectIndex].extraInfo
            }
        }
        
    }
    
    // Open the upcoming controller, which shows each of the study objects, with the current one at the beginning of the list
    @objc private func moveToList() {
        let upcomingController = UpcomingController()
        upcomingController.wordKanjiInfo = self.wordKanjiInfo
        upcomingController.offSet = studyObjectIndex
        upcomingController.delegate = self
        upcomingController.isQuiz = false
        self.present(upcomingController, animated: true, completion: nil)
    }
    
    // This function assume the user is logged in.  It then checks if the data is from the study list (using the isStudyList
    // variable).  If it NOT, it creates a document model to hold either the vocab or kanji details.  It then checks if the
    // kanji/vocab has already been saved to Firebase, if so, it diplays an alert, if not, it saves it to the database using
    // the users uid and sends an alert to notify the user upon completion
    // If the data is from the study list, it finds the current study object in the database and deletes it.  Then notifies
    // the user with an alert
    @objc private func addToStudyList() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if self.isStudyList {
            spinner.startAnimating()
            StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                for case let child as DataSnapshot in dataSnapshot.children {
                    let snapshotData = child.value as! [String: Any]
                    if snapshotData["type"] as! String == "Kanji" && self.isKanji {
                        if snapshotData["kanjiMeaning"] as! String == self.wordKanjiInfo[self.studyObjectIndex].object {
                            let elementToDelete = StudyController.ref.child("StudyList").child(uid).child(child.key)
                            elementToDelete.removeValue()
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Kanji successfully deleted, reopen study list to see change", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    } else if snapshotData["type"] as! String == "Vocab" && !self.isKanji {
                        if snapshotData["vocabMeaning"] as! String == self.wordKanjiInfo[self.studyObjectIndex].object {
                            let elementToDelete = StudyController.ref.child("StudyList").child(uid).child(child.key)
                            elementToDelete.removeValue()
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Vocab successfully deleted, reopen study list to see change", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                }
            }
            
            
        } else {
            let data: [String: Any]!
            
            if self.isKanji {
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                //CHANGE i!!!
                var imaMeaning: [String] = []
                var onMeaning: [String] = []
                var kunMeaning: [String] = []
                for meaning in kanjiInfo[studyObjectIndex].imaAnswer {
                    imaMeaning.append(meaning)
                }
                for meaning in kanjiInfo[studyObjectIndex].onAnswer {
                    onMeaning.append(meaning)
                }
                for meaning in kanjiInfo[studyObjectIndex].kunAnswer {
                    kunMeaning.append(meaning)
                }
                data = [
                    "type": "Kanji",
                    "imaMeaning": imaMeaning,
                    "kunMeaning": kunMeaning,
                    "onMeaning": onMeaning,
                    "kanjiMeaning": kanjiInfo[studyObjectIndex].object
                ]
            } else {
                let vocabInfo = wordKanjiInfo as! [Word]
                data = [
                    "type": "Vocab",
                    "imaMeaning": vocabInfo[studyObjectIndex].imaAnswer,
                    "extraInfo": vocabInfo[studyObjectIndex].extraInfo,
                    "vocabMeaning": vocabInfo[studyObjectIndex].object
                ]
            }
            
            spinner.startAnimating()
            StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                var i = 0
                if dataSnapshot.childrenCount == 0 {
                    StudyController.ref.child("StudyList").child(uid).childByAutoId().setValue(data)
                }
                for case let child as DataSnapshot in dataSnapshot.children {
                    let snapshotData = child.value as! [String: Any]
                    if data["type"] as! String == "Kanji" && snapshotData["type"] as! String == "Kanji" {
                        if snapshotData["kanjiMeaning"] as! String == data["kanjiMeaning"] as! String {
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Kanji already saved", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    } else if data["type"] as! String == "Vocab" && snapshotData["type"] as! String == "Vocab" {
                        if snapshotData["vocabMeaning"] as! String == data["vocabMeaning"] as! String {
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Vocab already saved", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                    if i == dataSnapshot.childrenCount - 1 {
                        StudyController.ref.child("StudyList").child(uid).childByAutoId().setValue(data)
                        self.spinner.stopAnimating()
                        let alert = UIAlertController(title: "Alert", message: "Successfully Saved", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        alert.view.tintColor = .red
                        self.present(alert, animated: true, completion: nil)
                    }
                    i += 1
                }
            }
        }
        
        
        
    }
    
    @objc private func handleToggleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: true)
    }
    
    // Handle the UI of the navigation bar and setup the functionality of the navigation bar buttons
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .red
        
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 200, height: 40)

        let button = UIButton(type: .custom)
        button.frame = container.frame
        let attrs = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 30)!
        ]
        let attributedTitle = NSAttributedString(string: "JapWork", attributes: attrs)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(moveToHomePage), for: .touchUpInside)
        container.addSubview(button)
        navigationItem.titleView = container
        
        let menuButton = UIButton()
        menuButton.setImage(#imageLiteral(resourceName: "hamburger_icon").withTintColor(.red), for: .normal)
        menuButton.addTarget(self, action: #selector(handleToggleMenu), for: .touchUpInside)
        menuButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: menuButton), animated: false)
        
        let settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settings_icon").withTintColor(.red), for: .normal)
        settingsButton.addTarget(self, action: #selector(moveToSettings), for: .touchUpInside)
        settingsButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: settingsButton), animated: false)
    }
    
    // sets up the red horizontal lines that separate the labels
    private func setupBorders() {
        let thickness: CGFloat = 2.0
        let kanjiImaTopBorder = CALayer()
        kanjiImaTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        kanjiImaTopBorder.backgroundColor = UIColor.red.cgColor
        let vocabiImaTopBorder = CALayer()
        vocabiImaTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        vocabiImaTopBorder.backgroundColor = UIColor.red.cgColor
        let extraInfoTopBorder = CALayer()
        extraInfoTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        extraInfoTopBorder.backgroundColor = UIColor.red.cgColor
        let kunTopBorder = CALayer()
        kunTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        kunTopBorder.backgroundColor = UIColor.red.cgColor
        let onTopBorder = CALayer()
        onTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        onTopBorder.backgroundColor = UIColor.red.cgColor
        let toolbarTopBorder = CALayer()
        toolbarTopBorder.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: thickness)
        toolbarTopBorder.backgroundColor = UIColor.red.cgColor
        kanjiImaAnswerView.layer.addSublayer(kanjiImaTopBorder)
        vocabImaAnswerView.layer.addSublayer(vocabiImaTopBorder)
        extraInfoView.layer.addSublayer(extraInfoTopBorder)
        kunAnswerView.layer.addSublayer(kunTopBorder)
        onAnswerView.layer.addSublayer(onTopBorder)
        bottomToolBarView.layer.addSublayer(toolbarTopBorder)
    }
    
    private func setupGestureRecognizers() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
        view.addGestureRecognizer(tap)
        let titleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(moveToHomePage))
        navigationItem.titleView?.addGestureRecognizer(titleTap)
    }
    
    @objc private func closeMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: false)
    }
    
    // Deactivate the add to study list button if the user is not logged in
    private func makeGuestChanges() {
        self.studyButton.setImage(#imageLiteral(resourceName: "good").withTintColor(.darkGray), for: .normal)
        self.studyButton.isUserInteractionEnabled = false
    }
    
    @objc private func moveToSettings() {
        delegate?.moveToSettings()
    }
    
    // Function that moves to the home screen, is called when the user taps on the main title
    @objc private func moveToHomePage() {
        let containerController = ContainerController()
        containerController.modalPresentationStyle = .fullScreen
        self.present(containerController, animated: false, completion: nil)
    }
    
    // Whenever the user is at the beginning of a kanji, vocab, or study list or quiz, START is diplayed in the main
    // text with all other fields blank.  This is achieve by creating a Kanji or Word object that just has START as
    // the object text with everything else blank, this function adds this start object to the beginning of the list
    private func addStart() {
        if isKanji {
            wordKanjiInfo.insert(WordKanjiDatabase().startKanij, at: 0)
        } else {
            wordKanjiInfo.insert(WordKanjiDatabase().startVocab, at: 0)
        }
    }
}

extension StudyController: UpcomingControllerDelegate {
    
    // This function is called when a user selects a cell in the upcoming controller.  The function jumps to that
    //study object and presents it using changeStudyObject
    func didSelect(forIndex index: Int) {
        self.studyObjectIndex = index
        changeStudyObject()
    }
}
