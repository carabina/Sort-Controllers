//
//  SKSDateSortControllers.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/24/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import Foundation

/* Date Sort Controller, sorts the objects depending on their dates.. */
class SKSDateSortController: NSObject, SKSSortController {
    
    enum DateSortOptions: Int {
        case Years = 0, Monthes = 1
    }
    
    
    var name: String { return "Date Sort" }
    
    var hasOptions: Bool { return true }
    
    var accedent: Bool = true
    
    var options: [SKSOption]?
    
    var selectedOption: SKSOption?
    
    var iconName: String? {
        return "date_sort"
    }
    
    func setSortBy(component: DateSortOptions){
        let option = self.options![0]
        option.selectedChoice = component.rawValue
    }
    
    func setSortByModificationDate(){
        let option = self.options![1]
        option.selectedChoice = 0
    }
    
    func setSortByCreationDate(){
        let option = self.options![1]
        option.selectedChoice = 1
    }
    
    override init(){
        /* Setting default values */
        let option1 = SKSOption(name: "Sort By", choices: ["Years", "Monthes"])
        option1.selectedChoice = 1
        
        let option2 = SKSOption(name: "Date Type", choices: ["Date Created","Date Modifited"])
        option2.selectedChoice = 0
        
        self.options = [option1, option2]
        self.accedent = true
        
        
        
        super.init()
    }
    
    
    func sectionIndexForName(name: String, inSections sections: [SKSSection]) -> Int {
        for (index, section) in sections.enumerate() {
            if section.title == name {
                return index
            }
        }
        
        return -1
    }
    
    func nameForMonth(month: Int, inYear year: Int) -> String {
        return "\(NSDate(year: year, month: month, day: 3).monthName) in \(year)"
    }
    
    func sort(objects: [SKSSortableObject]) -> [SKSSection]{
        /* all of the work goes here.. */
        var tempSections = [SKSSection]()
        
        var selectedDateType = self.options![1].selectedChoice!
        
        func sectionName(sectionName: String, existsInSections sections: [SKSSection]) -> Bool {
            for section in sections {
                if section.title == sectionName {
                    return true
                }
            }
            
            return false
        }

        
        /* first, let's make sure all the objects is sorted by their date.. */
        let sortedObjects = objects.sort { (object1, object2) -> Bool in
            if self.accedent {
                return selectedDateType == 0 ? object1.sks_dateCreated > object2.sks_dateCreated : object1.sks_dateModifited > object2.sks_dateModifited
            } else {
                return selectedDateType == 0 ? object1.sks_dateCreated < object2.sks_dateCreated : object1.sks_dateModifited < object2.sks_dateModifited
            }
        }
        
        for object in sortedObjects {
            /* 0 means years, 1 means monthes. */
            let dateForType = selectedDateType == 0 ? object.sks_dateCreated : object.sks_dateModifited
            let generatedSectionName = options![0].selectedChoice == 0 ? "\(dateForType!.year)" : "\(dateForType!.monthName) \(dateForType!.year)"
            
            let index = sectionIndexForName(generatedSectionName, inSections: tempSections)
            
            if index == -1 {
                /* if the object year is not exists, so create a new section with the given year.. */
                
                let newSection = SKSSection()
                newSection.objects.append(object)
                newSection.title = generatedSectionName
                
                tempSections.append(newSection)
            } else {
                let section = tempSections[index]
                section.objects.append(object)
            }
        }
        
        return tempSections
    }
    
}
