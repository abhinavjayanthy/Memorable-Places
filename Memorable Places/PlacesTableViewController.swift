//
//  PlacesTableViewController.swift
//  Memorable Places
//
//  Created by Abhinav Jayanthy on 1/18/17.
//  Copyright © 2017 Abhinav Jayanthy. All rights reserved.
//

import UIKit

var places = [Dictionary<String,String>()]
var activePlace = -1

class PlacesTableViewController: UITableViewController {
    @IBOutlet var tableViewOutlet: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String,String>]{
            places = tempPlaces
        }
        
        if places.count == 1 && places[0].count == 0 {
            
            places.remove(at: 0)
            
            places.append(["name":"Taj Mahal","lat":"27.175277","long":"78.042128"])
            
            UserDefaults.standard.set(places, forKey: "places")
            
        }
        activePlace = -1
        tableViewOutlet.reloadData()

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
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "eachCell")
        
        if places[indexPath.row]["name"] != nil{
            cell.textLabel?.text = places[indexPath.row]["name"]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlace = indexPath.row
        
        performSegue(withIdentifier: "toMap", sender: nil)
    }

   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            UserDefaults.standard.set(places, forKey: "places")
            tableViewOutlet.reloadData()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
