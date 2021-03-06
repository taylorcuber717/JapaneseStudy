//
//  StudyController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/9/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit

class StudyController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: MainControllersDelegate?
    var wordKanjiInfo: [StudyObject]!
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
    
    var imaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var imaAnswerLabel: UILabel = {
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
        configureNavigationBar()
        setupConstraints()
        view.backgroundColor = .white
        changeStudyObject()
    }
    
    //MARK: - Handlers
    
    func setupConstraints() {
        
        if wordKanjiInfo[0].identifier == "Kanji" {
            setupKanjiConstraints()
        } else if wordKanjiInfo[0].identifier == "Vocab" {
            setupVocabCosntraints()
        }
        
    }
    
    func setupKanjiConstraints() {
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

        view.addSubview(imaAnswerView)
        imaAnswerView.translatesAutoresizingMaskIntoConstraints = false
        imaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        imaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imaAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        imaAnswerView.addSubview(imaAnswerLabel)
        imaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        imaAnswerLabel.leftAnchor.constraint(equalTo: imaAnswerView.leftAnchor, constant: 12).isActive = true
        imaAnswerLabel.rightAnchor.constraint(equalTo: imaAnswerView.rightAnchor, constant: -12).isActive = true
        imaAnswerLabel.centerYAnchor.constraint(equalTo: imaAnswerView.centerYAnchor).isActive = true
        
        view.addSubview(kunAnswerView)
        kunAnswerView.translatesAutoresizingMaskIntoConstraints = false
        kunAnswerView.topAnchor.constraint(equalTo: imaAnswerView.bottomAnchor).isActive = true
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
    }
    
    func setupVocabCosntraints() {
        view.addSubview(displayView)
        displayView.translatesAutoresizingMaskIntoConstraints = false
        displayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        displayView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        displayView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        displayView.heightAnchor.constraint(equalToConstant: view.frame.height / 3.5).isActive = true
        
        displayView.addSubview(displayLabel)
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.leftAnchor.constraint(equalTo: displayView.leftAnchor, constant: 12).isActive = true
        displayLabel.rightAnchor.constraint(equalTo: displayView.rightAnchor, constant: -12).isActive = true
        displayLabel.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true
        displayLabel.font = UIFont(name: displayLabel.font?.fontName ?? "System", size: 45)
        displayLabel.text = "Here"

        view.addSubview(imaAnswerView)
        imaAnswerView.translatesAutoresizingMaskIntoConstraints = false
        imaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        imaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imaAnswerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        imaAnswerView.addSubview(imaAnswerLabel)
        imaAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
        imaAnswerLabel.leftAnchor.constraint(equalTo: imaAnswerView.leftAnchor, constant: 12).isActive = true
        imaAnswerLabel.rightAnchor.constraint(equalTo: imaAnswerView.rightAnchor, constant: -12).isActive = true
        imaAnswerLabel.centerYAnchor.constraint(equalTo: imaAnswerView.centerYAnchor).isActive = true
        imaAnswerLabel.font = UIFont(name: imaAnswerLabel.font?.fontName ?? "System", size: 30)
        
        view.addSubview(extraInfoView)
        extraInfoView.translatesAutoresizingMaskIntoConstraints = false
        extraInfoView.topAnchor.constraint(equalTo: imaAnswerView.bottomAnchor).isActive = true
        extraInfoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        extraInfoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        extraInfoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        extraInfoView.addSubview(extraInfoLabel)
        extraInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        extraInfoLabel.leftAnchor.constraint(equalTo: extraInfoView.leftAnchor, constant: 12).isActive = true
        extraInfoLabel.rightAnchor.constraint(equalTo: extraInfoView.rightAnchor, constant: -12).isActive = true
        extraInfoLabel.centerYAnchor.constraint(equalTo: extraInfoView.centerYAnchor).isActive = true
        
        setupToolBarConstraints(bottom: extraInfoView.bottomAnchor)
        
        
    }
    
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
        
        self.imaAnswerLabel.text = ""
        self.kunAnswerLabel.text = "くん: "
        self.onAnswerLabel.text = "おん: "
        self.extraInfoLabel.text = "Extra info: "
        if !(wordKanjiInfo.isEmpty) {
            if wordKanjiInfo[i].identifier == "Kanji" {
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                self.displayLabel.text = kanjiInfo[i].object
                for answer in kanjiInfo[i].imaAnswer {
                    self.imaAnswerLabel.text = self.imaAnswerLabel.text! + answer
                    if answer != kanjiInfo[i].imaAnswer.last {
                        self.imaAnswerLabel.text = self.imaAnswerLabel.text! + ", "
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
                let vocabInfo = wordKanjiInfo as! [Word]
                self.displayLabel.text = vocabInfo[i].object
                self.imaAnswerLabel.text = vocabInfo[i].imaAnswer
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
        
        //let kanji = CoreDataKanji(context: PersistenceService.context)
        
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
