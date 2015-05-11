//
//  ColorExtensions.swift
//  DestinyManager
//
//  Created by Christopher Martin on 5/11/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //NOTE: ugly syntax required to avoid compiler error
    internal static var DestinyGreen: UIColor  {
        get {
            return UIColor(red: 51.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
    }
    
    
    internal static var DestinyOrange: UIColor {
        get {
            return UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
    }
    
    internal static var DestinyYellow: UIColor {
        get {
            return UIColor(red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
        }
    }
}