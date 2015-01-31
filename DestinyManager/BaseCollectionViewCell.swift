//
//  BaseCollectionViewCell.swift
//  Destiny Checker
//
//  Created by Herrington, Ryley on 1/18/15.
//  Copyright (c) 2015 Herrington. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell{
    
    var numberOfButtons:Int = 0
    var leftButton: CellButton!
    var middleButton: CellButton!
    var rightButton: CellButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
    let greenColor  = UIColor (red: 51.0/255.0, green: 102.0/255.0, blue: 0.0/255.0, alpha: 1)
    let orangeColor = UIColor (red: 255.0/255.0, green: 153.0/255.0, blue: 0.0/255.0, alpha: 1)
    let yellowColor = UIColor (red: 255.0/255.0, green: 204.0/255.0, blue: 0.0/255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.75)
        
        let subHeight = frame.size.height/3
        
        let textFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: subHeight)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(22.0)
        textLabel.textAlignment = .Center
        textLabel.textColor = UIColor.whiteColor()
        contentView.addSubview(textLabel)
        
        leftButton=CellButton(frame: CGRectMake(0, frame.size.height-subHeight, frame.size.width/3, subHeight))
        leftButton.backgroundColor = greenColor
        //leftButton.addTarget(self, action: "leftButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(leftButton)
        
        middleButton=CellButton(frame: CGRectMake(frame.size.width/3, frame.size.height-subHeight, frame.size.width/3, subHeight))
        middleButton.backgroundColor = orangeColor
        //middleButton.addTarget(self, action: "middleButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(middleButton)
        
        rightButton=CellButton(frame: CGRectMake(frame.size.width/3*2, frame.size.height-subHeight, frame.size.width/3, subHeight))
        rightButton.backgroundColor = yellowColor
        //rightButton.addTarget(self, action: "rightButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        contentView.addSubview(rightButton)
        
    }
    
}
