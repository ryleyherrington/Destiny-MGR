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
    
    //User Data ... this is a gross implementation
    //Please refactor me in the future
    var type: String?
    var topItems = [String]()
    var bottomItems = [String]()
    
    //Player data
    var activities = [Activity]()
    var completedActivities = [Activity]()
    var player:PlayerInfo? = nil
   
    let greenColor  = UIColor (red: 51.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
    let orangeColor = UIColor (red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1)
    let yellowColor = UIColor (red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if type != nil {
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

//      println("# of characters= \(player?.characters?.count)")
//      println("# of characters= \(player?.characters?[0].characterLevel)")
//      player?.characters?[0].emblemPath
//      player?.characters?[0].backgroundPath
        
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(BaseCollectionViewCell.self, forCellWithReuseIdentifier: "BaseCollectionViewCell")
        collectionView!.backgroundColor = UIColor.clearColor()
        var backgroundImage:UIImage = UIImage(named: "stars.jpg")!
       
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
//      blurView.frame = backgroundImage
        
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
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
            completedActivities = results
            //println("fetched Results:\(results)")
            

        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    func changeButtonColor(cell:BaseCollectionViewCell, ip:NSIndexPath){
        for activity: Activity in completedActivities {
            if Int(activity.row) == ip.row && Int(activity.section) == ip.section {
                if activity.name == cell.textLabel.text{
                    if activity.finished == "NO" {
//                        println("activity == NO BRO")
                    }
                    if activity.character == "LEFT" && cell.leftButton != nil  && activity.finished=="YES" {
                        cell.leftButton.backgroundColor = UIColor.blackColor()
                    }else if activity.character == "MIDDLE" && cell.middleButton != nil  && activity.finished=="YES" {
                        cell.middleButton.backgroundColor = UIColor.blackColor()
                    }else if activity.character == "RIGHT" && cell.rightButton != nil  && activity.finished=="YES" {
                        cell.rightButton.backgroundColor = UIColor.blackColor()
                    }
                }
            }
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
      
        
        var count= player?.characters?.count
        if count != nil{
            switch count
            {
            case 1:
                self .setupOneButton(cell, indexPath: indexPath)
            case 2:
                self .setupTwoButton(cell, indexPath: indexPath)
            case 3:
                self .setupThreeButton(cell, indexPath: indexPath)
            default:
                setupOneButton(cell, indexPath: indexPath)
            }
            
        }
        changeButtonColor(cell, ip:indexPath)
        
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
    
    func setupOneButton(cell:BaseCollectionViewCell, indexPath:NSIndexPath){
        cell.leftButton.row = indexPath.row
        cell.leftButton.section = indexPath.section
        cell.leftButton.cellName = cell.textLabel.text
        cell.leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupTwoButton(cell:BaseCollectionViewCell, indexPath:NSIndexPath){
        self.setupOneButton(cell, indexPath: indexPath)
        
        cell.middleButton.row = indexPath.row
        cell.middleButton.section = indexPath.section
        cell.middleButton.cellName = cell.textLabel.text!
        cell.middleButton.addTarget(self, action: "middleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupThreeButton(cell:BaseCollectionViewCell, indexPath:NSIndexPath){
        self.setupOneButton(cell, indexPath: indexPath)
        self.setupTwoButton(cell, indexPath: indexPath)
        
        cell.rightButton.row = indexPath.row
        cell.rightButton.section = indexPath.section
        cell.rightButton.cellName = cell.textLabel.text!
        cell.rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
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

