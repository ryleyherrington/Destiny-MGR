//??
//  DataViewController.swift
//  PagerProject
//
//  Created by Herrington, Ryley on 1/19/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import UIKit
import CoreData

class DataViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
  
    var collectionView: UICollectionView?
    var dataObject: AnyObject?
    var type: String? //TODO: this needs a better fucking name
    var topItems = [String]()
    var bottomItems = [String]()
    var activities = [Activity]()
    var completedActivities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        collectionView!.backgroundColor = UIColor.clearColor()
        var backgroundImage:UIImage = UIImage(named: "stars.jpg")!
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //        blurView.frame = backgroundImage
        
        self.view.backgroundColor = UIColor(patternImage: backgroundImage)
        
        self.view.addSubview(collectionView!)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if (PlayerInfo.lastLoadedPlayer() == nil) {
            //present the login view modally
            let loginController = UIStoryboard(name: "Main",
                bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(LoginViewController.StoryboardIdentifier) as! LoginViewController
            
            presentViewController(loginController, animated: true, completion: nil)
        } else {
            //TODO: start the spinner and load our data
            println("Load all our info here")
            
            loadData()
        }
    }
    
    func loadData() {
        
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
        
        getActivities()
    }
   
    
    
    func getActivities(){
        //1
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
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
                        println("activity == NO BRO")
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BaseCollectionViewCell", forIndexPath: indexPath) as! BaseCollectionViewCell
        if indexPath.section == 0 {
            cell.textLabel.text = self.topItems[indexPath.row]
        }else {
            cell.textLabel.text = self.bottomItems[indexPath.row]
        }
       
        
        cell.leftButton.row = indexPath.row
        cell.leftButton.section = indexPath.section
        cell.leftButton.cellName = cell.textLabel.text
        
        cell.leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.middleButton.row = indexPath.row
        cell.middleButton.section = indexPath.section
        cell.middleButton.cellName = cell.textLabel.text!
        cell.middleButton.addTarget(self, action: "middleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.rightButton.row = indexPath.row
        cell.rightButton.section = indexPath.section
        cell.rightButton.cellName = cell.textLabel.text!
        cell.rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
       
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
    
    func leftButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor .blackColor()){
            button.backgroundColor = UIColor.DestinyGreen
            buttonPressed("LEFT", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor .blackColor()
            buttonPressed("LEFT", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    func middleButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor.blackColor()){
            button.backgroundColor = UIColor.DestinyOrange
            buttonPressed("MIDDLE", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor .blackColor()
            buttonPressed("MIDDLE", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    func rightButtonAction(sender:CellButton!) {
        var button:CellButton = sender
        if (button.backgroundColor == UIColor.blackColor()){
            button.backgroundColor = UIColor.DestinyGreen
            buttonPressed("RIGHT", on: "NO", cell:button.cellName, row:button.row, section:button.section)
        } else{
            button.backgroundColor = UIColor.blackColor()
            buttonPressed("RIGHT", on: "YES", cell:button.cellName, row:button.row, section:button.section)
        }
    }
    
    
    func buttonPressed(button: NSString, on: NSString, cell:NSString, row:Int, section:Int) {
        
        //1 get references
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let entity =  NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedContext)
        
        let activity = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext) as! Activity
        
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

