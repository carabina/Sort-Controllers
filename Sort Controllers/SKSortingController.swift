//
//  SKSortingController.swift
//  Popsicle
//
//  Created by Hussein Ryalat on 12/30/15.
//  Copyright © 2015 Sketch Studio. All rights reserved.
//

import Foundation



//MARK: Helper methods


func objectAtIndexPath(indexPath: NSIndexPath, inSections sections: [SKSSection]) -> SKSSortableObject? {
    
    if indexPath.section >= sections.count || indexPath.section < 0 { return nil }
    
    let section = sections[indexPath.section]
    
    if indexPath.row >= section.objects.count || indexPath.row < 0 { return nil }
        
    return section.objects[indexPath.row]
}


//MARK: SKSSortController

/**
    A Sort controller is the heart of the whole library, a sort controller is used to sort a number of unordered objects, then package them into sections, in an organized order..
    
    This is the base protocol to implement the sort controller, each sort controller
*/
@objc protocol SKSSortController: NSObjectProtocol {
    
    /* the name of the sorting method used, human readable. */
    var name: String { get }
    
    /* the sort controller uses a custom options or not ? */
    var hasOptions: Bool { get }
    
    /* e.g: First then Last, or Last then First*/
    var accedent: Bool { get set }
    
    /* optionally, provides options when sorting ( more details if needed ), can be nil. */
    var options: [SKSOption]? { get set }
    
    /* the selected option from options in the sorter, can be nil. */
    var selectedOption: SKSOption? { get set }
    
    /* just call this method with the objects you want to sort, it will return them in an organized packages ( sections ). */
    func sort(objects: [SKSSortableObject]) -> [SKSSection]
    
    /* Supporting icon images.. */
    optional var iconName: String? { get }
}



//MARK: SKSOption

/**
    An option object is what you see here, can be used by the sort controllers to configure the sort operation, each option is created using a number of choices, and a name..

    This object is used for when choosing the right SortController by the user or the app itself.

*/
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
    init(name: String, choices: [String]) {
        self.name = name
        self.choices = choices
        
        if choices.count > 0 {
            self.defaultChoice = self.choices[0]
            self.selectedChoice = 0
        }
        
        super.init()
    }
}

//MARK: SKSSection

/**
    the section is a group of sorted objects, each section object represent a section in a table or a collection.

*/
class SKSSection: NSObject {
    var title: String
    var objects: [SKSSortableObject]
    
    override init(){
        self.objects = [SKSSortableObject]()
        self.title = ""
    }
    
    override var description: String {
        return "\(title)"
    }
}


//MARK: SKSSortableObject

/**

    The base protocol to adopt for all of your sortable objects, by conforming to this protocol, your object can be sorted by one of the sort controllers.

    Each sort controller uses different attribute for sorting, for example, if you want to sort the objects by their date created ( typically you use SKSDateSortController ) you should implement sks_dateCreated on your object.

*/
@objc protocol SKSSortableObject: NSObjectProtocol {
    
    /* used by the string sort controller. */
    optional var sks_text: String { get }
    
    /* used by the date sort controller. */
    optional var sks_dateCreated: NSDate { get }
    
    
    optional var sks_dateModifited: NSDate { get }
    
    /* used by the group sort controller*/
    optional var sks_groupName: String { get }    
}



