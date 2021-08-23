//
//  StudyController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/9/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class StudyController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: MainControllersDelegate?
    var wordKanjiInfo: [StudyObject]!
    static let ref = Database.database().reference()
    var isKanji: Bool!
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // Index to keep track of which StudyObject to use
    var i = 0
    
    var displayView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    var displayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 150)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var kanjiImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var kanjiImaAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    var vocabImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var vocabImaAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    var kunAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var kunAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = "くん: "
        label.numberOfLines = 0
        return label
    }()
    
    var onAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    var onAnswerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 25)
        label.text = "おん: "
        label.numberOfLines = 0
        return label
    }()
    
    var extraInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    var extraInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font?.fontName ?? "System", size: 30)
        label.text = "Extra info: "
        label.numberOfLines = 0
        return label
    }()
    
    var bottomToolBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
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
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(onNextClick), for: .touchUpInside)
        return button
    }()
    
    var previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("Previous", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(onPreviousClick), for: .touchUpInside)
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "list_icon"), for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(moveToList), for: .touchUpInside)
        return button
    }()
    
    var studyButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "good"), for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(addToStudyList), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        configureNavigationBar()
        setupConstraints()
        view.backgroundColor = .white
        changeStudyObject()
        view.setupSpinner(spinner: spinner)
        self.spinner.color = .red
    }
    
    //MARK: - Handlers
    
    private func disableSaveButton() {
        studyButton.isEnabled = false
        //TODO: change color and stuff too
    }
    
    private func checkIfLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            print("user not signed in")
            disableSaveButton()
        }
    }
    
