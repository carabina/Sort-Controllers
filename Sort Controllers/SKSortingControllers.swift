//
//  SKSortingController.swift
//  Popsicle
//
//  Created by Hussein Ryalat on 12/30/15.
//  Copyright © 2015 Sketch Studio. All rights reserved.
//

import Foundation

/* SKSSorter defines the basic and generic behavior for all sorters in the Sort Controllers. */

func sortControllerForName(name: String) -> SKSSortController? {
    let controllers: [SKSSortController] = [SKSDateSortController(), SKSAlphabeticSortController(), SKSGroupsSortController(), SKSNoneSortController()]
    for controller in controllers {
        if controller.name == name {
            return controller
        }
    }
    
    print("found nil for name: \(name)")
    
    return nil
}

func sortControllerNames() -> [String] {
    let controllers: [SKSSortController] = [SKSDateSortController(), SKSAlphabeticSortController(), SKSGroupsSortController(), SKSNoneSortController()]
    return controllers.map { return $0.name }
}

//MARK: SKSSortController
protocol SKSSortController: NSObjectProtocol {
    
    /* 
        WARNING: Any changes here will not affect the sorted objects, instead
            you have to resort the objects again to commit changes.
    */
    
    /* the name of the sorting method used, human readable. */
    var name: String { get }
    
    /* specifies wether this mainfist provides options for sorting or not */
    var hasOptions: Bool { get }
    
    /* wether to sort accedent or not.*/
    var accedent: Bool { get set }
    
    /* optionally, provides options when sorting ( more details if needed ), can be nil. */
    var options: [SKSOption]? { get set }
    
    /* the selected option from options in the sorter, can be nil. */
    var selectedOption: SKSOption? { get set }
    
    func sort(objects: [SKSSortableObject])
    func objectAtIndexPath(indexPath: NSIndexPath) -> SKSSortableObject?
    
    
    /* Sorted Objects Interface.. */
    
    var sections: [SKSSection<SKSSortableObject>]? { set get }
    
    /* Supporting icon images.. */
    var iconName: String? { get }
}


//MARK: SKSOption
class SKSOption: NSObject {
    
    /* name of the option, human readable.*/
    var name: String
    
    /* choices that the option provides. */
    var choices: [String]
    
    /* the default choice for the option ( pre-selected ). */
    var defaultChoice: String?
    
    /* the selected choice of the given choices.*/
    var selectedChoice: Int?
    
    /* creates and initializes options object. */
    init(name: String, options: [String]) {
        self.name = name
        self.choices = options
        
        if choices.count > 0 {
            self.defaultChoice = self.choices[0]
            self.selectedChoice = 0
        }
        
        super.init()
    }
}

//MARK: SKSSection
class SKSSection<T>: NSObject {
    var title: String?
    var objects: [T]?
    
    override init(){
        self.objects = [T]()
        self.title = ""
    }
    
    override var description: String {
        return "\(title)"
    }
}


//MARK: SKSSortableObject
@objc
protocol SKSSortableObject: NSObjectProtocol {
    
    /* used by the string sort controller. */
    optional var sks_text: String { get }
    
    /* used by the date sort controller. */
    optional var sks_dateCreated: NSDate { get }
    
    optional var sks_dateModifited: NSDate { get }
    
    /* used by the group sort controller*/
    optional var sks_groupName: String { get }    
}

/********************* Default Sorters *******************/


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
        let option1 = SKSOption(name: "Sort By", options: ["Years", "Monthes"])
        option1.selectedChoice = 1
        
        let option2 = SKSOption(name: "Date Type", options: ["Date Created","Date Modifited"])
        option2.selectedChoice = 0
        
        self.options = [option1, option2]
        self.accedent = true
        
        
        
        super.init()
    }
    
    func sectionForDateComponent(sections: [SKSSection<SKSSortableObject>] , component: Int) -> Int {
        for (index, section) in sections.enumerate() {
            if Int(section.title!)! == component {
                return index
            }
        }
        
        return -1
    }
    
    func nameForMonth(month: Int) -> String {
        return NSDate(year: 2016, month: month, day: 3).monthName
    }
    
    func sort(objects: [SKSSortableObject]) {
        /* all of the work goes here.. */
        var tempSections = [SKSSection<SKSSortableObject>]()
        
        var selectedDateType = self.options![1].selectedChoice!
        
        func dateComponent(component: Int, existsInSections sections: [SKSSection<SKSSortableObject>]) -> Bool {
            for section in sections {
                if section.title == "\(component)" {
                    return true
                }
            }
            
            return false
        }
        
        
        /* first, let's make sure all the objects is sorted by their date created.. */
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
            let DC: Int = (options![0].selectedChoice == 0 ? dateForType!.year : dateForType!.month)
            
            if !dateComponent(DC, existsInSections: tempSections){
                /* if the object year is not exists, so create a new section with the given year.. */
                
                let newSection = SKSSection<SKSSortableObject>()
                newSection.objects?.append(object)
                newSection.title = "\(DC)"
                
                tempSections.append(newSection)
            } else {
                let section = sectionForDateComponent(tempSections, component: DC)
                tempSections[section].objects?.append(object)
            }
        }
        
        
        /* Number one we need to split them into sections, depending on the option provided..*/
        switch options![0].selectedChoice! {
            case 1 /* "Monthes" */ :
                
                /* translating monthe index to name. */
                for section in tempSections {
                    let month = Int(section.title!)
                    section.title = nameForMonth(month!)
                }
            break
        default:
            break
        }
        
        self.sections = tempSections
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> SKSSortableObject? {
        if indexPath.section >= sections?.count || indexPath.section < 0 { return nil }
        
        if let section = sections?[indexPath.section] {
            if indexPath.row >= section.objects?.count || indexPath.row < 0 { return nil }
            
            return section.objects?[indexPath.row]
        }
        
        return nil
    }
    
    var sections: [SKSSection<SKSSortableObject>]?
}

