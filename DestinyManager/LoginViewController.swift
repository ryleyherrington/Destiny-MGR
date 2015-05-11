//
//  LoginViewController.swift
//  Destiny Checker
//
//  Created by Christopher Martin on 1/16/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var systemSelector: UISegmentedControl!
    @IBOutlet weak var characterNameField: UITextField!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    internal static let StoryboardIdentifier = "LoginViewController"
    
    @IBAction func loadCharacter(sender: UIButton) {
        if !loginValid() {
            return
        }
        
        toggleLoadingUi(true)
        
        let name = self.characterNameField.text
        let system = SystemType(rawValue: self.systemSelector.selectedSegmentIndex+1)!
        var newPlayer = PlayerInfo(name: name, system: system, hash: nil)
        
        if let existing = PlayerInfo.storedPlayer(name, system: system) {
            //self.presentDestinyViewController(existing)
            newPlayer = existing
        }
        
        ServiceManager.fetchPlayerAsync(newPlayer, completion: { (info) -> Void in
            dispatch_async(dispatch_get_main_queue()){
                
                self.toggleLoadingUi(false)
                
                if info != nil {
                    info!.addToStorage()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    let alert = UIAlertView(title: "Error:", message: "Could not load character with that information", delegate: self, cancelButtonTitle: "Try Again")
                    alert.show()
                }
            }
        })
    }
    
    //TODO: this should be a fancy inline thing with colors and * and auto-focusing and such
    func loginValid() -> Bool {
        if characterNameField.text == "" {
            let alert = UIAlertView(title: "Name", message: "Please enter a character name.", delegate: self, cancelButtonTitle: "Okay")
            alert.show()
            return false
        }
        
        if systemSelector.selectedSegmentIndex < 0 {
            characterNameField.layer.borderColor = UIColor.redColor().CGColor
            return false
        }
        
        return true
    }
    
    func toggleLoadingUi(loading: Bool) -> Void {
        loadButton.hidden = loading
        activitySpinner.hidden = !loading
        
        loading ? activitySpinner.startAnimating() : activitySpinner.stopAnimating()
    }
}