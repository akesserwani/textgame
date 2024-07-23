//
//  ItemsTableViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/23/24.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    public var items_data = [
        "Item 1",
        "Item 2",
        "Item 3"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items_data.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items_data[indexPath.row]
        return cell
        
    }


}
