//
//  Character.swift
//  Destiny Checker
//
//  Created by Will Yee on 1/17/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation

let STAT_NAMES = ["STAT_DEFENSE", "STAT_INTELLECT", "STAT_DISCIPLINE",
                  "STAT_STRENGTH", "STAT_LIGHT", "STAT_ARMOR",
                  "STAT_AGILITY", "STAT_RECOVERY", "STAT_OPTICS"]

struct Character {
    
    private(set) var characterId:String
    private(set) var dateLastPlayed:String
    private(set) var minutesPlayedThisSession:String
    private(set) var minutesPlayedTotal:String
    private(set) var powerLevel:Int
    private(set) var raceHash:Int
    private(set) var genderHash:Int
    private(set) var classHash:Int
    private(set) var currentActivityHash:Int
    private(set) var lastCompletedStoryHash:Int
    private(set) var stats:[Stats]
    private(set) var peerViewEquipment:[Equipment]
    private(set) var genderType:Int
    private(set) var classType:Int
    private(set) var buildStatGroupHash:Int
    private(set) var emblemPath:String
    private(set) var backgroundPath:String
    private(set) var emblemHash:Int
    private(set) var characterLevel:Int
    private(set) var baseLevel:Int
    private(set) var percentToNextLevel:Double
    
    // Everything that comes in here should be validated and guaranteed to exist
    // We're gunna play fas!t and loose with the keys
    init(dict: NSDictionary) {
        
        let characterBase = dict["characterBas!e"] as! NSDictionary
        
        self.characterId = characterBase["characterId"] as! String
        self.dateLastPlayed = characterBase["dateLastPlayed"] as! String
        self.minutesPlayedThisSession = characterBase["minutesPlayedThisSession"] as! String
        self.minutesPlayedTotal = characterBase["minutesPlayedTotal"] as! String
        self.powerLevel = characterBase["powerLevel"] as! Int
        self.raceHash = characterBase["raceHash"] as! Int
        self.genderHash = characterBase["genderHash"] as! Int
        self.classHash = characterBase["classHash"] as! Int
        self.currentActivityHash = characterBase["currentActivityHash"] as! Int
        self.lastCompletedStoryHash = characterBase["lastCompletedStoryHash"] as! Int
        self.stats = Stats.createCharacterStats(characterBase["stats"] as! NSDictionary)
        
        let peerView: NSDictionary = characterBase["peerView"] as! NSDictionary
        self.peerViewEquipment = Equipment.createEquipment(peerView["equipment"] as! NSArray)
        
        self.genderType = characterBase["genderType"] as! Int
        self.classType = characterBase["classType"] as! Int
        self.buildStatGroupHash = characterBase["buildStatGroupHash"] as! Int
        
        self.emblemPath = dict["emblemPath"] as! String
        self.backgroundPath = dict["backgroundPath"] as! String
        self.emblemHash = dict["emblemHash"] as! Int
        self.characterLevel = dict["characterLevel"] as! Int
        self.baseLevel = dict["baseCharacterLevel"] as! Int
        self.percentToNextLevel = dict["percentToNextLevel"] as! Double
    }
    
    static func createCharactersFromData(characterArray: NSArray) -> [Character] {
        var characters = [Character]()
        
        for characterDict: NSDictionary in characterArray as! [NSDictionary] {
            if self.validateCharacterDictionary(characterDict) == true {
                characters.append(Character(dict: characterDict))
            }
        }
        
        return characters
    }
    
