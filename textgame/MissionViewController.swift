//
//  MissionViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import UIKit

// View Controller for managing and displaying missions
class MissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // List of missions
    var missions = ["Raid Ships", "Search for Treasure", "Start New Game"]
    
    // Table view to list missions
    @IBOutlet weak var missionsTable: UITableView! // Table view to list missions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view delegate and data source
        missionsTable.delegate = self
        missionsTable.dataSource = self
    }
    

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
    
    // Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMission = missions[indexPath.row]
        performSegue(withIdentifier: "showHomeView", sender: selectedMission)
    }
    
    // Prepare for segue and pass the selected mission to the new view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHomeView" {
            if let destinationVC = segue.destination as? HomeViewController,
               let selectedMission = sender as? String {
                destinationVC.mission = selectedMission
            }
        }
    }
    
    
}
