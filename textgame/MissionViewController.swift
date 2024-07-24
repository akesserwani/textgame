//
//  MissionViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import UIKit

class MissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var missions = ["Raid Ships", "Search for Treasure", "Escort a Merchant Convoy"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = missionsTable.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath)
        cell.textLabel?.text = missions[indexPath.row]
        return cell
    }
    
    
    
    @IBOutlet weak var missionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        missionsTable.delegate = self
        missionsTable.dataSource = self
        
    }
}
