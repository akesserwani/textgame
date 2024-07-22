//
//  MissionsViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/22/24.
//

import UIKit


class MissionsViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource {

    //names of the missions
    let missionNames = [
        "Mission 1",
        "Mission 2",
        "Mission 3",
        "Mission 4"
    ]

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Load in table view
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return missionNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "missionCell", for: indexPath) as! MissionCollectionCell
//        
//        cell.textLabel.text = missionNames[indexPath.row]
//        
//        return cell

    }
}
