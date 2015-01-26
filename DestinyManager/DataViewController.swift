//??
//  DataViewController.swift
//  PagerProject
//
//  Created by Herrington, Ryley on 1/19/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
   
    var collectionView: UICollectionView?
    var dataObject: AnyObject?
    var type: String?
    var topItems = [String]()
    var bottomItems = [String]()
    var activities = [Activity]()
    
    let greenColor  = UIColor (red: 51.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
    let orangeColor = UIColor (red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1)
    let yellowColor = UIColor (red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        if type != nil {
           // println("IN DATA \(type)")
            
            //initialize
            topItems = []
            bottomItems = []
            
            if type == "WEEKLY" {
                topItems = [
                    "24 - Heroic",
                    "28 - Heroic",
                    "30 - Heroic",
                ]
                bottomItems = ["Nightfall"]
                
            }
            if type == "VOG" {
                topItems = [
                    "Reg VOG CP",
                    "1st Chest",
                    "Oracles",
                    "Templar",
                    "Exotic Chest",
                    "Gatekeepers",
                    "Atheon"
                    ]
                
                bottomItems = [
                    "Reg VOG CP",
                    "1st Chest",
                    "Oracles",
                    "Templar",
                    "Exotic Chest",
                    "Gatekeepers",
                    "Atheon"
                ]
            }
            if type == "CROTA" {
                topItems = [
                    "Reg Crota CP",
                    "1st Chest",
                    "Lamps",
                    "Bridge",
                    "2nd Chest",
                    "Deathsinger",
                    "Crota"
                    ]
                
                bottomItems = [
                    "Hard Crota CP",
                    "1st Chest",
                    "Lamps",
                    "Bridge",
                    "2nd Chest",
                    "Deathsinger",
                    "Crota"
                ]
            }
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 80, left: 10, bottom: 10, right: 10)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        //Half width
        //let cellWidth = (screenSize.width/2-15)
        
        //full width
        let cellWidth = (screenSize.width - 20)
        let cellHeight = (screenSize.height/5)

        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(BaseCollectionViewCell.self, forCellWithReuseIdentifier: "BaseCollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        getActivities()
    }
   
    func getActivities(){
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"Activity")
        
        //3
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Activity]
       
        if let results = fetchedResults {
            //println("fetched Results:\(results)")
            for activity: Activity in results {
                println("activity:\(activity.character)")
                let row:Int = Int(activity.row)
                let section:Int = Int(activity.section)
//                let ip = NSIndexPath(forRow: Int(activity.row), inSection: Int(activity.section))
                let ip = NSIndexPath(forRow: row, inSection: section)
                
//                let cell:BaseCollectionViewCell = collectionView(collectionView, cellForItemAtIndexPath:ip)
                if activity.character == "LEFT" {
 //                   cell.leftButton.backgroundColor = UIColor.blackColor()
                }
            }

        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topItems.count
        }
        else {
            return bottomItems.count
        }
    }
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BaseCollectionViewCell", forIndexPath: indexPath) as BaseCollectionViewCell
        if indexPath.section == 0 {
            cell.textLabel.text = self.topItems[indexPath.row]
        }else {
            cell.textLabel.text = self.bottomItems[indexPath.row]
        }
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let subHeight = cell.frame.size.height/3
        
        let leftButton = cell.leftButton
  //      leftButton=CellButton(frame: CGRectMake(0, cell.frame.size.height-subHeight, cell.frame.size.width/3, subHeight))
        leftButton.row = indexPath.row
        leftButton.section = indexPath.section
        leftButton.cellName = cell.textLabel.text
        leftButton.backgroundColor = greenColor
        leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(leftButton)
        
        let middleButton = cell.middleButton
 //       middleButton=CellButton(frame: CGRectMake(cell.frame.size.width/3, cell.frame.size.height-subHeight, cell.frame.size.width/3, subHeight))
        middleButton.row = indexPath.row
        middleButton.section = indexPath.section
        middleButton.cellName = cell.textLabel.text!
        middleButton.backgroundColor = orangeColor
        middleButton.addTarget(self, action: "middleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(middleButton)
        
        
        let rightButton = cell.rightButton
//        rightButton=CellButton(frame: CGRectMake(cell.frame.size.width/3*2, cell.frame.size.height-subHeight, cell.frame.size.width/3, subHeight))
        rightButton.row = indexPath.row
        rightButton.section = indexPath.section 
        rightButton.cellName = cell.textLabel.text!
        rightButton.backgroundColor = yellowColor
        rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(rightButton)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = ""
        if indexPath.section == 0 {
            let selectedItem = topItems[indexPath.row]
        }else {
            let selectedItem = bottomItems[indexPath.row]
        }
    }
    
    func leftButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor .blackColor()){
            button.backgroundColor = greenColor
            buttonPressed("LEFT", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor .blackColor()
            buttonPressed("LEFT", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    func middleButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor .blackColor()){
            button.backgroundColor = orangeColor
            buttonPressed("MIDDLE", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor .blackColor()
            buttonPressed("MIDDLE", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    func rightButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor .blackColor()){
            button.backgroundColor = yellowColor
            buttonPressed("RIGHT", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor .blackColor()
            buttonPressed("RIGHT", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    
    func buttonPressed(button: NSString, on: NSString, cell:NSString, row:Int, section:Int) {
        
        //1 get references
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedContext)
        
        let activity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext) as Activity
        
        //3
        activity.setValue(cell, forKey: "name")
        activity.setValue(button, forKey:"character")
        activity.setValue(on, forKey:"finished")
        activity.setValue(row, forKey:"row")
        activity.setValue(section, forKey:"section")
        
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        //5
        activities.append(activity)
        
    }
    
}

