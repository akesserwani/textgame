//
//  Globals.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/24/24.
//

import Foundation

// Struct to represent a store item
struct StoreItem {
    var description: String // Description of the item
    var action: String // Action associated with the item
    var price: Int // Price of the item
}

// Struct to hold global game variables
struct Globals {
    
    // Dictionary of store items with their names as keys
    static let storeItems: [String: StoreItem] = [
        "Repair Ship": StoreItem(
            description: "Restore the ship's condition to 100%.",
            action: "Repair Ship",
            price: 600),
        
        "Man O’ War": StoreItem(description: "The Man O’ War is the largest ship in the game. Upgrading to the Man O' War can increase chances of victory by 10-15%", action: "Upgrade to Man O’ War", price: 3000),
        
        "Galleon": StoreItem(description: "The Galleon is the second largest ship in the game. Upgrading to the Galleon can increase chances of victory by 5-10%", action: "Upgrade to Galleon", price: 2000),
        
        "Meat": StoreItem(description: "The men at times crave good protein. Buy meat to strengthen the crewmembers and make them happy. Buying a supply of meat will restore 10% to crew satisfaction and increase the chances of ship combat victory by 5% for THREE battles.", action: "Supply of Meat", price: 300),
        
        "Rum": StoreItem(description: "Boost morale among the men. A good night of drinks will sure make them happy. A supply of rum can restore 10-20% of crew satisfaction.", action: "Supply of Rum", price: 200),
        
        "Repairman": StoreItem(description: "Recruit a repairman for the harshest of nights and bloodiest of battles. Having a repairman onboard can cut repair costs by 20%", action: "Recruit a Repairman", price: 1000),
        
        "Doctor": StoreItem(description: "Having a doctor on board can boost moral in battle and reduce combat deaths by 20-30% ", action: "Recruit a Doctor", price: 800),
        
        "Chef": StoreItem(description: "A good night's meal sure can make the crew happy and cut costs with food. Hiring a chef can increase the crews satisfaction by 5% and reduce the cost of food and drink by 20%.", action: "Recruit a Chef", price: 400)
    ]
    
    // Initial amount of gold the player starts with
    static var goldAmount: Int = 200 {
        didSet {
            saveGameState()
        }
    }
    
    // Initial ship condition
    static var shipCondition: Int = 100{
        didSet {
            saveGameState()
        }
    }

    // Initial crew satisfaction
    static var crewSatisfaction: Int = 100{
        didSet {
            saveGameState()
        }
    }
    static var shipType: String = "standard"{
        didSet{
            saveGameState()
        }
    }
    

    
    // Save game state to UserDefaults
    private static func saveGameState() {
        let defaults = UserDefaults.standard
        defaults.set(goldAmount, forKey: "goldAmount")
        defaults.set(shipCondition, forKey: "shipCondition")
        defaults.set(crewSatisfaction, forKey: "crewSatisfaction")
        defaults.set(shipType, forKey: "shipType")
    }
    
    // Load game state from UserDefaults
    static func loadGameState() {
        let defaults = UserDefaults.standard
        goldAmount = defaults.integer(forKey: "goldAmount")
        shipCondition = defaults.integer(forKey: "shipCondition")
        crewSatisfaction = defaults.integer(forKey: "crewSatisfaction")
        shipType = defaults.string(forKey: "shipType") ?? "standard"
    }
    
    // Optionally, you can initialize defaults if they are not set
    static func initializeDefaults() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "goldAmount") == nil {
            defaults.set(200, forKey: "goldAmount")
        }
        if defaults.object(forKey: "shipCondition") == nil {
            defaults.set(100, forKey: "shipCondition")
        }
        if defaults.object(forKey: "crewSatisfaction") == nil {
            defaults.set(100, forKey: "crewSatisfaction")
        }
    }
    
    // (Optional) Reputation variable can be added here if needed in the future
    // static var reputation: Int = 60
}



