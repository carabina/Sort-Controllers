//
//  SKSGroupSortController.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/25/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import Foundation


//MARK: Groups Sort Controller
class SKSGroupSortController: NSObject, SKSSortController {
    
    var name: String { return "Groups" }
    
    var hasOptions: Bool { return true }
    
    var accedent: Bool = true
    
    var options: [SKSOption]?
    
    var selectedOption: SKSOption?
    
    
    override init(){
        let option1 = SKSOption(name: "Sort Group Members By", choices: ["Date Created", "Titles"])
        option1.selectedChoice = 0
        
        self.options = [option1]
    }
    
    func sort(objects: [SKSSortableObject]) -> [SKSSection] {
        var tempSections: [SKSSection] = []
        
        let option1 = self.options![0]
        let sortedObjects = option1.selectedChoice! == 0 ? self.sortByTheirDate(objects) : self.sortAlphabeticly(objects)
        
        
        for object in sortedObjects {
            let index = indexofSectionMatchesGroupName(object.sks_groupName!, inSections: tempSections)
            if index == NSNotFound {
                let newSection = SKSSection()
                newSection.title = object.sks_groupName!
                newSection.objects.append(object)
                
                tempSections.append(newSection)
            } else {
                let section = tempSections[index]
                section.objects.append(object)
            }
        }
        
        return tempSections
    }
    
    private func sortAlphabeticly(objects: [SKSSortableObject]) -> [SKSSortableObject] {
        return objects.sort {
            if accedent { return $0.sks_text! < $1.sks_text! } else { return $0.sks_text! > $1.sks_text! }
        }
    }
    
    private func sortByTheirDate(objects: [SKSSortableObject]) -> [SKSSortableObject] {
        return objects.sort {
            if self.accedent { return $0.sks_dateCreated < $1.sks_dateCreated } else { return $1.sks_dateCreated > $0.sks_dateCreated }
        }
    }
    
    private func indexofSectionMatchesGroupName(groupName: String, inSections sections: [SKSSection]) -> Int {
        
        for (index, section) in sections.enumerate() {
            if section.title == groupName {
                return index
            }
        }
        
        return NSNotFound
    }
}