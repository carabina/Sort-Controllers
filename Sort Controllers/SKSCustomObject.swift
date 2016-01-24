//
//  SKSCustomObject.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/24/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import UIKit

class CustomObject: NSObject {
    
    var title: String
    
    var dateCreated: NSDate
    
    var dateModifited: NSDate
    
    var group: String
    
    convenience init(title: String, inGroup group: String) {
        self.init(title: title, inGroup: group, at: NSDate())
    }
    
    init(title: String, inGroup group: String, at: NSDate) {
        self.title = title
        self.dateCreated = at
        self.dateModifited = NSDate()
        self.group = group
        
        super.init()
    }
    
    func update(){
        self.dateModifited = NSDate()
    }
}

//Making the object sortable..
extension CustomObject: SKSSortableObject {
    
    var sks_text: String { return self.title }
    
    var sks_dateCreated: NSDate { return self.dateCreated }
    
    var sks_dateModifited: NSDate { return self.dateModifited }
    
    var sks_groupName: String { return self.group }
}