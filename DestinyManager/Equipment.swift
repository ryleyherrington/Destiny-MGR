//
//  Equipment.swift
//  Destiny Checker
//
//  Created by Will Yee on 1/19/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation

struct Dye {
    private(set) var channelHash: Int
    private(set) var dyeHash: Int
    
    init(channel: Int, dye: Int) {
        self.channelHash = channel
        self.dyeHash = dye
    }
}

struct Equipment {
    private(set) var itemHash: Int
    private(set) var dye: [Dye]
    
    init(item: Int, dye: [Dye]) {
        self.itemHash = item
        self.dye = dye
    }
    
    static func createEquipment(equipmentArray: NSArray) -> [Equipment] {
        var equipments = [Equipment]()
        
        for element in equipmentArray {
            var dyes = [Dye]()

            let equipmentEntry = element as NSDictionary
            let itemHash = equipmentEntry["itemHash"] as Int
            let dyeArray = equipmentEntry["dyes"] as NSArray
            
            for dye in dyeArray {
                
                let dyeEntry = dye as NSDictionary
                let channelHash = dyeEntry["channelHash"] as Int
                let dyeHash = dyeEntry["dyeHash"] as Int
                
                dyes.append(Dye(channel: channelHash, dye: dyeHash))
                
            }
            
            equipments.append(Equipment(item: itemHash, dye: dyes))
            
        }
        
        return equipments
    }
    
}