//
//  StoreViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/22/24.
//

import UIKit


class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var storeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source
        storeTable.delegate = self
        storeTable.dataSource = self
        
        // Initialize gold label with current gold amount
        goldLabel.text = "Gold: \(Globals.goldAmount)"
        
        // Observe changes to the gold amount
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoldAmount), name: Notification.Name("GoldAmountUpdated"), object: nil)
        
        // Uncomment this line to reset bought items
        // Run the build and open the shop, them close the sim.
        // then comment it back after testing
        
        // LocalStorageManager.shared.clearBoughtItems()
    }
    
    deinit {
        // Remove observer when the view controller is deinitialized
        NotificationCenter.default.removeObserver(self)
    }
    
    // Update the gold amount display and reload the store table
    @objc func updateGoldAmount() {
        storeTable.reloadData()
        goldLabel.text = "Gold: \(Globals.goldAmount)"
    }
    
    var storeItems: [String: StoreItem] = Globals.storeItems

    // Return the number of rows in the table (equal to the number of store items)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
    // Configure each cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storeTable.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let itemName = Array(storeItems.keys)[indexPath.row]
        print("Item Name: \(itemName)") // Debug print
        
        if let item = storeItems[itemName] {
            // Set cell text with item action and price
            cell.textLabel?.text = "\(item.action) - \(item.price) gold"
            
            // Check if the item has been bought
            let isBought = LocalStorageManager.shared.isItemBought(itemName)
            print("Is Item Bought: \(isBought)") // Debug print
            
            // Update cell appearance based on whether the item is bought
            if isBought {
                cell.isUserInteractionEnabled = false
                cell.contentView.alpha = 0.5
            } else {
                cell.isUserInteractionEnabled = true
                cell.contentView.alpha = 1.0
            }
        }
        return cell
    }
    
    // Handle item selection in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemName = Array(storeItems.keys)[indexPath.row]
        if LocalStorageManager.shared.isItemBought(itemName) {
            // Show alert if the item has already been purchased
            let alert = UIAlertController(title: "Item Already Purchased", message: "You have already purchased this item.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Pass the selected item to the detail view controller
            let selectedItem = storeItems[itemName]
            performSegue(withIdentifier: "showDetail", sender: (selectedItem, itemName))
        }
    }
    
    // Prepare for segue to the item detail view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destinationVC = segue.destination as? ItemDetailViewController,
               let (selectedItem, itemName) = sender as? (StoreItem, String) {
                destinationVC.selectedItem = selectedItem
                destinationVC.itemName = itemName
            }
        }
    }
}
