//
//  SKSNoneSortController.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/24/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import Foundation

class SKSNoneSortController: NSObject, SKSSortController {
    
    var name: String { return "None" }
    var iconName: String? { return nil }
    
    var hasOptions: Bool { return false }
    var accedent: Bool = false
    
    var options: [SKSOption]?
    var selectedOption: SKSOption?
    
    func sort(objects: [SKSSortableObject]) -> [SKSSection] {
        let section = SKSSection()
        section.objects = objects
        section.title = ""
        
        return [section]
    }
}