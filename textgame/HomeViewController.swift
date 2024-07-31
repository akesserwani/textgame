//
//  HomeViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/22/24.
//

import UIKit

// View Controller for the home screen
class HomeViewController: UIViewController {

    @IBOutlet weak var goldLabel: UILabel! // Label to display current gold amount
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGoldLabel() // Set initial gold amount
        // Observe changes to the gold amount
        NotificationCenter.default.addObserver(self, selector: #selector(updateGoldLabel), name: Notification.Name("GoldAmountUpdated"), object: nil)
    }

    deinit {
        // Remove observer when the view controller is deinitialized
        NotificationCenter.default.removeObserver(self)
    }

    // Update the gold label with the current amount
    @objc func updateGoldLabel() {
        goldLabel.text = "Gold: \(Globals.goldAmount)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
