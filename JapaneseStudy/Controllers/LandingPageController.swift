//
//  SignUpPageVCViewController.swift
//  JapaneseStudy
//
//  Created by Taylor McLaughlin on 8/19/21.
//  Copyright © 2021 Taylor McLaughlin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LandingPageController: UIViewController {
    
    //MARK: Properties
    
    var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(onSignIn), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var signUpSubmitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign up", for: .normal)
        button.addTarget(self, action: #selector(onSignInSubmit), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(onLogIn), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var loginSubmitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(onLogInSubmit), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var guestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Continue as guest", for: .normal)
        button.addTarget(self, action: #selector(onGuest), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var guestLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Account needed to save kanji/vocab to study and to create custom quizzes"
        label.textColor = .gray
        label.font = label.font.withSize(10)
        return label
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 5
        textField.textColor = .black
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 5
        textField.textColor = .black
        textField.isSecureTextEntry = true
        textField.addSecureEntryBtn()
        return textField
    }()
    
    //MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        setupGestureRecognizers()
        
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        checkIfLoggedIn()
    }
    
    //MARK: Handlers
    
    private func setupConstraints() {
        
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 0, width: 0, height: 50)
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.anchor(top: signUpButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 50, paddingRight: -50, paddingBottom: 0, width: 0, height: 50)
        
        view.addSubview(guestButton)
        guestButton.translatesAutoresizingMaskIntoConstraints = false
        guestButton.anchor(top: loginButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 50, paddingRight: -50, paddingBottom: 0, width: 0, height: 0)
        
        view.addSubview(guestLabel)
        guestLabel.translatesAutoresizingMaskIntoConstraints = false
        guestLabel.anchor(top: guestButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 50, paddingRight: -50, paddingBottom: 0, width: 0, height: 0)
        
        
        //constraints for view when in sign up mode
        view.addSubview(signUpSubmitButton)
        signUpSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        signUpSubmitButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 12, width: 0, height: 50)
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.anchor(top: nil, left: view.leftAnchor, bottom: signUpSubmitButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 12, width: 0, height: 50)
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.anchor(top: nil, left: view.leftAnchor, bottom: passwordTextField.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 12, width: 0, height: 50)
        
        //constraints for view when in log in mode
        view.addSubview(loginSubmitButton)
        loginSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        loginSubmitButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 12, width: 0, height: 50)
        
        
        signUpSubmitButton.isHidden = true
        loginSubmitButton.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
    }
    
    private func setupGestureRecognizers() {
        // tap gesture recognizer to remove the keyboard whenever the user taps outside of the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func changeToSignUp() {
        signUpButton.isHidden = true
        loginButton.isHidden = true
        
        signUpSubmitButton.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
    }
    
    private func changeToLogIn() {
        signUpButton.isHidden = true
        loginButton.isHidden = true
        
        loginSubmitButton.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
    }
    
    @objc func onSignIn() {
        changeToSignUp()
    }
    
    @objc func onLogIn() {
        changeToLogIn()
    }
    
    @objc func onGuest() {
        let alert = UIAlertController(title: "Alert", message: "If you continue as a guest you won't be able to save Kanji/vocab and you won't be able to create custom quizzes.  \nAre you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            let containerController = ContainerController()
            containerController.modalPresentationStyle = .fullScreen
            self.present(containerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onSignInSubmit() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let containerController = ContainerController()
                containerController.modalPresentationStyle = .fullScreen
                self.present(containerController, animated: true, completion: nil)
            }
        }
        
        print("sign in is running")
    }
    
    @objc func onLogInSubmit() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription)
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let containerController = ContainerController()
                containerController.modalPresentationStyle = .fullScreen
                self.present(containerController, animated: true, completion: nil)
            }
        }
    }
    
    private func checkIfLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            let containerController = ContainerController()
            containerController.modalPresentationStyle = .fullScreen
            self.present(containerController, animated: false, completion: nil)
        } else {
            print("user currently not logged in")
        }
    }

}

extension LandingPageController: UITextFieldDelegate {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
