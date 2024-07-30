//
//  LocalStorageManager.swift
//  textgame
//
//  Created by Ryan Christopher Payant on 7/30/24.
//

import Foundation

// Singleton class to manage local storage of bought items
class LocalStorageManager {
    static let shared = LocalStorageManager()
    private let boughtItemsKey = "boughtItems" // Key used to store bought items in UserDefaults
    
    private init() {}
    
    // Save an item as bought
    func saveBoughtItem(_ itemName: String) {
        var boughtItems = getBoughtItems()
        if !boughtItems.contains(itemName) {
            boughtItems.append(itemName)
            UserDefaults.standard.setValue(boughtItems, forKey: boughtItemsKey)
            print("Saved item: \(itemName). Bought items now: \(boughtItems)") // Debug print
        } else {
            print("Item already bought: \(itemName). Bought items: \(boughtItems)") // Debug print
        }
    }
    
    // Retrieve the list of bought items
    func getBoughtItems() -> [String] {
        let boughtItems = UserDefaults.standard.stringArray(forKey: boughtItemsKey) ?? []
        print("Retrieved bought items: \(boughtItems)") // Debug print
        return boughtItems
    }
    
    // Check if a specific item has been bought
    func isItemBought(_ itemName: String) -> Bool {
        let isBought = getBoughtItems().contains(itemName)
        print("Is \(itemName) bought? \(isBought)") // Debug print
        return isBought
    }

    // Temporary method to clear bought items for debugging
    func clearBoughtItems() {
        UserDefaults.standard.removeObject(forKey: boughtItemsKey)
        print("Cleared bought items")
    }
}
