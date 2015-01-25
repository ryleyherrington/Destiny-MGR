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
    
    init(name:String, system:SystemType, hash:String?) {
        self.displayName = name
        self.playerSystem = system
        self.playerHash = hash
    }
    
    //structs can't be stored in NSUserDefaults (they're not objects) so we "archive" ourself as a dictionary
    init(dictionary:[String:String]) {
        self.playerHash = dictionary["playerHash"]!
        let raw = dictionary["playerSystem"]!
        self.playerSystem = SystemType(rawValue: raw.toInt()!)!
        self.displayName = dictionary["displayName"]!
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
            for dict in dicts as [[String: String]] {
                let player = PlayerInfo(dictionary: dict)
                
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