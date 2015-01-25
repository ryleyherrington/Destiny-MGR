//
//  Stats.swift
//  Destiny Checker
//
//  Created by Will Yee on 1/18/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation

struct Stats {
    private(set) var statName:String
    private(set) var statHash:Int
    private(set) var statValue:Int
    private(set) var statMax:Int
    
    init(name: String, dict: NSDictionary) {
        
        self.statName = name
        self.statHash = dict["statHash"] as Int
        self.statValue = dict["value"] as Int
        self.statMax = dict["maximumValue"] as Int
        
    }
    
    // Makes the assumption that the dictionary coming in is valid and not malformed
    static func createCharacterStats(dict: NSDictionary) -> [Stats] {

        var stats = [Stats]()
        
        for (key, value) in dict {
            let stat = Stats(name: key as String, dict: value as NSDictionary)
            stats.append(stat)
        }
        
        return stats
    }
}