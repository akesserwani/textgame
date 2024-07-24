//
//  Globals.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import Foundation

struct StoreItem {
    var description: String
    var action: String
    var price: Int
}

struct Globals {
    
    //variables for the store items
    static let storeItems: [String: StoreItem] = [
        "Repair Ship": StoreItem(
            description: "Restore the ship's condition to 100%.",
            action: "Repair Ship",
            price: 600),
        
        "Man O’ War": StoreItem(description: "The Man O’ War is the largest ship in the game. Upgrading to the Man O' War can increase chances of victory by 10-15%", action: "Upgrade to Man O’ War", price: 3000),
        
        "Galleon": StoreItem(description: "The Galleon is the second largest ship in the game. Upgrading to the Galleon can increase chances of victory by 5-10%", action: "Upgrade to Galleon", price: 2000),
        
        "Meat": StoreItem(description: "The men at times crave good protein. By meat to strengthen the crewmembers and make them happy. Buying a supply of meat will restore 10% to crew satisfaction and increase the chances of ship combat victory by 5% for THREE battles.", action: "Supply of Meat", price: 300),
        
        "Rum": StoreItem(description: "Boost morale among the men. A good night of drinks will sure make them happy. A supply of rum can restore 10-20% of crew satisfaction.", action: "Supply of Rum", price: 200),
        
        "Repairman": StoreItem(description: "Recruit a repairman for the harshest of nights and bloodiest of battles. Having a repairman onboard can cut repair costs by 20%", action: "Recruit a Repairman", price: 1000),
        
        "Doctor": StoreItem(description: "Having a doctor on board can boost moral in battle and reduce combat deaths by 20-30% ", action: "Recruit a Doctor", price: 800),
        
        "Chef": StoreItem(description: "A good night's meal sure can make the crew happy and cut costs with food. Hiring a chef can increase the crews satisfaction by 5% and reduce the cost of food and drink by 20%.", action: "Recruit a Chef", price: 400)
    ]

    
    //variables to be updated throughout the game
    //my money variable - starts of with 200 gold
    static var goldAmount: Int = 200
    
    //ship condition variable - starts with 100%
    static var shipCondition: Int = 100

    //crew satisfaction variable - starts with 100%
    static var crewSatisfaction: Int = 100
    
    //If extra time left add reputation variable
    //reputation variable - starts with 60%
    //static var reputation: Int = 60

}
