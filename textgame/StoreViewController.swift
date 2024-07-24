//
//  StoreViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/22/24.
//

import UIKit


class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //get store items variable from Globals file
    var storeItems: [String: StoreItem] = Globals.storeItems

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storeTable.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let itemName = Array(storeItems.keys)[indexPath.row]
        if let item = storeItems[itemName] {
            cell.textLabel?.text = "\(item.action) - \(item.price) gold"
        }
        return cell
    }
    
    //button to select row and perform segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = Array(storeItems.keys)[indexPath.row]
        let selectedItem = storeItems[itemName]
        performSegue(withIdentifier: "showDetail", sender: selectedItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? ItemDetailViewController,
               let selectedItem = sender as? StoreItem {
                destinationVC.selectedItem = selectedItem
            }
        }
    }

    @IBOutlet weak var storeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storeTable.delegate = self
        storeTable.dataSource = self
    }
    


}