//MARK: Alphabetic Sorting Controller

class SKSAlphabeticSortController: NSObject, SKSSortController {
    
    var name: String { return "Alphabetic Sort" }
    
    var hasOptions: Bool { return false }
    
    var accedent: Bool = true
    
    var options: [SKSOption]?
    
    var selectedOption: SKSOption?
    
    var iconName: String? {
        return "alphabetic_sort"
    }
    
    func sort(objects: [SKSSortableObject]){
        var tempSections = [SKSSection<SKSSortableObject>]()
        
        let sortedObjects = objects.sort {
            if accedent { return $0.sks_text! < $1.sks_text! } else { return $0.sks_text! > $1.sks_text! }
        }
        
        for object in sortedObjects {
            let firstCharacter = object.sks_text!.characters.first
            if character(firstCharacter!, containedInSections: tempSections){
                let sectionIndex = sectionIndexWithTitle("\(firstCharacter!)", containedInSections: tempSections)
                let section = tempSections[sectionIndex]
                
                section.objects?.append(object)
            } else {
                let newSection = SKSSection<SKSSortableObject>()
                newSection.title = "\(firstCharacter!)"
                newSection.objects?.append(object)
                
                tempSections.append(newSection)
            }
        }
        
        self.sections = tempSections
    }
    
    func character(character: Character, containedInSections sections: [SKSSection<SKSSortableObject>]) -> Bool {
        
        for section in sections {
            if section.title == "\(character)" {
                return true
            }
        }
        
        return false
    }
    
    func sectionIndexWithTitle(title: String, containedInSections sections: [SKSSection<SKSSortableObject>]) -> Int {
        
        for (index, section) in sections.enumerate() {
            if section.title == title {
                return index
            }
        }
        
        return -1
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> SKSSortableObject? {
        if indexPath.section >= sections?.count || indexPath.section < 0 { return nil }
        
        if let section = sections?[indexPath.section] {
            if indexPath.row >= section.objects?.count || indexPath.row < 0 { return nil }
            
            return section.objects?[indexPath.row]
        }
        
        return nil
    }
    
    
    var sections: [SKSSection<SKSSortableObject>]?
}

//MARK: Groups Sort Controller
class SKSGroupsSortController: NSObject, SKSSortController {
    
    var name: String { return "Groups Sort" }
    
    var hasOptions: Bool { return true }
    
    var accedent: Bool = true
    
    var options: [SKSOption]?
    
    var selectedOption: SKSOption?
    
    var sections: [SKSSection<SKSSortableObject>]?
    
    var iconName: String? {
        return "groups"
    }
    
    override init(){
        let option1 = SKSOption(name: "Sort Group Members By", options: ["Date Created", "Titles"])
        option1.selectedChoice = 0
        
        self.options = [option1]
    }
    
    func sort(objects: [SKSSortableObject]) {
        var tempSections: [SKSSection<SKSSortableObject>] = []
        
        let option1 = self.options![0]
        let sortedObjects = option1.selectedChoice! == 0 ? self.sortByTheirDate(objects) : self.sortAlphabeticly(objects)

        
        for object in sortedObjects {
            let index = indexofSectionMatchesGroupName(object.sks_groupName!, inSections: tempSections)
            if index == NSNotFound {
               let newSection = SKSSection<SKSSortableObject>()
                newSection.title = object.sks_groupName!
                newSection.objects?.append(object)
                
                tempSections.append(newSection)
            } else {
                let section = tempSections[index]
                section.objects?.append(object)
            }
        }
        
        self.sections = tempSections
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

    private func indexofSectionMatchesGroupName(groupName: String, inSections sections: [SKSSection<SKSSortableObject>]) -> Int {
        
        for (index, section) in sections.enumerate() {
            if section.title == groupName {
                return index
            }
        }
        
        return NSNotFound
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> SKSSortableObject? {
        if indexPath.section >= sections?.count || indexPath.section < 0 { return nil }
        
        if let section = sections?[indexPath.section] {
            if indexPath.row >= section.objects?.count || indexPath.row < 0 { return nil }
            
            return section.objects?[indexPath.row]
        }
        
        return nil
    }
}

//MARK: None Sort Controller

class SKSNoneSortController: NSObject, SKSSortController {

    var name: String { return "None" }
    var iconName: String? { return "empty_trash" }
    
    var hasOptions: Bool { return false }
    var accedent: Bool = false
    
    var options: [SKSOption]?
    var selectedOption: SKSOption?
    
    var sections: [SKSSection<SKSSortableObject>]?
    
    func sort(objects: [SKSSortableObject]) {
        let section = SKSSection<SKSSortableObject>()
        section.objects = objects
        section.title = ""
        
        self.sections = [section]
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> SKSSortableObject? {
        return self.sections![0].objects![indexPath.row]
    }
}
