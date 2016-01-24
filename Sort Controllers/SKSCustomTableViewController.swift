//
//  SKSCustomTableViewController.swift
//  Sort Controllers
//
//  Created by Hussein Ryalat on 1/24/16.
//  Copyright © 2016 Sketch Studio. All rights reserved.
//

import UIKit

func getAllObjects() -> [CustomObject]{
    
    let feb2016 = NSDate(year: 2015, month: 2, day: 28)
    let oct2014 = NSDate(year: 2014, month: 10, day: 25)
    let aug1999 = NSDate(year: 1999, month: 8, day: 17)
    let apr2012 = NSDate(year: 2012, month: 4, day: 20)
    let sep2014 = NSDate(year: 2014, month: 9, day: 1)
    let jan2014 = NSDate(year: 2014, month: 1, day: 16)
    
    let personal1 = CustomObject(title: "Hello?", inGroup: "Personal", at: feb2016)
    let personal2 = CustomObject(title: "This is a private note!", inGroup: "Personal", at: apr2012)
    let personal3 = CustomObject(title: "Hussein Saleh Tawfeeq Al-Ryalat, That's my name", inGroup: "Personal", at: aug1999)
    let personal4 = CustomObject(title: "I love the Alizarin Color!", inGroup: "Personal", at: sep2014)
    let personal5 = CustomObject(title: "what sort type do you prefer?", inGroup: "Personal", at: aug1999)
    let personal6 = CustomObject(title: "Wolfs..", inGroup: "Personal", at: oct2014)
    let personal7 = CustomObject(title: "Beep!", inGroup: "Personal", at: sep2014)
    
    
    let sortersProject1 = CustomObject(title: "This library designed for tableviews!", inGroup: "Sorters Project")
    let sortersProject2 = CustomObject(title: "Tip: you can create your own sort controllers!", inGroup: "Sorters Project")
    let sortersProject3 = CustomObject(title: "do you like this library ?", inGroup: "Sorters Project", at: apr2012)
    let sortersProject4 = CustomObject(title: "Do you know how to use it??", inGroup: "Sorters Project", at: sep2014)
    let sortersProject5 = CustomObject(title: "Making the object sortable is easy, right ?", inGroup: "Sorters Project", at: apr2012)
    let sortersProject6 = CustomObject(title: "ahhhhhhh, hi !", inGroup: "Sorters Project", at: feb2016)
    let sortersProject7 = CustomObject(title: "Another Beep?", inGroup: "Sorters Project", at: aug1999)
    let sortersProject8 = CustomObject(title: "contact me at hussein75r@gmail.com", inGroup: "Sorters Project", at: feb2016)

    let wishes1 = CustomObject(title: "I wish I can be stronger..", inGroup: "Wishes")
    let wishes2 = CustomObject(title: "and I wish I can be faster", inGroup: "Wishes", at: aug1999)
    let wishes3 = CustomObject(title: "Smarter? Yep!", inGroup: "Wishes", at: apr2012)
    let wishes4 = CustomObject(title: "to Help people!", inGroup: "Wishes", at: sep2014)
    let wishes5 = CustomObject(title: "to improve this library", inGroup: "Wishes", at: jan2014)
    let wishes6 = CustomObject(title: "your custom wish here..", inGroup: "Wishes", at: jan2014)
    let wishes7 = CustomObject(title: "I wish to beep!", inGroup: "Wishes", at: jan2014)
    let wishes8 = CustomObject(title: "Good?", inGroup: "Wishes", at: apr2012)
    
    return [personal1, personal2,personal3,personal4,personal5,personal6, personal7] + [sortersProject1, sortersProject2, sortersProject3, sortersProject4, sortersProject5, sortersProject6, sortersProject7, sortersProject8, wishes1, wishes2, wishes3, wishes4, wishes5, wishes6, wishes7, wishes8]
}

class SKSCustomTableViewController: UITableViewController {
    
    var sortController: SKSSortController!
    
    var sections: [SKSSection]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        /* sorting objects as easy as this! */
        sortController = SKSDateSortController()
        sections = sortController.sort(getAllObjects())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sort(sender: AnyObject) {
        /* toggle the sort controller.. */
        
        let vc = SKSSortViewController(sortController: self.sortController)
        vc.delegate = self
        
        //prepare what types of sorts we want to include
        vc.sortControllers = [SKSDateSortController(), SKSAlphabeticSortController(), SKSStringSortController(), SKSNoneSortController()]
        
        let navigationController = UINavigationController(rootViewController: vc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].objects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = objectAtIndexPath(indexPath, inSections: sections) as! CustomObject
        
        // Configure the cell...
        cell.textLabel?.text = object.title
        cell.detailTextLabel?.text = object.dateCreated.toMediumString()
        

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionObject = self.sections![section]
        let header = tableView.dequeueReusableCellWithIdentifier("Header")
        
        let label = header?.viewWithTag(1) as! UILabel
        label.text = (sectionObject.title as NSString).uppercaseString

        
        return header
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    


    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension SKSCustomTableViewController: SKSSortViewControllerDelegate {
    func sortViewController(sender: SKSSortViewController, didFinishPickingSortController sortController: SKSSortController) {
        
        self.sortController = sortController
        sections = sortController.sort(getAllObjects())
        
        dismissViewControllerAnimated(true) { () -> Void in
            self.tableView.reloadData()
        }
    }
    
    func sortViewControllerDidCancel(sender: SKSSortViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
