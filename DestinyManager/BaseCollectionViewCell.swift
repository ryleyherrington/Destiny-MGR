//
//  BaseCollectionViewCell.swift
//  Destiny Checker
//
//  Created by Herrington, Ryley on 1/18/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
//    let greenColor  = UIColor (red: 51.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
//    let orangeColor = UIColor (red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1)
//    let yellowColor = UIColor (red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.grayColor()
        
        let subHeight = frame.size.height/3
        
        let textFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: subHeight)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(20.0)
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
//        
//        var leftButton=UIButton(frame: CGRectMake(0, frame.size.height-subHeight, frame.size.width/3, subHeight))
//        leftButton.backgroundColor = greenColor
//        leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        contentView.addSubview(leftButton)
//        
//        var middleButton=UIButton(frame: CGRectMake(frame.size.width/3, frame.size.height-subHeight, frame.size.width/3, subHeight))
//        middleButton.backgroundColor = orangeColor
//        middleButton.addTarget(self, action: "middleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        contentView.addSubview(middleButton)
//        
//        var rightButton=UIButton(frame: CGRectMake(frame.size.width/3*2, frame.size.height-subHeight, frame.size.width/3, subHeight))
//        rightButton.backgroundColor = yellowColor
//        rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
//        contentView.addSubview(rightButton)
//        
    }
//    
//    func leftButtonAction(sender:UIButton!) {
//        var button:UIButton = sender
//        if (button.backgroundColor == UIColor .blackColor()){
//            button.backgroundColor = greenColor
//            buttonPressed("LEFT", on: true)
//        } else{
//            button.backgroundColor = UIColor .blackColor()
//            buttonPressed("LEFT", on: false)
//        }
//    }
//    
//    func middleButtonAction(sender:UIButton!) {
//        var button:UIButton = sender
//        if (button.backgroundColor == UIColor .blackColor()){
//            button.backgroundColor = orangeColor
//            buttonPressed("MIDDLE", on: true)
//        } else{
//            button.backgroundColor = UIColor .blackColor()
//            buttonPressed("MIDDLE", on: false)
//        }
//    }
//    
//    func rightButtonAction(sender:UIButton!) {
//        var button:UIButton = sender
//        if (button.backgroundColor == UIColor .blackColor()){
//            button.backgroundColor = yellowColor
//            buttonPressed("RIGHT", on: true)
//        } else{
//            button.backgroundColor = UIColor .blackColor()
//            buttonPressed("RIGHT", on: false)
//        }
//    }
//   
}
