//
//  Extensions.swift
//  JapWork
//
//  Created by Taylor McLaughlin on 5/1/20.
//  Copyright © 2020 Taylor McLaughlin. All rights reserved.
//
//  Description: These extensions make it easier to create a color using RGB values, add programmatic anchors (this is a life saver),
//  add a UIActivityIndicatorView to a view, shake a text field, add a private button that will make the text on a keyboard private
//  or undo that, and check if an email is valid.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) ->
        UIColor {
            return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setupSpinner(spinner: UIActivityIndicatorView) {
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinner)
        self.bringSubviewToFront(spinner)

        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}

extension UITextField {
    
    /// Shake Text field 4 times
    public func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
    
    /// Switch button for switching secure entry of Text Field
    public func addSecureEntryBtn(){
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(#imageLiteral(resourceName: "eye-slash-regular"), for: .normal)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        rightButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(disclosePassword(_:))))
        self.rightViewMode = .always
        self.rightView = rightButton
    }
    
    @objc func disclosePassword(_ sender: Any) {
        self.isSecureTextEntry.toggle()
        if let button = self.rightView as? UIButton {
            button.setImage((button.image(for: .normal) == #imageLiteral(resourceName: "eye-slash-regular")) ? #imageLiteral(resourceName: "open-eye"):#imageLiteral(resourceName: "eye-slash-regular") , for: .normal)
        }
    }
    
    /// User Interface of text field in Login/Register Module
    public func setUpTextField(_ rightView: UIImage){
        self.borderStyle = .none
        self.frame.size.height = 46
        self.frame.size.width = 316
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        let baseView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        baseView.layer.cornerRadius = 8
        let imageView = UIImageView(image: rightView)
        imageView.frame = CGRect(x: baseView.center.x - 8, y:  baseView.center.y - 8, width: 16, height: 16)
        baseView.addSubview(imageView)
        self.leftViewMode = .always
        self.leftView = baseView
    }
    
    /// check if the email address in valid
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text ?? "")
    }
    
    /// Check if text includes blanks
    func hasTextWithoutBlank() -> Bool {
        return ((self.text?.trimmingCharacters(in: .whitespaces))?.count)! > 0
    }
    
    
}
