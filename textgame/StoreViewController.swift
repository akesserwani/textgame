import UIKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var storeItems: [String: StoreItem] = Globals.storeItems
    @IBOutlet weak var storeTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        storeTable.delegate = self
        storeTable.dataSource = self
    }
    
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
    
    // Handle swipe actions
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
}

