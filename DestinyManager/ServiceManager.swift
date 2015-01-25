//
//  ServiceManager.swift
//  Destiny Checker
//
//  Created by Christopher Martin on 1/17/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation

//todo this may need to be a class, but why bother if we can hang static methods off a struct and not worry about it
struct ServiceManager {
    
    private static let networkQueue = NSOperationQueue()
    
    private static func urlForPlayer(player:PlayerInfo) -> NSURL! {
        let url = NSURL(scheme: "http", host: "www.bungie.net", path: "/Platform/Destiny/SearchDestinyPlayer/\(player.playerSystem.rawValue)/\(player.displayName)/")
        return url
    }
   
    private static func parseResponse(data:NSData) -> [String:String] {
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
    
    static func fetchPlayerHash(player:PlayerInfo) -> PlayerInfo {
        let url = self.urlForPlayer(player)
        
        let data = NSData(contentsOfURL: url!)
        let dict = self.parseResponse(data!)
        let info = PlayerInfo(dictionary: dict)
        
        return info
    }
    
    static func fetchPlayerHashAsync(player:PlayerInfo, completion:(PlayerInfo) -> Void) -> Void {
        let url = self.urlForPlayer(player)
        let req = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(req, queue: self.networkQueue) { (response, data, error) -> Void in
            let dict = self.parseResponse(data)
            let info = PlayerInfo(dictionary: dict)
            
            completion(info)
        }
    }
}