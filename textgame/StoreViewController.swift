import UIKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var storeTable: UITableView!
    var storeItems: [String: StoreItem] = Globals.storeItems

    // MARK: - View Lifecycle
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

    // MARK: - Notification Handling
    @objc func updateGoldAmount() {
        storeTable.reloadData()
        goldLabel.text = "Gold: \(Globals.goldAmount)"
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItems.count
    }
    
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
            if (isBought) {
                cell.isUserInteractionEnabled = false
                cell.contentView.alpha = 0.5
            } else {
                cell.isUserInteractionEnabled = true
                cell.contentView.alpha = 1.0
            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let buyAction = UIContextualAction(style: .normal, title: "Buy") { [weak self] (action, view, completionHandler) in
            self?.handleBuyAction(for: indexPath)
            completionHandler(true)
        }
        buyAction.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [buyAction])
    }

    private func handleBuyAction(for indexPath: IndexPath) {
        let itemName = Array(storeItems.keys)[indexPath.row]
        if let item = storeItems[itemName] {
            if Globals.goldAmount >= item.price {
                Globals.goldAmount -= item.price
                showAlert(title: "Success", message: "You bought \(itemName)!")
            } else {
                showAlert(title: "Error", message: "Not enough gold.")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

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

    // MARK: - Navigation
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
