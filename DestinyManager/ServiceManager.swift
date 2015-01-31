//
//  ServiceManager.swift
//  Destiny Checker
//
//  Created by Christopher Martin on 1/17/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as Value, forKey: k as Key)
        }
    }
}

//todo this may need to be a class, but why bother if we can hang static methods off a struct and not worry about it
struct ServiceManager {
    
    private static let networkQueue = NSOperationQueue()
    
    private static func urlForPlayer(player:PlayerInfo) -> NSURL! {
        let url = NSURL(scheme: "http", host: "www.bungie.net", path: "/Platform/Destiny/SearchDestinyPlayer/\(player.playerSystem.rawValue)/\(player.displayName)/")
        return url
    }
    
    private static func urlForTigerAccount(system:String, playerHash:String) -> NSURL! {
        
        if system == "2"
        {
            return NSURL(scheme: "http", host: "www.bungie.net", path: "/Platform/Destiny/TigerPSN/Account/\(playerHash)/")
        }
        else // else Xbox
        {
            return NSURL(scheme: "http", host: "www.bungie.net", path: "/Platform/Destiny/TigerXbox/Account/\(playerHash)/")
        }
        
    }
    
    private static func parseResponseForTigerInfo(data:NSData) -> [String:Any] {
        
        var err: NSError? = nil;
        var dictionary: [String:Any] = [String:Any]()
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &err)
        
        if let root = json as? NSDictionary {
            // Do we really care about checking the error status? Possibly extranous?
            if let errorStatus = root["ErrorStatus"] as? String {
                if errorStatus == "Success" {
                    if let response = root["Response"] as? NSDictionary {
                        if let dictData = response["data"] as? NSDictionary {
                            
                            let (characterArray, clanName, clanTag, inventory, grimoirScore) = (dictData["characters"] as? NSArray, dictData["clanName"] as? NSString, dictData["clanTag"] as? NSString, dictData["inventory"] as? NSDictionary, dictData["grimoireScore"] as? Int)
                            
                            // Fill in the empty dictionary with the data returned
                            dictionary["clanTag"] = clanTag!
                            dictionary["clanName"] = clanName!
                            dictionary["inventory"] = inventory!
                            dictionary["characters"] = characterArray!
                            dictionary["grimoireScore"] = grimoirScore!
                        }
                    }
                }
            }
        }
        
        return dictionary
    }
    
    private static func parseResponseForPlayerInfo(data:NSData) -> [String:String] {
        var err: NSError? = nil
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments, error:&err)
        
        if let root = json as? NSDictionary {
            if let response = root["Response"] as? NSArray {
                if let info = response[0] as? NSDictionary {
                    //the if let construct doesn't work with tuples so we might want a safer way to do this
                    let (hash, type, display) = (info["membershipId"] as? String,  info["membershipType"] as? Int, info["displayName"] as? String)
                    let dict = ["displayName": display!, "playerHash": hash!, "playerSystem":String(type!)]
                    return dict
                }
            }
        }
        
        return [String:String]()
    }
    
    static func fetchPlayer(player:PlayerInfo) -> PlayerInfo {
        let url = self.urlForPlayer(player)
        let data = NSData(contentsOfURL: url!)
        var dict = self.parseResponseForPlayerInfo(data!) as [String: Any]
        
        let tigerUrl = self.urlForTigerAccount(dict["playerSystem"] as String, playerHash: dict["playerHash"] as String)
        let tigerData = NSData(contentsOfURL: tigerUrl!)
        let tigerDict = self.parseResponseForTigerInfo(tigerData!)
        
        // Append the tiger data to the player info data
        dict.merge(tigerDict)
        
        let info = PlayerInfo(dictionary: dict)
        
        return info
    }
    
    static func fetchPlayerAsync(player:PlayerInfo, completion:(PlayerInfo) -> Void) -> Void {
        let url = self.urlForPlayer(player)
        let req = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(req, queue: self.networkQueue) { (response, data, error) -> Void in
            
            let dict = self.parseResponseForPlayerInfo(data)
            let tigerUrl = self.urlForTigerAccount(dict["playerSystem"]! as String, playerHash: dict["playerHash"]! as String)
            let tigerReq = NSURLRequest(URL: tigerUrl)
            
            NSURLConnection.sendAsynchronousRequest(tigerReq, queue: self.networkQueue) { (tigerResponse, tigerData, tigerError) -> Void in
                
                let tigerDict = self.parseResponseForTigerInfo(tigerData)
                var accountDict = [String:Any]()
                accountDict.merge(dict)
                accountDict.merge(tigerDict)
                
                let info = PlayerInfo(dictionary: accountDict)
                completion(info)
                
            }
            
        }
    }
}