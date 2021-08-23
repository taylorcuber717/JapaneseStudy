//
//  QuizController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/20/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class QuizController: UIViewController {
    
    //MARK: - Properties
    
    weak var delegate: MainControllersDelegate?
    var wordKanjiInfo: [StudyObject]!
    var isKanji = false
    var isStudyList = false
    static let ref = Database.database().reference()
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    // Index to keep track of which StudyObject to use
    var i = 0
    
    var tapRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTapView))
        return tap
    }()
    
    lazy var successPopUpWindow: SuccessPopUpWindow = {
        let view = SuccessPopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    lazy var failurePopUpWindow: FailurePopUpWindow = {
        let view = FailurePopUpWindow()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
    
    var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    var kanjiImaAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "english:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        return textField
    }()
    
    var vocabImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var vocabImaAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "english:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        return textField
    }()
    
    var kunAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var kunAnswerTextField: UITextField = {
        let textField = JapaneseTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "kun:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        let jpLanguageCode = "ja-JP"
        textField.languageCode = jpLanguageCode
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        return textField
    }()
    
    var onAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        return view
    }()
    
    var onAnswerTextField: UITextField = {
        let textField = JapaneseTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "on:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        let jpLanguageCode = "ja-JP"
        textField.languageCode = jpLanguageCode
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        return textField
    }()
    
    var bottomToolBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        return view
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        return button
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
        if true {
            randomizeStudyObjects()
        }
        if self.isStudyList {
            setupStudyListView()
        }
        view.backgroundColor = .white
        changeStudyObject()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        visualEffectView.alpha = 0
        view.setupSpinner(spinner: spinner)
        self.spinner.color = .red
        
        onAnswerTextField.delegate = self
        kunAnswerTextField.delegate = self
        kanjiImaAnswerTextField.delegate = self
        vocabImaAnswerTextField.delegate = self
        initializeKeyboard()
    }
    
    //MARK: - Handlers
    
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
        
        kanjiImaAnswerView.addSubview(kanjiImaAnswerTextField)
        kanjiImaAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        kanjiImaAnswerTextField.leftAnchor.constraint(equalTo: kanjiImaAnswerView.leftAnchor, constant: 12).isActive = true
        kanjiImaAnswerTextField.rightAnchor.constraint(equalTo: kanjiImaAnswerView.rightAnchor, constant: -12).isActive = true
        kanjiImaAnswerTextField.centerYAnchor.constraint(equalTo: kanjiImaAnswerView.centerYAnchor).isActive = true
        kanjiImaAnswerTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(kunAnswerView)
        kunAnswerView.translatesAutoresizingMaskIntoConstraints = false
        kunAnswerView.topAnchor.constraint(equalTo: kanjiImaAnswerView.bottomAnchor).isActive = true
        kunAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        kunAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        kunAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        kunAnswerView.addSubview(kunAnswerTextField)
        kunAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        kunAnswerTextField.leftAnchor.constraint(equalTo: kunAnswerView.leftAnchor, constant: 12).isActive = true
        kunAnswerTextField.rightAnchor.constraint(equalTo: kunAnswerView.rightAnchor, constant: -12).isActive = true
        kunAnswerTextField.centerYAnchor.constraint(equalTo: kunAnswerView.centerYAnchor).isActive = true
        kunAnswerTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(onAnswerView)
        onAnswerView.translatesAutoresizingMaskIntoConstraints = false
        onAnswerView.topAnchor.constraint(equalTo: kunAnswerView.bottomAnchor).isActive = true
        onAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        onAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        onAnswerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        onAnswerView.addSubview(onAnswerTextField)
        onAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        onAnswerTextField.leftAnchor.constraint(equalTo: onAnswerView.leftAnchor, constant: 12).isActive = true
        onAnswerTextField.rightAnchor.constraint(equalTo: onAnswerView.rightAnchor, constant: -12).isActive = true
        onAnswerTextField.centerYAnchor.constraint(equalTo: onAnswerView.centerYAnchor).isActive = true
        onAnswerTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        setupToolBarConstraints(bottom: onAnswerView.bottomAnchor)
        
        // setup vocab view constraints
        view.addSubview(vocabImaAnswerView)
        vocabImaAnswerView.translatesAutoresizingMaskIntoConstraints = false
        vocabImaAnswerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        vocabImaAnswerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vocabImaAnswerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vocabImaAnswerView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        
        vocabImaAnswerView.addSubview(vocabImaAnswerTextField)
        vocabImaAnswerTextField.translatesAutoresizingMaskIntoConstraints = false
        vocabImaAnswerTextField.leftAnchor.constraint(equalTo: vocabImaAnswerView.leftAnchor, constant: 12).isActive = true
        vocabImaAnswerTextField.rightAnchor.constraint(equalTo: vocabImaAnswerView.rightAnchor, constant: -12).isActive = true
        vocabImaAnswerTextField.centerYAnchor.constraint(equalTo: vocabImaAnswerView.centerYAnchor).isActive = true
        
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
        self.vocabImaAnswerTextField.isHidden = true
        self.kanjiImaAnswerView.isHidden = false
        self.kanjiImaAnswerTextField.isHidden = false
        self.kunAnswerView.isHidden = false
        self.kunAnswerTextField.isHidden = false
        self.onAnswerView.isHidden = false
        self.onAnswerTextField.isHidden = false
    }
    
    private func changeToVocabView() {
        self.isKanji = false
        self.displayLabel.font = UIFont(name: displayLabel.font?.fontName ?? "System", size: 45)
        self.vocabImaAnswerView.isHidden = false
        self.vocabImaAnswerTextField.isHidden = false
        self.kanjiImaAnswerView.isHidden = true
        self.kanjiImaAnswerTextField.isHidden = true
        self.kunAnswerView.isHidden = true
        self.kunAnswerTextField.isHidden = true
        self.onAnswerView.isHidden = true
        self.onAnswerTextField.isHidden = true
    }
    
    private func setupStudyListView() {
        self.studyButton.setImage(#imageLiteral(resourceName: "delete_icon"), for: .normal)
    }
    
    func setupToolBarConstraints(bottom: NSLayoutYAxisAnchor) {
        view.addSubview(bottomToolBarView)
        bottomToolBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomToolBarView.topAnchor.constraint(equalTo: bottom).isActive = true
        bottomToolBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomToolBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomToolBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        bottomToolBarView.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: bottomToolBarView.topAnchor, constant: 25).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: bottomToolBarView.centerXAnchor).isActive = true
        submitButton.leftAnchor.constraint(equalTo: bottomToolBarView.leftAnchor, constant: 12).isActive = true
        submitButton.rightAnchor.constraint(equalTo: bottomToolBarView.rightAnchor, constant: -12).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        bottomToolBarView.addSubview(bottomStackView)
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.leftAnchor.constraint(equalTo: bottomToolBarView.leftAnchor, constant: 12).isActive = true
        bottomStackView.rightAnchor.constraint(equalTo: bottomToolBarView.rightAnchor, constant: -12).isActive = true
        bottomStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomStackView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 25).isActive = true
        
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
    
    func randomizeStudyObjects() {
        let firstStudyObject = [wordKanjiInfo[0]]
        var tempStudyObjects: [StudyObject] = Array(wordKanjiInfo[1..<wordKanjiInfo.count])
        tempStudyObjects = tempStudyObjects.shuffled()
        self.wordKanjiInfo = firstStudyObject + tempStudyObjects
    }
    
    func showPopUp(success: Bool, message: String) {
        
        if success {
            view.addSubview(successPopUpWindow)
            successPopUpWindow.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true
            successPopUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            successPopUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            successPopUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 175).isActive = true
            
            successPopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            successPopUpWindow.alpha = 0
            
            successPopUpWindow.messageLabel.text = message
            
            UIView.animate(withDuration: 0.5) {
                self.visualEffectView.alpha = 0.8
                self.successPopUpWindow.alpha = 1
                self.successPopUpWindow.transform = CGAffineTransform.identity
            }
            print("Success branch is running")
        } else {
            view.addSubview(failurePopUpWindow)
            failurePopUpWindow.centerYAnchor.constraint(equalTo: displayView.centerYAnchor).isActive = true
            failurePopUpWindow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            failurePopUpWindow.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
            failurePopUpWindow.heightAnchor.constraint(equalToConstant: view.frame.width - 175).isActive = true
            
            failurePopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            failurePopUpWindow.alpha = 0
            
            failurePopUpWindow.messageLabel.text = message
            
            UIView.animate(withDuration: 0.5) {
                self.visualEffectView.alpha = 0.8
                self.failurePopUpWindow.alpha = 1
                self.failurePopUpWindow.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    @objc func onSubmit() {
        
        var imaAnswer = ""
        if isKanji {
            imaAnswer = (kanjiImaAnswerTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))!
            imaAnswer = imaAnswer.lowercased()
        } else {
            imaAnswer = (vocabImaAnswerTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))!
            imaAnswer = imaAnswer.lowercased()
        }
        let kunAnswer = kunAnswerTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let onAnswer = onAnswerTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        var imaCorrect = false
        var kunCorrect = false
        var onCorrect = false
        
        if isKanji {
            let kanjiInfo = wordKanjiInfo[i] as! Kanji
            for answer in kanjiInfo.imaAnswer {
                if imaAnswer == answer {
                    imaCorrect = true
                }
            }
            for answer in kanjiInfo.kunAnswer {
                if kunAnswer == answer {
                    kunCorrect = true
                }
            }
            for answer in kanjiInfo.onAnswer {
                if onAnswer == answer {
                    onCorrect = true
                }
            }
            
            var message = ""
            if (imaCorrect && kunCorrect && onCorrect) {
                message = "Nailed it!"
            } else {
                if imaCorrect {
                    message = "English: Perfect\n"
                } else {
                    message = "English: Nope\n"
                }
                if kunCorrect {
                    message = message + "kun: Perfect\n"
                } else {
                    message = message + "kun: Nope\n"
                }
                if onCorrect {
                    message = message + "on: Perfect"
                } else {
                    message = message + "on: Nope"
                }
            }
            
            showPopUp(success: imaCorrect && kunCorrect && onCorrect, message: message)
            
            
            kanjiImaAnswerTextField.layer.borderWidth = 3
            kunAnswerTextField.layer.borderWidth = 3
            onAnswerTextField.layer.borderWidth = 3
            
            if imaCorrect {
                kanjiImaAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                kanjiImaAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
            if kunCorrect {
                kunAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                kunAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
            if onCorrect {
                onAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                onAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
            
        } else {
            
            let vocabInfo = wordKanjiInfo[i] as! Word
            if imaAnswer == vocabInfo.imaAnswer.lowercased() {
                imaCorrect = true
            }
            
            var message = ""
            if (imaCorrect) {
                message = "Nailed it!"
            } else {
                message = "English: Nope\n"
            }
            
            showPopUp(success: imaCorrect && kunCorrect && onCorrect, message: message)
            
            
            vocabImaAnswerTextField.layer.borderWidth = 3
            kunAnswerTextField.layer.borderWidth = 3
            onAnswerTextField.layer.borderWidth = 3
            
            if imaCorrect {
                vocabImaAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                vocabImaAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
            if kunCorrect {
                kunAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                kunAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
            if onCorrect {
                onAnswerTextField.layer.borderColor = UIColor.green.cgColor
            } else {
                onAnswerTextField.layer.borderColor = UIColor.red.cgColor
            }
        }

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
        
        if wordKanjiInfo[i].identifier == "Kanji" {
            changeToKanjiView()
        } else {
            changeToVocabView()
        }
        
        kanjiImaAnswerTextField.text = ""
        vocabImaAnswerTextField.text = ""
        kunAnswerTextField.text = ""
        onAnswerTextField.text = ""
        kanjiImaAnswerTextField.layer.borderWidth = 0
        vocabImaAnswerTextField.layer.borderWidth = 0
        kunAnswerTextField.layer.borderWidth = 0
        onAnswerTextField.layer.borderWidth = 0
        if !(wordKanjiInfo.isEmpty) {
            if wordKanjiInfo[i].object == "Start" || wordKanjiInfo[i].object == "Supplementary Start" {
                kanjiImaAnswerTextField.isHidden = true
                kunAnswerTextField.isHidden = true
                onAnswerTextField.isHidden = true
                submitButton.isHidden = true
            } else {
                kanjiImaAnswerTextField.isHidden = false
                kunAnswerTextField.isHidden = false
                onAnswerTextField.isHidden = false
                submitButton.isHidden = false
            }
            if wordKanjiInfo[i].identifier == "Kanji" {
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                self.displayLabel.text = kanjiInfo[i].object
            } else if wordKanjiInfo[i].identifier == "Vocab" {
                let vocabInfo = wordKanjiInfo as! [Word]
                self.displayLabel.text = vocabInfo[i].object
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
    
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if onAnswerTextField.isFirstResponder {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardFrame.height - 150
            }
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func addToStudyList() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if self.isStudyList {
            spinner.startAnimating()
            StudyController.ref.child("StudyList").child(uid).observeSingleEvent(of: .value) { dataSnapshot in
                for case let child as DataSnapshot in dataSnapshot.children {
                    let snapshotData = child.value as! [String: Any]
                    if snapshotData["type"] as! String == "Kanji" && self.isKanji {
                        if snapshotData["kanjiMeaning"] as! String == self.wordKanjiInfo[self.i].object {
                            let elementToDelete = StudyController.ref.child("StudyList").child(uid).child(child.key)
                            elementToDelete.removeValue()
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Kanji successfully deleted, reopen study list to see change", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else if snapshotData["type"] as! String == "Vocab" && !self.isKanji {
                        if snapshotData["vocabMeaning"] as! String == self.wordKanjiInfo[self.i].object {
                            let elementToDelete = StudyController.ref.child("StudyList").child(uid).child(child.key)
                            elementToDelete.removeValue()
                            self.spinner.stopAnimating()
                            let alert = UIAlertController(title: "Alert", message: "Vocab successfully deleted, reopen study list to see change", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            alert.view.tintColor = .red
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            
        } else {
            let data: [String: Any]!
            
            if self.isKanji {
                let kanjiInfo = wordKanjiInfo as! [Kanji]
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
    
    @objc func handleToggleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: true)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger_icon"), style: .plain, target: self, action: #selector(handleToggleMenu))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "expand_arrow_icon"), style: .plain, target: self, action: #selector(didTapView))
    }
    
    private func initializeKeyboard() {
        // tap gesture recognizer to remove the keyboard whenever the user taps outside of the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension QuizController: UpComingControllerDelegate {
    func didSelect(forIndex index: Int) {
        self.i = index
        changeStudyObject()
    }
}

extension QuizController: FailurePopUpDelegate {
    func onTryAgain() {
        print("try again is running in quiz controller")
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.failurePopUpWindow.alpha = 0
            self.failurePopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.failurePopUpWindow.removeFromSuperview()
        }
    }
    
    func onShowAnswers() {
        print("show answers is running in quiz controller")
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.failurePopUpWindow.alpha = 0
            self.failurePopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.failurePopUpWindow.removeFromSuperview()
        }
        if let kanji = wordKanjiInfo[i] as? Kanji {
            kanjiImaAnswerTextField.text = kanji.imaAnswer[0]
            kunAnswerTextField.text = kanji.kunAnswer[0]
            onAnswerTextField.text = kanji.onAnswer[0]
            kanjiImaAnswerTextField.layer.borderWidth = 0
            kunAnswerTextField.layer.borderWidth = 0
            onAnswerTextField.layer.borderWidth = 0
        } else if let word = wordKanjiInfo[i] as? Word {
            vocabImaAnswerTextField.text = word.imaAnswer
            vocabImaAnswerTextField.layer.borderWidth = 0
        }
    }
}

extension QuizController: SuccessPopUpDelegate {
    func onContinue() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.successPopUpWindow.alpha = 0
            self.successPopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.successPopUpWindow.removeFromSuperview()
        }
    }
}

extension QuizController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
