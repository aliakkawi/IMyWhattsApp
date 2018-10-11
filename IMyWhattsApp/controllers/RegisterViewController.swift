//
//  ViewController.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 07/09/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import UIKit
import JGProgressHUD

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatePasswordTextField: UITextField!
    var hud: JGProgressHUD!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud = JGProgressHUD(style: .dark)
        self.hideKeyboardWhenTapAround()
    }


    //MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        dismissKeyboard()
        let emailString = emailTextField.text
        let passwordString = passwordTextField.text
        
        
        guard let theEmailString = emailString, !isTextEmpty(text: theEmailString) else {
            
            displayDropDownAlert(title: "", message: "Please enter email", color: Constants.lightRed)
            return
            
        }
        
        guard let thePasswordString = passwordString, !isTextEmpty(text: thePasswordString) else {
            
            displayDropDownAlert(title: "", message: "Please enter password", color: Constants.lightRed)
            return
            
        }
        
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let emailString = emailTextField.text
        let passwordString = passwordTextField.text
        let repeatePasswordString = repeatePasswordTextField.text
        
        guard let theEmailString = emailString, !isTextEmpty(text: theEmailString) else {
            
            displayDropDownAlert(title: "", message: "Please type in your email address", color: Constants.lightRed)
            return
            
        }
        
        guard let thePasswordString = passwordString, !isTextEmpty(text: thePasswordString) else {
            
            displayDropDownAlert(title: "", message: "Please type in a password", color: Constants.lightRed)
            return
            
        }
        
        guard let theRepeatePasswordString = repeatePasswordString, !isTextEmpty(text: theRepeatePasswordString) else {
            
            displayDropDownAlert(title: "", message: "Please repeate password", color: Constants.lightRed)
            return
            
        }
        
        if thePasswordString != theRepeatePasswordString {
            displayDropDownAlert(title: "", message: "Passwords does not match", color: Constants.lightRed)
            return
        }
        
        if !isEmailValid(forEmail: theEmailString){
            
            displayDropDownAlert(title: "Invalid email address", message: "", color: Constants.lightRed)
            return
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        
        profileVC.emailString = theEmailString
        profileVC.passwordString = thePasswordString
        present(profileVC, animated: true) {
            
            self.clearAllTextFields()
            self.dismissKeyboard()
        }
    }
    
    fileprivate func clearAllTextFields() {
        
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatePasswordTextField.text = ""
    }
    
    
    fileprivate func isEmailValid(forEmail emailAddress: String)->Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
        
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatePasswordTextField.resignFirstResponder()
        
        return false
    }
}
