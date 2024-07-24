//
//  ItemDetailViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var selectedItem: StoreItem?
    
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

        // Display the selected item
        if let item = selectedItem {
            itemTitle.text = item.action
            itemDescription.text = item.description
            itemPrice.text = "Price: \(item.price) gold"
            
        }
        
        //get current amount of gold from Global file
        let goldAmount = Globals.goldAmount
        //set current amount of gold to the UILabel
        myGold.text = "My Gold: \(goldAmount)"


    }
    
    //button click to buy item
    @IBAction func buyItem(_ sender: Any) {
        //get the current price of the item
        guard let item = selectedItem else { return }
        let itemPrice = item.price

        //get the users gold
        let currentGold = Globals.goldAmount

        //check if user has more gold than the price of the item
        if currentGold >= itemPrice{
            //update the amount of gold that the user has
            Globals.goldAmount -= itemPrice
            
            // Create alert to confirm the purchase
            let alert = UIAlertController(title: "Purchase Successful", message: "Price has been taken from your coffers", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                // Redirect to home page which is two pages back
                // Navigate two pages back
                if let navigationController = self.navigationController, navigationController.viewControllers.count >= 3 {
                    let targetViewController = navigationController.viewControllers[navigationController.viewControllers.count - 3]
                    navigationController.popToViewController(targetViewController, animated: true)
                }
            }))
            self.present(alert, animated: true, completion: nil)

        }
        //else create alert saying that the user does not have enough money
        else{
            // User does not have enough gold
            let alert = UIAlertController(title: "Insufficient Funds", message: "You do not have enough gold", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
}
