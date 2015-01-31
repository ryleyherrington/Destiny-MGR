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
    
    @IBAction func loadCharacter(sender: UIButton) {
        //todo move this into it's own validation func
        //also this is pretty shit UX so don't do it
        if characterNameField.text == "" {
            let alert = UIAlertView(title: "Name", message: "Please enter a character name.", delegate: self, cancelButtonTitle: "Okay")
            alert.show()
            return
        }
        
        //todo show a fancy spinner thing here while we load and populate the hash and all that jazz
        let name = self.characterNameField.text
        let system = SystemType(rawValue: self.systemSelector.selectedSegmentIndex+1)!
        if let existing = PlayerInfo.storedPlayer(name, system: system) {
            self.presentDestinyViewController(existing)
        } else {
            let newPlayer = PlayerInfo(name: name, system: system, hash: nil)
            ServiceManager.fetchPlayerAsync(newPlayer, completion: { (info) -> Void in
                dispatch_async(dispatch_get_main_queue()){
                    self.presentDestinyViewController(info)
                }
            })
        }
    }
    
    @IBAction func SkipThisPage(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DestinyViewController") as ViewController
        
        let system = SystemType(rawValue: self.systemSelector.selectedSegmentIndex+1)!
        vc.player = PlayerInfo(name: "RYLEYRO", system:system, hash: nil)
        
        vc.navigationItem.title = "RYLEYRO"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentDestinyViewController(player:PlayerInfo) -> Void {
        //i'd much rather do this with a segue but I can't figure out how to name the fucking things in this version of xcode
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("DestinyViewController") as ViewController
        vc.player = player
        vc.navigationItem.title = player.displayName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let lastPlayer = PlayerInfo.lastLoadedPlayer() {
            //pre-populate the text field here or just auto-login
            self.characterNameField.text = lastPlayer.displayName
            self.systemSelector.selectedSegmentIndex = (lastPlayer.playerSystem.rawValue - 1)
            
            //we may want to in the future provide an auto-complete list of all entered players
            //or something neato like that
        }
    }
}