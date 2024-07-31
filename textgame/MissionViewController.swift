//
//  MissionViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import UIKit

// View Controller for managing and displaying missions
class MissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var missions = ["Raid Ships", "Search for Treasure", "Escort a Merchant Convoy"] // List of missions
    
    // Return the number of rows in the table (equal to the number of missions)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    // Configure each cell in the table view with mission names
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = missionsTable.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        cell.textLabel?.text = missions[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var missionsTable: UITableView! // Table view to list missions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view delegate and data source
        missionsTable.delegate = self
        missionsTable.dataSource = self
    }
}
