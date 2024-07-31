//
//  ItemDetailViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var selectedItem: StoreItem?
    var itemName: String?
    
    //UI items
    //title variable
    @IBOutlet weak var itemTitle: UILabel!
    //description
    @IBOutlet weak var itemDescription: UITextView!
    //item price
    @IBOutlet weak var itemPrice: UILabel!
    //current amount of gold
    @IBOutlet weak var myGold: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let item = selectedItem {
            itemTitle.text = item.action
            itemDescription.text = item.description
            itemPrice.text = "Price: \(item.price) gold"
        }
        
        updateGoldLabel() // Update the gold label with current amount
        
        // Observe changes to the gold amount
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoldLabel), name: Notification.Name("GoldAmountUpdated"), object: nil)
    }
    
    deinit {
        // Remove observer when the view controller is deinitialized
        NotificationCenter.default.removeObserver(self)
    }
    
    // Update the gold label with the current amount
    @objc func updateGoldLabel() {
        myGold.text = "My Gold: \(Globals.goldAmount)"
    }
    
    // Handle the purchase button action
    @IBAction func buyItem(_ sender: Any) {
        guard let item = selectedItem, let itemName = itemName else { return }
        let itemPrice = item.price
        let currentGold = Globals.goldAmount

        if currentGold >= itemPrice {
            // Deduct the price from the player's gold
            Globals.goldAmount -= itemPrice
            
            // Save the item as bought
            LocalStorageManager.shared.saveBoughtItem(itemName)
            
            // Notify other parts of the app about the gold amount change
            NotificationCenter.default.post(name: Notification.Name("GoldAmountUpdated"), object: nil)
            
            // Show a successful purchase alert
            let alert = UIAlertController(title: "Purchase Successful", message: "Price has been taken from your coffers", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Navigate back to the previous view controller
                if let navigationController = self.navigationController, navigationController.viewControllers.count >= 3 {
                    let targetViewController = navigationController.viewControllers[navigationController.viewControllers.count - 3]
                    navigationController.popToViewController(targetViewController, animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // Show an alert if the player does not have enough gold
            let alert = UIAlertController(title: "Insufficient Funds", message: "You do not have enough gold", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
