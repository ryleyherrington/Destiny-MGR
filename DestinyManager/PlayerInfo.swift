//
//  PlayerInfo.swift
//  Destiny Checker
//
//  Created by Christopher Martin on 1/16/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation
import UIKit

let StoredPlayersArrayKey = "com.herrington.Destiny-Checker.storedPlayers"

enum SystemType:Int {
    case XBox = 1
    case Playstation = 2
}

struct PlayerInfo {
    private(set) var playerHash:String?
    private(set) var playerSystem:SystemType
    private(set) var displayName:String
    private(set) var clanName:String?
    private(set) var clanTag:String?
    private(set) var inventory: NSDictionary?
    private(set) var grimoireScore: Int?
    private(set) var characters: [Character]?
    
    init(name:String, system:SystemType, hash:String?) {
        self.displayName = name
        self.playerSystem = system
        self.playerHash = hash // Will this always be nil? The only case I see this constructor currently being used
        // is to create "login" a new user?
        
        self.clanName = nil
        self.clanTag = nil
        self.inventory = nil
        self.grimoireScore = nil
        self.characters = nil
    }
    
    //structs can't be stored in NSUserDefaults (they're not objects) so we "archive" ourself as a dictionary
    init(dictionary:[String:Any]) {
        
        // This feels unsafe...is there a proper way to check for validity?
        let raw = dictionary["playerSystem"]! as! String
        let inventory = dictionary["inventory"] as! NSDictionary
        self.playerSystem = SystemType(rawValue: raw.toInt()!)!
        
        self.playerHash = dictionary["playerHash"]! as? String
        self.displayName = dictionary["displayName"]! as! String
        self.clanName = dictionary["clanName"]! as? String
        self.clanTag = dictionary["clanTag"]! as? String
        self.inventory = dictionary["inventory"]! as? NSDictionary
        self.grimoireScore = dictionary["grimoireScore"]! as? Int
        self.characters = Character.createCharactersFromData(dictionary["characters"]! as! NSArray)
        
        self.addToStorage()
    }
    
    func toDictionary() -> [String:String] {
        let dict = ["playerHash": self.playerHash!, "playerSystem": String(self.playerSystem.rawValue), "displayName": self.displayName ]
        return dict
    }
    
    func addToStorage() -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        var alreadyStored = defaults.arrayForKey(StoredPlayersArrayKey) ?? []
        
        //todo check to see if we already have an entry with the name and system or the hash and update it as necessary
        
        alreadyStored.append(self.toDictionary())
        
        defaults.setObject(alreadyStored, forKey: StoredPlayersArrayKey)
    }
    
    static func registerStorage() -> Void {
        let ourDefaultStorage = [[String:String]]()
        NSUserDefaults.standardUserDefaults().registerDefaults([StoredPlayersArrayKey: ourDefaultStorage])
    }
    
    static func storedPlayers() -> [PlayerInfo] {
        var loaded = [PlayerInfo]()
        //todo we may want to hang onto this rather than hit it every time
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedPlayers = defaults.arrayForKey(StoredPlayersArrayKey)
        
        if let dicts = storedPlayers {
            for dict in dicts as! [[String: String]] {
                // let player = PlayerInfo(dictionary: dict)
                let name:String = dict["displayName"]! as String
                let system:String = dict["playerSystem"]! as String
                let hash:String = dict["playerHash"]! as String
                
                let player = PlayerInfo(name: name, system: SystemType(rawValue:system.toInt()!)!, hash: hash)
                loaded.append(player)
            }
        }
        
        return loaded
    }
    
    static func storedPlayer(name:String, system:SystemType) -> PlayerInfo? {
        let found = self.storedPlayers().filter{$0.displayName == name && $0.playerSystem == system}
        return found.first
    }
    
    static func storedPlayer(hash:String) -> PlayerInfo? {
        let found = self.storedPlayers().filter{$0.playerHash == hash}
        return found.first
    }
    
    static func lastLoadedPlayer() -> PlayerInfo? {
        let players = self.storedPlayers()
        
        return players.last
    }
}