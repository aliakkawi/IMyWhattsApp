//
//  UIViewControllerExtensions.swift
//  IMyWhattsApp
//
//  Created by Ali Akkawi on 07/09/2018.
//  Copyright © 2018 Ali Akkawi. All rights reserved.
//

import Foundation
import UIKit
import JDropDownAlert

extension UIViewController {
    
    func hideKeyboardWhenTapAround () {
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func viewTapped(_ tapGesture: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    func dismissKeyboard(){
        
        self.view.endEditing(true)
    }
    
    func dismiss () {
        
        dismiss(animated: true, completion: nil)
    }
    
    func isTextEmpty (text: String)-> Bool{
        
        return text.isEmpty || text == ""
        
    }
    
    func displayDropDownAlert (title: String, message: String, color: UIColor){
        
        let alert = JDropDownAlert(position: .bottom, direction: .toLeft)
        alert.alertWith(title, message: message, topLabelColor: UIColor.white, backgroundColor: color)
    }
    
    func displayAlertController (title: String, messagae: String) {
        
        let alertController = UIAlertController(title: title, message: messagae, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
