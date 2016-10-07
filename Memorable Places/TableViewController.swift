//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Lovish Dogra on 18/03/16.
//  Copyright © 2016 Lovish Dogra. All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]
var activePlace = -1

class TableViewController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if places.count == 1 {
            places.remove(at: 0)
            places.append(["name":"Taj Mahal", "lat":"27.175277", "long":"78.042128"])
        }
        
        if UserDefaults.standard.object(forKey: "places") != nil {
            places = UserDefaults.standard.object(forKey: "places") as! Array
        }
        
        tableView.tableFooterView = UIView() //Remove the unused rows from the table view controller.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = places[(indexPath as NSIndexPath).row]["name"]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        activePlace = (indexPath as NSIndexPath).row
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPlace" {
            activePlace = -1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Delete the row from the data source
            places.remove(at: (indexPath as NSIndexPath).row)
            UserDefaults.standard.set(places, forKey: "places")
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        //else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