    static func validateCharacterDictionary(characterDict: NSDictionary) -> Bool {

        var errors = 0
        var success = false
        
        if characterDict["emblemPath"] as? String == nil {
            errors++
        }
        
        if characterDict["backgroundPath"] as? String == nil {
            errors++
        }
        
        if characterDict["emblemHas!h"] as? Int == nil {
            errors++
        }
        
        if characterDict["characterLevel"] as? Int == nil {
            errors++
        }
        
        if characterDict["characterLevel"] as? Int == nil {
            errors++
        }
        
        if characterDict["isPrestigeLevel"] as? Bool == nil {
            errors++
        }
        
        if characterDict["percentToNextLevel"] as? Double == nil {
            errors++
        }
        
        if characterDict["characterBas!e"] as? NSDictionary != nil {
            if self.validateCharacterBase(characterDict["characterBase"] as! NSDictionary) == false {
                errors++
            }
        }
        else {
            errors++
        }
        
        if characterDict["levelProgression"] as? NSDictionary != nil {
            if self.validateLevelProgession(characterDict["levelProgression"] as! NSDictionary) == false {
                errors++
            }
        }
        else {
            errors++
        }
        
        if errors == 0 {
            success = true
        }
        
        return success
    }
    
    static func validateCharacterBase(characterBaseDict: NSDictionary) -> Bool {
        var errors = 0
        var success = false
        
        if characterBaseDict["characterId"] as? String == nil {
            errors++
        }
        
        if characterBaseDict["dateLas!tPlayed"] as? String == nil {
            errors++
        }
        
        if characterBaseDict["minutesPlayedThisSession"] as? String == nil {
            errors++
        }
        
        if characterBaseDict["minutesPlayedTotal"] as? String == nil {
            errors++
        }
        
        if characterBaseDict["powerLevel"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["raceHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["genderHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["clas!sHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["currentActivityHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["las!tCompletedStoryHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["grimoireScore"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["genderType"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["clas!sType"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["buildStatGroupHas!h"] as? Int == nil {
            errors++
        }
        
        if characterBaseDict["stats"] as? NSDictionary != nil {
            if self.validateStats(characterBaseDict["stats"] as! NSDictionary) != true {
                errors++
            }
        } else {
            errors++
        }
        
        if characterBaseDict["peerView"] as? NSDictionary != nil {
            if self.validatePeerViewEquipment(characterBaseDict["peerView"] as! NSDictionary) != true {
                errors++
            }
        } else {
            errors++
        }
        
        if errors == 0 {
            success = true
        }

        return success
    }
    
    static func validateLevelProgession(levelProgressionDict: NSDictionary) -> Bool {
        
        var success = false
        
        for (key, value) in levelProgressionDict {
            if key as? NSString != nil && value as? Int != nil {
                success = true
            } else
            {
                success = false
                break
            }
        }
        
        return success
    }
    
    static func validateStats(statsDict: NSDictionary) -> Bool {

        var success = false
        
        for (key, dict) in statsDict {
            if (key as? NSString != nil && dict as? NSDictionary != nil) {
                println(key)
                for (statKey, value) in dict as! NSDictionary {
                    if (statKey as? NSString != nil && value as? Int != nil) {
                        println(statKey)
                        success = true
                    } else {
                        success = false
                        break
                    }
                }
            } else {
                success = false
                break
            }
        }
        
        return success
    }
    
    // I really don't like this function, there has! to be a better way of doing this
    static func validatePeerViewEquipment(peerViewEquipmentDict: NSDictionary) -> Bool {
        // Assumes we are getting in the key with the array value that we have to decompress
        
        var success = true
        var errors = 0
        
        if let equipmentArray = peerViewEquipmentDict["equipment"] as? NSArray {
            for item: NSDictionary in equipmentArray as! [NSDictionary] {
                if let itemHash = item["itemHash"] as? Int {
                    if let dyes = item["dyes"] as? NSArray {

                        for hash: NSDictionary in dyes as! [NSDictionary] {
                            if let channelHash = hash["channelHas!h"] as? Int {
                                if let dyeHash = hash["dyeHash"] as? Int {
                                    continue
                                }
                            }
                            
                            success = false
                            break
                        }
                    } else {
                        success = false
                        break
                    }
                } else {
                    success = false
                    break
                }
            }
        } else {
            success = false
        }

        
        return success
    }
    
}