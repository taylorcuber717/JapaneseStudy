//
//  SignUpPageVCViewController.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 8/19/21.
//  Copyright © 2021 Taylor McLaughlin. All rights reserved.
//
//  Description: This view controller prompts the user to either create an account or sign in.  Once they do one
//  of those (or continue as a guest) go to the home page.
//

import UIKit
import Firebase
import FirebaseAuth
import Firebase

class LandingPageController: UIViewController {
    
    //MARK: Properties
    
    var state = "normal"
    let spinner = UIActivityIndicatorView()
    
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
    
    var backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setupSpinner(spinner: spinner)
        
        view.backgroundColor = .white
        spinner.color = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        setupConstraints()
        setupGestureRecognizers()
        checkIfLoggedIn()
    }
    
    //MARK: Handlers
    
    // This screen has UI elements that are used for the landing, login, and sign up pages.  Starts in the landing page design
    // and sets the alpha of certain elements to 0 or 1 to switch between with an animation
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
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.anchor(top: nil, left: view.leftAnchor, bottom: emailTextField.topAnchor, right: nil, paddingTop: 0, paddingLeft: 50, paddingRight: 50, paddingBottom: 12, width: 0, height: 0)
        
        //constraints for view when in log in mode
        view.addSubview(loginSubmitButton)
        loginSubmitButton.translatesAutoresizingMaskIntoConstraints = false
        loginSubmitButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingRight: -50, paddingBottom: 12, width: 0, height: 50)
        
        
        signUpSubmitButton.alpha = 0
        loginSubmitButton.alpha = 0
        emailTextField.alpha = 0
        passwordTextField.alpha = 0
        backButton.alpha = 0
    }
    
    private func setupGestureRecognizers() {
        // tap gesture recognizer to remove the keyboard whenever the user taps outside of the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // Set the alpha to zero of each of the UI elements only related to the login view and set the alpha to one the ones related to the sign up view
    private func changeToSignUp() {
        
        self.state = "signup"
        
        UIView.animate(withDuration: 0.5) {
            self.signUpButton.alpha = 0
            self.loginButton.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.signUpSubmitButton.alpha = 1
                self.emailTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.backButton.alpha = 1
            }
        }
    }
    
    // Set the alpha to zero of each of the UI elements only related to the sign up view and set the alpha to one the ones related to the login view
    private func changeToLogIn() {
        
        self.state = "login"
        
        UIView.animate(withDuration: 0.5) {
            self.signUpButton.alpha = 0
            self.loginButton.alpha = 0
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.loginSubmitButton.alpha = 1
                self.emailTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.backButton.alpha = 1
            }
        }
    }
    
    @objc private func onSignIn() {
        changeToSignUp()
    }
    
    @objc private func onLogIn() {
        changeToLogIn()
    }
    
    // If they select guest, tell the user the limitations of guest login and if they confirm save isGuest into userDefauts
    // and go to the home page
    @objc private func onGuest() {
        
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: "isGuest")
        
        let alert = UIAlertController(title: "Alert", message: "If you continue as a guest you won't be able to save Kanji/vocab and you won't be able to create custom quizzes.  \nAre you sure you want to continue?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            let containerController = ContainerController()
            containerController.modalPresentationStyle = .fullScreen
            self.present(containerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { action in
            return
        }))
        alert.view.tintColor = .red
        self.present(alert, animated: true, completion: nil)
    }
    
    // Revert back to the landing page view
    @objc private func onBack() {
        
        if self.state == "login" {
            UIView.animate(withDuration: 0.5) {
                self.loginSubmitButton.alpha = 0
                self.emailTextField.alpha = 0
                self.passwordTextField.alpha = 0
                self.backButton.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.signUpButton.alpha = 1
                    self.loginButton.alpha = 1
                }
            }
        } else if self.state == "signup" {
            UIView.animate(withDuration: 0.5) {
                self.signUpSubmitButton.alpha = 0
                self.emailTextField.alpha = 0
                self.passwordTextField.alpha = 0
                self.backButton.alpha = 0
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.signUpButton.alpha = 1
                    self.loginButton.alpha = 1
                }
            }
        }
        
        self.state = "normal"
    }
    
    // Create an account on the database for the user using the given credentials and go to the home page.  If there is a
    // problem given an alert
    @objc private func onSignInSubmit() {
        
        spinner.startAnimating()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.spinner.stopAnimating()
            if error != nil {
                print("Error: LandingPageController.onSignInSubmit() \(String(describing: error?.localizedDescription))")
                let alert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                alert.view.tintColor = .red
                self.present(alert, animated: true, completion: nil)
            } else {
                let defaults = UserDefaults.standard
                defaults.setValue(false, forKey: "isGuest")
                let containerController = ContainerController()
                containerController.modalPresentationStyle = .fullScreen
                self.present(containerController, animated: true, completion: nil)
            }
        }
    }
    
    // Check if a user exists within the database with the given credentials, if they do, log them in and go to the home page.
    // If they do not, give an alert
    @objc private func onLogInSubmit() {
        
        spinner.startAnimating()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.spinner.stopAnimating()
            if error != nil {
                print("Error: LandingPageController.onLogInSubmit() \(String(describing: error?.localizedDescription))")
                let alert = UIAlertController(title: "Alert", message: "Account not found, username or password are incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                alert.view.tintColor = .red
                self.present(alert, animated: true, completion: nil)
            } else {
                let defaults = UserDefaults.standard
                defaults.setValue(false, forKey: "isGuest")
                let containerController = ContainerController()
                containerController.modalPresentationStyle = .fullScreen
                self.present(containerController, animated: true, completion: nil)
            }
        }
    }
    
    // When the app is opened check if they are already logged in (they should be unless they were logged out
    // when they last exited the app), if they are then go to the home page.
    private func checkIfLoggedIn() {
        if Auth.auth().currentUser?.uid != nil {
            let containerController = ContainerController()
            containerController.modalPresentationStyle = .fullScreen
            self.present(containerController, animated: false, completion: nil)
        }
    }

}

extension LandingPageController: UITextFieldDelegate {
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
