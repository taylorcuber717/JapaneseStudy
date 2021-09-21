//
//  QuizController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 5/20/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller presents either a Kanji or Vocab object to the user and quizzes them on it.
//  The user can go to the next study object, the previous, select a particular one via the UpcomingController, or
//  save the study object to a personal study list.  They can also enter answers in the given textfield, click submit,
//  see if they got it right or wrong, and see the correct answers if they got it wrong.
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
    var quizObjectIndex = 0
    
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
        view.backgroundColor = .black
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
        view.backgroundColor = .black
        return view
    }()
    
    var kanjiImaAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "english:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    var vocabImaAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var vocabImaAnswerTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "english:", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.font = UIFont(name: textField.font?.fontName ?? "System", size: 25)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .allTouchEvents)
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    var kunAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    var onAnswerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    var bottomToolBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    var submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        button.layer.cornerRadius = 5
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
        configureNavigationBar()
        setupConstraints()
        if self.isStudyList {
            setupStudyListView()
        }
        view.backgroundColor = .white
        addStart()
        changeStudyObject()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
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
        setupBorders()
        setupGestureRecognizers()
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "randomizeQuizOrder") {
            shuffleWordKanjiInfo()
        }
        if Auth.auth().currentUser?.uid == nil {
            makeGuestChanges()
        }
    }
    
    //MARK: - Handlers
    
    
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
        displayLabel.leftAnchor.constraint(equalTo: displayView.leftAnchor, constant: 12).isActive = true
        displayLabel.rightAnchor.constraint(equalTo: displayView.rightAnchor, constant: -12).isActive = true

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
        vocabImaAnswerTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
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
        self.vocabImaAnswerTextField.isHidden = true
        self.kanjiImaAnswerView.isHidden = false
        self.kanjiImaAnswerTextField.isHidden = false
        self.kunAnswerView.isHidden = false
        self.kunAnswerTextField.isHidden = false
        self.onAnswerView.isHidden = false
        self.onAnswerTextField.isHidden = false
    }
    
    // Hide each of the UI elements only related to the kanji view and unhide the ones related to the vocab view
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
    
    // Change the icon of the studyButton to a trash can if in data is from study list
    private func setupStudyListView() {
        self.studyButton.setImage(#imageLiteral(resourceName: "delete_icon").withTintColor(.white), for: .normal)
    }
    
    // Theis is the view at the bottom that holds the next and previous buttons, the save to study list button, the upcoming button
    // and the large submit button
    private func setupToolBarConstraints(bottom: NSLayoutYAxisAnchor) {
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
        bottomStackView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 0).isActive = true
        
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
    
    // The the failure or success pop up window
    private func showPopUp(success: Bool, message: String) {
        
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
    
    // Check if the user submitted the correct answer.  For each of the text fields where they entered the correct answer
    // give it a green border, and a red border for each one where they entered the incorrect answer.  If they entered the
    // correct answer on all of them, show successPopUpWindow that notifies them.  If they didn't enter the correct answer
    // on at least one, show failurePopUpWindow that notifies them and allows them to either try again or see the correct
    // answers
    @objc private func onSubmit() {
        
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
            let kanjiInfo = wordKanjiInfo[quizObjectIndex] as! Kanji
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
            
            let vocabInfo = wordKanjiInfo[quizObjectIndex] as! Word
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
        }

    }
    
    // Move to the next study object, then call change studyObject to present it
    @objc private func onNextClick() {
        if quizObjectIndex < (wordKanjiInfo.count - 1) {
            quizObjectIndex += 1
        } else {
            quizObjectIndex = 0
        }
        changeStudyObject()
    }
    
    // Move to the previous study object, then call change studyObject to present it
    @objc private func onPreviousClick() {
        if quizObjectIndex > 0 {
            quizObjectIndex -= 1
        } else {
            quizObjectIndex = (wordKanjiInfo.count) - 1
        }
        changeStudyObject()
    }
    
    // Appropriately change each of the labels to show the kanji or vocab info depending on which is currently being presented
    private func changeStudyObject() {
        
        if quizObjectIndex >= wordKanjiInfo.count {
            return
        }
        if wordKanjiInfo[quizObjectIndex].identifier == "Kanji" {
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
            if wordKanjiInfo[quizObjectIndex].object == "Start" || wordKanjiInfo[quizObjectIndex].object == "Supplementary Start" {
                kanjiImaAnswerTextField.isHidden = true
                kunAnswerTextField.isHidden = true
                onAnswerTextField.isHidden = true
                submitButton.isHidden = true
                vocabImaAnswerTextField.isHidden = true
            } else {
                kanjiImaAnswerTextField.isHidden = false
                kunAnswerTextField.isHidden = false
                onAnswerTextField.isHidden = false
                submitButton.isHidden = false
                vocabImaAnswerTextField.isHidden = false
            }
            if wordKanjiInfo[quizObjectIndex].identifier == "Kanji" {
                let kanjiInfo = wordKanjiInfo as! [Kanji]
                self.displayLabel.text = kanjiInfo[quizObjectIndex].object
            } else if wordKanjiInfo[quizObjectIndex].identifier == "Vocab" {
                let vocabInfo = wordKanjiInfo as! [Word]
                self.displayLabel.text = vocabInfo[quizObjectIndex].object
            }
        }
        
    }
    
    // Open the upcoming controller, which shows each of the study objects, with the current one at the beginning of the list
    @objc private func moveToList() {
        let upcomingController = UpcomingController()
        upcomingController.wordKanjiInfo = self.wordKanjiInfo
        upcomingController.offSet = quizObjectIndex
        upcomingController.delegate = self
        upcomingController.isQuiz = true
        self.present(upcomingController, animated: true, completion: nil)
    }
    
    // The keyboard might have a red or green border, if the user has submitted an incorrect or correct
    // answer respectively.  This will remove that border
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textField.layer.borderWidth = 0
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
                        if snapshotData["kanjiMeaning"] as! String == self.wordKanjiInfo[self.quizObjectIndex].object {
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
                        if snapshotData["vocabMeaning"] as! String == self.wordKanjiInfo[self.quizObjectIndex].object {
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
                var imaMeaning: [String] = []
                var onMeaning: [String] = []
                var kunMeaning: [String] = []
                for meaning in kanjiInfo[quizObjectIndex].imaAnswer {
                    imaMeaning.append(meaning)
                }
                for meaning in kanjiInfo[quizObjectIndex].onAnswer {
                    onMeaning.append(meaning)
                }
                for meaning in kanjiInfo[quizObjectIndex].kunAnswer {
                    kunMeaning.append(meaning)
                }
                data = [
                    "type": "Kanji",
                    "imaMeaning": imaMeaning,
                    "kunMeaning": kunMeaning,
                    "onMeaning": onMeaning,
                    "kanjiMeaning": kanjiInfo[quizObjectIndex].object
                ]
            } else {
                let vocabInfo = wordKanjiInfo as! [Word]
                data = [
                    "type": "Vocab",
                    "imaMeaning": vocabInfo[quizObjectIndex].imaAnswer,
                    "extraInfo": vocabInfo[quizObjectIndex].extraInfo,
                    "vocabMeaning": vocabInfo[quizObjectIndex].object
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
        view.endEditing(true)
        delegate?.handleMenuToggle(forMenuOption: nil, forShouldExpand: false)
    }
    
    // Randomize the order of the study objects, only called when randomize setting as true
    private func shuffleWordKanjiInfo() {
        
        for i in 0...wordKanjiInfo.count - 2 {
            if wordKanjiInfo[i].object == "Supplementary Start" {
                wordKanjiInfo.remove(at: i)
            }
        }
        
        let start = wordKanjiInfo[0]
        wordKanjiInfo.remove(at: 0)
        
        wordKanjiInfo.shuffle()
        wordKanjiInfo.insert(start, at: 0)
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

extension QuizController: UpcomingControllerDelegate {
    
    // This function is called when a user selects a cell in the upcoming controller.  The function jumps to that
    //study object and presents it using changeStudyObject
    func didSelect(forIndex index: Int) {
        self.quizObjectIndex = index
        changeStudyObject()
    }
}

extension QuizController: FailurePopUpDelegate {
    
    // remove pop up
    func onTryAgain() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.failurePopUpWindow.alpha = 0
            self.failurePopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.failurePopUpWindow.removeFromSuperview()
        }
    }
    
    // For each of the text fields, change their text to the correct answer and remove the pop up
    func onShowAnswers() {
        UIView.animate(withDuration: 0.5, animations: {
            self.visualEffectView.alpha = 0
            self.failurePopUpWindow.alpha = 0
            self.failurePopUpWindow.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.failurePopUpWindow.removeFromSuperview()
        }
        if let kanji = wordKanjiInfo[quizObjectIndex] as? Kanji {
            kanjiImaAnswerTextField.text = kanji.imaAnswer[0]
            kunAnswerTextField.text = kanji.kunAnswer[0]
            onAnswerTextField.text = kanji.onAnswer[0]
            kanjiImaAnswerTextField.layer.borderWidth = 0
            kunAnswerTextField.layer.borderWidth = 0
            onAnswerTextField.layer.borderWidth = 0
        } else if let word = wordKanjiInfo[quizObjectIndex] as? Word {
            vocabImaAnswerTextField.text = word.imaAnswer
            vocabImaAnswerTextField.layer.borderWidth = 0
        }
    }
}

extension QuizController: SuccessPopUpDelegate {
    
    // Remove pop up
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