//    func setupConstraints() {
//
//        if wordKanjiInfo[0].identifier == "Kanji" {
//            setupKanjiConstraints()
//            self.isKanji = true
//        } else if wordKanjiInfo[0].identifier == "Vocab" {
//            setupVocabCosntraints()
//            self.isKanji = false
//        }
//
//    }
    
    func setupConstraints() {
        
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
    
//    func setupKanjiConstraints() {
//        view.addSubview(displayView)
//        displayView.translatesAutoresizingMaskIntoConstraints = false
//        displayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        displayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        displayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        displayView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
//
//        displayView.addSubview(displayLabel)
//        displayLabel.translatesAutoresizingMaskIntoConstraints = false
//        displayLabel.centerXAnchor.constraint(equalTo: displayView.centerXAnchor).isActive = true
//        displayLabel.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true
//
//        view.addSubview(kanjiImaAnswerView)
//        kanjiImaAnswerView.translatesAutoresizingMaskIntoConstraints = false
//        kanjiImaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
//        kanjiImaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        kanjiImaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        kanjiImaAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        kanjiImaAnswerView.addSubview(kanjiImaAnswerLabel)
//        kanjiImaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
//        kanjiImaAnswerLabel.leftAnchor.constraint(equalTo: kanjiImaAnswerView.leftAnchor, constant: 12).isActive = true
//        kanjiImaAnswerLabel.rightAnchor.constraint(equalTo: kanjiImaAnswerView.rightAnchor, constant: -12).isActive = true
//        kanjiImaAnswerLabel.centerYAnchor.constraint(equalTo: kanjiImaAnswerView.centerYAnchor).isActive = true
//
//        view.addSubview(kunAnswerView)
//        kunAnswerView.translatesAutoresizingMaskIntoConstraints = false
//        kunAnswerView.topAnchor.constraint(equalTo: kanjiImaAnswerView.bottomAnchor).isActive = true
//        kunAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        kunAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        kunAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        kunAnswerView.addSubview(kunAnswerLabel)
//        kunAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
//        kunAnswerLabel.leftAnchor.constraint(equalTo: kunAnswerView.leftAnchor, constant: 12).isActive = true
//        kunAnswerLabel.rightAnchor.constraint(equalTo: kunAnswerView.rightAnchor, constant: -12).isActive = true
//        kunAnswerLabel.centerYAnchor.constraint(equalTo: kunAnswerView.centerYAnchor).isActive = true
//
//        view.addSubview(onAnswerView)
//        onAnswerView.translatesAutoresizingMaskIntoConstraints = false
//        onAnswerView.topAnchor.constraint(equalTo: kunAnswerView.bottomAnchor).isActive = true
//        onAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        onAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        onAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        onAnswerView.addSubview(onAnswerLabel)
//        onAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
//        onAnswerLabel.leftAnchor.constraint(equalTo: onAnswerView.leftAnchor, constant: 12).isActive = true
//        onAnswerLabel.rightAnchor.constraint(equalTo: onAnswerView.rightAnchor, constant: -12).isActive = true
//        onAnswerLabel.centerYAnchor.constraint(equalTo: onAnswerView.centerYAnchor).isActive = true
//
//        setupToolBarConstraints(bottom: onAnswerView.bottomAnchor)
//    }
    
//    func setupVocabCosntraints() {
//        view.addSubview(displayView)
//        displayView.translatesAutoresizingMaskIntoConstraints = false
//        displayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        displayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        displayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        displayView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
//
//        displayView.addSubview(displayLabel)
//        displayLabel.translatesAutoresizingMaskIntoConstraints = false
//        displayLabel.leftAnchor.constraint(equalTo: displayView.leftAnchor, constant: 12).isActive = true
//        displayLabel.rightAnchor.constraint(equalTo: displayView.rightAnchor, constant: -12).isActive = true
//        displayLabel.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true
//        displayLabel.font = UIFont(name: displayLabel.font?.fontName ?? "System", size: 45)
//        displayLabel.text = "Here"
//
//        view.addSubview(imaAnswerView)
//        imaAnswerView.translatesAutoresizingMaskIntoConstraints = false
//        imaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
//        imaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        imaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        imaAnswerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//
//        imaAnswerView.addSubview(imaAnswerLabel)
//        imaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
//        imaAnswerLabel.leftAnchor.constraint(equalTo: imaAnswerView.leftAnchor, constant: 12).isActive = true
//        imaAnswerLabel.rightAnchor.constraint(equalTo: imaAnswerView.rightAnchor, constant: -12).isActive = true
//        imaAnswerLabel.centerYAnchor.constraint(equalTo: imaAnswerView.centerYAnchor).isActive = true
//        imaAnswerLabel.font = UIFont(name: imaAnswerLabel.font?.fontName ?? "System", size: 30)
//
//        view.addSubview(extraInfoView)
//        extraInfoView.translatesAutoresizingMaskIntoConstraints = false
//        extraInfoView.topAnchor.constraint(equalTo: imaAnswerView.bottomAnchor).isActive = true
//        extraInfoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        extraInfoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        extraInfoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
//
//        extraInfoView.addSubview(extraInfoLabel)
//        extraInfoLabel.translatesAutoresizingMaskIntoConstraints = false
//        extraInfoLabel.leftAnchor.constraint(equalTo: extraInfoView.leftAnchor, constant: 12).isActive = true
//        extraInfoLabel.rightAnchor.constraint(equalTo: extraInfoView.rightAnchor, constant: -12).isActive = true
//        extraInfoLabel.centerYAnchor.constraint(equalTo: extraInfoView.centerYAnchor).isActive = true
//
//        setupToolBarConstraints(bottom: extraInfoView.bottomAnchor)
//
//
//    }
//
    func setupToolBarConstraints(bottom: NSLayoutYAxisAnchor) {
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


//        bottomToolBarView.addSubview(nextButton)
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        nextButton.centerXAnchor.constraint(equalTo: bottomToolBarView.centerXAnchor, constant: view.frame.width / 4).isActive = true
//        nextButton.topAnchor.constraint(equalTo: bottomToolBarView.topAnchor, constant: 50).isActive = true
//
//        bottomToolBarView.addSubview(previousButton)
//        previousButton.translatesAutoresizingMaskIntoConstraints = false
//        previousButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        previousButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        previousButton.centerXAnchor.constraint(equalTo: bottomToolBarView.centerXAnchor, constant: -(view.frame.width / 4)).isActive = true
//        previousButton.topAnchor.constraint(equalTo: bottomToolBarView.topAnchor, constant: 50).isActive = true
    }
    
    @objc func onNextClick() {
        if i < (wordKanjiInfo.count - 1) {
            i += 1
        } else {
            i = 0
        }
        changeStudyObject()
    }
    
    @objc func onPreviousClick() {
        if i > 0 {
            i -= 1
        } else {
            i = (wordKanjiInfo.count) - 1
        }
        changeStudyObject()
    }
    
    func changeStudyObject() {
        
        self.kanjiImaAnswerLabel.text = ""
        self.kunAnswerLabel.text = "くん: "
        self.onAnswerLabel.text = "おん: "
        self.extraInfoLabel.text = "Extra info: "
        if !(wordKanjiInfo.isEmpty) {
            // figure out why this crashes
            if wordKanjiInfo[i].identifier == "Kanji" {
                changeToKanjiView()
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                self.displayLabel.text = kanjiInfo[i].object
                for answer in kanjiInfo[i].imaAnswer {
                    self.kanjiImaAnswerLabel.text = self.kanjiImaAnswerLabel.text! + answer
                    if answer != kanjiInfo[i].imaAnswer.last {
                        self.kanjiImaAnswerLabel.text = self.kanjiImaAnswerLabel.text! + ", "
                    }
                }
                for answer in kanjiInfo[i].kunAnswer {
                    self.kunAnswerLabel.text = self.kunAnswerLabel.text! + answer
                    if answer != kanjiInfo[i].kunAnswer.last {
                        self.kunAnswerLabel.text = self.kunAnswerLabel.text! + ", "
                    }
                }
                for answer in kanjiInfo[i].onAnswer {
                    self.onAnswerLabel.text = self.onAnswerLabel.text! + answer
                    if answer != kanjiInfo[i].onAnswer.last {
                        self.onAnswerLabel.text = self.onAnswerLabel.text! + ", "
                    }
                }
            } else if wordKanjiInfo[i].identifier == "Vocab" {
                changeToVocabView()
                let vocabInfo = wordKanjiInfo as! [Word]
                self.displayLabel.text = vocabInfo[i].object
                self.vocabImaAnswerLabel.text = vocabInfo[i].imaAnswer
                self.extraInfoLabel.text = vocabInfo[i].extraInfo
            }
        }
        
    }
     
    @objc func moveToList() {
        let upComingController = UpComingController()
        upComingController.wordKanjiInfo = self.wordKanjiInfo
        upComingController.offSet = i
        upComingController.delegate = self
        self.present(upComingController, animated: true, completion: nil)
    }
    
    @objc func addToStudyList() {
        
        let data: [String: Any]!
        
        if self.isKanji {
            let kanjiInfo = wordKanjiInfo as! [Kanji]
            //CHANGE i!!!
            var imaMeaning: [String] = []
            var onMeaning: [String] = []
            var kunMeaning: [String] = []
            for meaning in kanjiInfo[i].imaAnswer {
                imaMeaning.append(meaning)
            }
            for meaning in kanjiInfo[i].onAnswer {
                onMeaning.append(meaning)
            }
            for meaning in kanjiInfo[i].kunAnswer {
                kunMeaning.append(meaning)
            }
            data = [
                "type": "Kanji",
                "imaMeaning": imaMeaning,
                "kunMeaning": kunMeaning,
                "onMeaning": onMeaning,
                "kanjiMeaning": kanjiInfo[i].object
            ]
        } else {
            let vocabInfo = wordKanjiInfo as! [Word]
            data = [
                "type": "Vocab",
                "imaMeaning": vocabInfo[i].imaAnswer,
                "extraInfo": vocabInfo[i].extraInfo,
                "vocabMeaning": vocabInfo[i].object
            ]
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
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
    
    @objc func handleToggleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: true)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(handleToggleMenu))
    }
    
}

extension StudyController: UpComingControllerDelegate {
    func didSelect(forIndex index: Int) {
        self.i = index
        changeStudyObject()
    }
}
