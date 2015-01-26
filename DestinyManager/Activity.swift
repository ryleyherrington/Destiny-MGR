//
//  Activity.swift
//  DestinyManager
//
//  Created by Herrington, Ryley on 1/25/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import Foundation
import CoreData

@objc(Activity)

class Activity: NSManagedObject {

    @NSManaged var character: String
    @NSManaged var finished: String
    @NSManaged var name: String
    @NSManaged var indexPath: String

}
