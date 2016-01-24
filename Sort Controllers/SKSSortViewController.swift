//
//  SKSortFilterViewController.swift
//  Popsicle
//
//  Created by Hussein Ryalat on 1/11/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import UIKit


//MARK: Delegate
protocol SKSSortViewControllerDelegate: NSObjectProtocol {
    
    func sortViewController(sender: SKSSortViewController, didFinishPickingSortController: SKSSortController)
    
    func sortViewControllerDidCancel(sender: SKSSortViewController)
    
}

class SKSSortViewController: UITableViewController {
    
    var sortControllers: [SKSSortController]! = []
    
    var selectedSortController: SKSSortController?
    
    var disabledSortControllersIndexes: [Int] = []
    
    weak var delegate: SKSSortViewControllerDelegate?
    
    init(sortController: SKSSortController){
        self.selectedSortController = sortController
        
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for disabledIndex in self.disabledSortControllersIndexes {
            self.sortControllers.removeAtIndex(disabledIndex)
        }
        
        if self.selectedSortController == nil {
            self.selectedSortController = sortControllers[0]
        }
        
        let doneItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "donePicking")
        self.navigationItem.rightBarButtonItem = doneItem
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancelPicking")
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var staticSectionsCount = 2 /* By defualt, there is two sections. */
        if self.selectedSortController?.hasOptions == true {
            staticSectionsCount++
        }
        
        return staticSectionsCount
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { /* list of sort methods that available */
            return self.sortControllers.count
        } else if section == 1 { /* generic options for all sort methods*/
            return 1
        } else if section == 2 { /* custom defined methods by the sort controller */
            if let controller = self.selectedSortController {
                return controller.options!.count
            }
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Sort By:"
        } else if section == 1 {
            return "Options:"
        } else if section == 2 {
            return "Another Options"
        }
        
        return ""
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("SortByCell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "SortByCell")
            }
            
            let sortController = self.sortControllers[indexPath.row]
            cell!.textLabel?.text = sortController.name
            cell!.accessoryType = .None
            
            if sortController.name == self.selectedSortController?.name {
                cell!.accessoryType = .Checkmark
            }
            
            return cell!
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCellWithIdentifier("SortByCell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "SortByCell")
            }
            

            cell!.textLabel?.text = "Sort By Accedent"
            if self.selectedSortController!.accedent {
                cell!.accessoryType = .Checkmark
            } else {
                cell!.accessoryType = .None
            }
            
            return cell!
        } else if indexPath.section == 2 {
            /* the controller should provide options, the section 2 is for them. */
            let option = self.selectedSortController!.options![indexPath.row]
            var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("OptionCell")
            
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: "OptionCell")
            }
            
            cell?.textLabel?.text = option.name
            cell?.detailTextLabel?.text = option.choices[option.selectedChoice!]
            cell?.accessoryType = .DisclosureIndicator
                        
            return cell!
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            /* update the selected sort controller */
            self.selectedSortController = self.sortControllers[indexPath.row]
            tableView.reloadData()
        } else if indexPath.section == 1 {
            self.selectedSortController!.accedent = !self.selectedSortController!.accedent
            self.tableView.reloadData()
        } else if indexPath.section == 2 {
            /* */
            selectedSortController?.selectedOption = selectedSortController!.options?[indexPath.row]
            
            let optionsVC = SKOptionsTableViewController(style: .Grouped)
            optionsVC.option = selectedSortController!.options?[indexPath.row]
            
            self.navigationController?.pushViewController(optionsVC, animated: true)
        }
    }
    
    //MARK: Actions
    func donePicking(){
        self.delegate?.sortViewController(self, didFinishPickingSortController: self.selectedSortController!)
    }
    
    func cancelPicking(){
        self.delegate?.sortViewControllerDidCancel(self)
    }
}

//MARK: Options
class SKOptionsTableViewController: UITableViewController {
    
    var option: SKSOption!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        
        cell?.textLabel?.text = option.choices[indexPath.row]
        cell?.accessoryType = .None
        
        if option.choices[indexPath.row] == option.choices[option.selectedChoice!] {
            cell?.accessoryType = .Checkmark
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return option.choices.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return option.name
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.option.selectedChoice = indexPath.row
        self.tableView.reloadData()
        
    }
}