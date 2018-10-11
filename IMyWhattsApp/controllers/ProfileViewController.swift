//
//  ProfileViewController.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 08/10/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import UIKit
import JGProgressHUD

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    var emailString: String?
    var passwordString: String?
    var imagePicked = false
    var hud: JGProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Please wait..."
        self.hideKeyboardWhenTapAround()
        
        
        
    }

    @IBAction func doneButtontAPPED(_ sender: Any) {
        
        
        if let theEmailString = emailString, let thePasswordString = passwordString{
            
            print("email: \(theEmailString), password: \(thePasswordString)")
            let nameString = nameTextField.text
            let surnameString = surnameTextField.text
            let countryString = countryTextField.text
            let cityString = cityTextField.text
            let phoneString = phoneTextField.text
            
            guard let theNameString = nameString, !isTextEmpty(text: theNameString) else {
                
                displayDropDownAlert(title: "", message: "type name", color: Constants.lightRed)
                return
                
            }
            guard let theSurnameString = surnameString, !isTextEmpty(text: theSurnameString) else {
                displayDropDownAlert(title: "", message: "type surname", color: Constants.lightRed)
                return
                
            }
            guard let thecountryString = countryString, !isTextEmpty(text: thecountryString) else {
                displayDropDownAlert(title: "", message: "type country", color: Constants.lightRed)
                return
                
            }
            
            guard let theCityString = cityString, !isTextEmpty(text: theCityString) else {
                displayDropDownAlert(title: "", message: "type city", color: Constants.lightRed)
                return
                
            }
            
            guard let thePhoneString = phoneString, !isTextEmpty(text: thePhoneString) else {
                displayDropDownAlert(title: "", message: "type phone", color: Constants.lightRed)
                return
                
            }
            
            hud.show(in: self.view, animated: true)
            
            if !imagePicked {
                
                // we need to generate an avatar from the user name.
                FirUserService.instance.generateAvatar(firstName: theNameString, lastName: theSurnameString) { (imageReturned) in
                    
                    FirUserService.instance.registerUserWithEmailAddress(forEmail: theEmailString, andPassword: thePasswordString, firstName: theNameString, lastName: theSurnameString, country: thecountryString, city: theCityString, phone: thePhoneString, avatarPicked: false, image: imageReturned, completion: { (success, error) in
                        
                        DispatchQueue.main.async {
                            
                            self.hud.dismiss()
                            if error != nil {
                                
                                self.displayAlertController(title: "Error", messagae: error!.localizedDescription)
                                
                            } else {
                                
                                //registeration success.
                            }
                        }
                    })
                    
                }
                
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        dismissKeyboard()
        dismiss(animated: true) {
            self.emptyAllTextFields()
        }
    }
    
    
    fileprivate func emptyAllTextFields(){
        
        nameTextField.text = ""
        surnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
    }
    
}


extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        countryTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        return false
    }
}
