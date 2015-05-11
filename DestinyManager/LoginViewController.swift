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
        //todo move this into it's own validation func
        //also this is pretty shit UX so don't do it
        if characterNameField.text == "" {
            let alert = UIAlertView(title: "Name", message: "Please enter a character name.", delegate: self, cancelButtonTitle: "Okay")
            alert.show()
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
                //TODO: info should give success or failure or something like that
                info.addToStorage()
                
                self.toggleLoadingUi(false)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
    }
    
    func toggleLoadingUi(loading: Bool) -> Void {
        loadButton.hidden = loading
        activitySpinner.hidden = !loading
        
        loading ? activitySpinner.startAnimating() : activitySpinner.stopAnimating()
    }
}