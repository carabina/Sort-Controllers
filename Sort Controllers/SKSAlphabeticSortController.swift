//
//  SKSStringSortControllers.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/24/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import Foundation

class SKSAlphabeticSortController: NSObject, SKSSortController {
    
    var name: String { return "Alphabetic Sort" }
    
    var hasOptions: Bool { return false }
    
    var accedent: Bool = true
    
    
    /* No options for this.. */
    var options: [SKSOption]?
    var selectedOption: SKSOption?
    
    func sort(objects: [SKSSortableObject]) -> [SKSSection]{
        var tempSections = [SKSSection]()
        
        let sortedObjects = objects.sort {
            if accedent { return $0.sks_text! < $1.sks_text! } else { return $0.sks_text! > $1.sks_text! }
        }
        
        for object in sortedObjects {
            let firstCharacter = object.sks_text!.characters.first
            if character(firstCharacter!, containedInSections: tempSections){
                let sectionIndex = sectionIndexWithTitle("\(firstCharacter!)", containedInSections: tempSections)
                let section = tempSections[sectionIndex]
                
                section.objects.append(object)
            } else {
                let newSection = SKSSection()
                newSection.title = "\(firstCharacter!)"
                newSection.objects.append(object)
                
                tempSections.append(newSection)
            }
        }
        
        return tempSections
    }
    
    func character(character: Character, containedInSections sections: [SKSSection]) -> Bool {
        
        for section in sections {
            if section.title == "\(character)" {
                return true
            }
        }
        
        return false
    }
    
    func sectionIndexWithTitle(title: String, containedInSections sections: [SKSSection]) -> Int {
        
        for (index, section) in sections.enumerate() {
            if section.title == title {
                return index
            }
        }
        
        return -1
    }
}
