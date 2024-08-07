//
//  GamePlay.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/31/24.
//

import Foundation
struct RaidOutcome {
    var success: Bool
    var reward: Int?
    var penalties: (condition: Int, satisfaction: Int, goldLoss: Int)?
}

// Extend Globals to store the current ship type being raided
extension Globals {
    static var currentShipType: ShipType?
}

// Function to handle raid outcome
func handleRaidOutcome(for shipType: ShipType) -> RaidOutcome {
    let successRate = Int.random(in: 0...100)
    let success = successRate <= shipType.rateRange.upperBound
    
    if success {
        let reward = Int.random(in: shipType.rewardRange)
        return RaidOutcome(success: true, reward: reward, penalties: nil)
    } else {
        let conditionLoss = Int.random(in: shipType.penaltyConditionRange)
        let satisfactionLoss = Int.random(in: shipType.penaltySatisfactionRange)
        let goldLossPercentage = Int.random(in: shipType.penaltyGoldLossRange)
        let goldLoss = (Globals.goldAmount * goldLossPercentage) / 100
        return RaidOutcome(success: false, reward: nil, penalties: (conditionLoss, satisfactionLoss, goldLoss))
    }
}

// Define the ship types
struct ShipType {
    var name: String
    var rateRange: ClosedRange<Int>
    var rewardRange: ClosedRange<Int>
    var penaltyConditionRange: ClosedRange<Int>
    var penaltySatisfactionRange: ClosedRange<Int>
    var penaltyGoldLossRange: ClosedRange<Int>
}

let shipTypes: [ShipType] = [
    ShipType(name: "Royal Warship", rateRange: 2...20, rewardRange: 100...500, penaltyConditionRange: 20...50, penaltySatisfactionRange: 20...50, penaltyGoldLossRange: 50...70),
    ShipType(name: "Royal Merchant", rateRange: 10...30, rewardRange: 50...300, penaltyConditionRange: 10...40, penaltySatisfactionRange: 10...40, penaltyGoldLossRange: 30...40),
    ShipType(name: "Pirate Ship", rateRange: 10...50, rewardRange: 50...150, penaltyConditionRange: 10...30, penaltySatisfactionRange: 10...30, penaltyGoldLossRange: 20...40),
    ShipType(name: "Fishing Boat", rateRange: 60...90, rewardRange: 10...100, penaltyConditionRange: 5...20, penaltySatisfactionRange: 5...20, penaltyGoldLossRange: 10...15)
]

struct GameState {
    var dialogue: String
    var options: [String: (nextState: String, actions: [() -> Void])]
}

func raidShipsGameData() -> [String: GameState] {
    var gameData: [String: GameState] = [:]
    
    // Start state
    gameData["start"] = GameState(dialogue: "Do you want to raid ships?", options: [
        "Yes": ("raid_choose_ship", []),
        "No": ("raid_no", [])
    ])
    
    // Choose ship type to raid
    var raidChooseShipOptions: [String: (nextState: String, actions: [() -> Void])] = [:]
    for shipType in shipTypes {
        raidChooseShipOptions[shipType.name] = ("raid_outcome", [{ Globals.currentShipType = shipType }])
    }
    gameData["raid_choose_ship"] = GameState(dialogue: "Choose a ship to raid:", options: raidChooseShipOptions)
    
    // Raid outcome
    gameData["raid_outcome"] = GameState(dialogue: {
        let currentShipType = Globals.currentShipType!
        let outcome = handleRaidOutcome(for: currentShipType)
        
        if outcome.success {
            Globals.goldAmount += outcome.reward!
            return "You successfully raided the \(currentShipType.name)! You gained \(outcome.reward!) gold."
        } else {
            Globals.shipCondition -= outcome.penalties!.condition
            Globals.crewSatisfaction -= outcome.penalties!.satisfaction
            Globals.goldAmount -= outcome.penalties!.goldLoss
            return "You lost the battle against the \(currentShipType.name). Your ship condition decreased by \(outcome.penalties!.condition)%, crew satisfaction decreased by \(outcome.penalties!.satisfaction)%, and you lost \(outcome.penalties!.goldLoss) gold."
        }
    }(), options: [
        "Restart": ("start", [])
    ])
    
    // No raid state
    gameData["raid_no"] = GameState(dialogue: "You decided not to raid ships.", options: [
        "Try Again": ("start", []),
        "Exit": ("exit", [])
    ])
    
    // Exit state
    gameData["exit"] = GameState(dialogue: "You have exited the game.", options: [
        "Restart": ("start", [])
    ])
    
    return gameData
}

class GamePlay {

    //functions to adjust variables
    //if one argument is given then a set value is changed
    //if two arguments are given, a random number is selected between those two numbers
    
    //change gold
    static func changeGold(amount: Int) {
        Globals.goldAmount += amount
    }
    static func changeGold(minAmount: Int, maxAmount: Int) {
        let randomAmount = Int.random(in: minAmount...maxAmount)
        Globals.goldAmount += randomAmount
    }

    //change ship condition
    static func changeShipCondition(amount: Int) {
        Globals.shipCondition += amount
    }
    static func changeShipCondition(minAmount: Int, maxAmount: Int) {
        let randomAmount = Int.random(in: minAmount...maxAmount)
        Globals.shipCondition += randomAmount
    }
    //change crew satisfaction
    static func changeCrewSatis(amount: Int) {
        Globals.crewSatisfaction += amount
    }
    static func changeCrewSatis(minAmount: Int, maxAmount: Int) {
        let randomAmount = Int.random(in: minAmount...maxAmount)
        Globals.crewSatisfaction += randomAmount
    }

    static func raidShipsGame() -> [String: GameState] {
           return raidShipsGameData()
       }
    
    // Function to return game data for "Search for Treasure"
    static func searchForTreasure() -> [String: GameState] {
        return [
            "start": GameState(dialogue: "Adventure beckons, Captain—shall we seek our fortune on the mysterious isles rumored to hold untold treasures? The choice is yours:",
                options: [
                "Chart a course": ("treasure_explore", []),
                "Give Up": ("treasure_giveup", [])
            ]),
            "treasure_explore": GameState(dialogue: "We shall set sail and look for an island rumored to hold the lost treasure of Captain Blackwater, a notorious pirate known for his cunning and ruthlessness. The journey is risky, and the seas are treacherous.",
                options: [
                "Take the safe route": ("safe_route", []),
                "Take the risky route": ("risky_route", [])
            ]),
            "safe_route": GameState(dialogue: "Choosing the longer route proves wise. The seas remain calm, and your crew's morale is high. As you approach the island, you notice another ship docked on the far side.",
                options: [
                "Investigate the other ship": ("investigate_ship", []),
                "Ignore it and focus on finding the treasure": ("arrive_island", [])
            ]),
            "risky_route": GameState(dialogue: "The seas are rough, and a storm is brewing. Your ship takes damage, and you lose some crew members. But finally, you arrive at the island, weary but determined.",
                options: [
                "Land on the island": ("arrive_island", []),
                "Retreat and repair the ship": ("repair_ship", [])
            ]),
            "investigate_ship": GameState(dialogue: "You approach the ship cautiously. It appears to be abandoned, but as you get closer, you realize it's a trap! Pirates ambush you, and a fierce battle ensues.",
                options: [
                "Fight back": ("fight_pirates", []),
                "Flee back to your ship": ("flee_pirates", [])
            ]),
            "fight_pirates": GameState(dialogue: "You and your crew fight bravely. After a fierce battle, you manage to defeat the pirates and take their ship as a prize. The treasure hunt continues.",
                options: [
                "Continue searching the island": ("arrive_island", [])
            ]),
            "flee_pirates": GameState(dialogue: "You retreat back to your ship and set sail immediately. The treasure will have to wait for another day.",
                options: [
                "Restart": ("start", [])
            ]),
            "repair_ship": GameState(dialogue: "You decide to retreat and repair your ship. The crew works tirelessly, and soon the ship is seaworthy again. You set sail once more for the island.",
                options: [
                "Continue to the island": ("arrive_island", [])
            ]),
            "arrive_island": GameState(dialogue: "As you arrive on the island, you notice strange markings on the trees. The crew grows uneasy, but you press on. Suddenly, a group of natives appears, armed and wary of your presence.",
                options: [
                "Communicate peacefully": ("peaceful_natives", []),
                "Prepare for a fight": ("fight_natives", [])
            ]),
            "peaceful_natives": GameState(dialogue: "You manage to communicate with the natives peacefully. They are wary but agree to help you find the treasure in exchange for some of your supplies.",
                options: [
                "Agree to the deal": ("natives_agree", []),
                "Refuse and continue alone": ("continue_alone", [])
            ]),
            "fight_natives": GameState(dialogue: "A fierce battle ensues with the natives. You manage to fend them off, but your crew suffers heavy losses. The search for the treasure continues.",
                options: [
                "Continue searching the island": ("search_island", [])
            ]),
            "natives_agree": GameState(dialogue: "The natives lead you to a hidden cave deep in the jungle. Inside, you find clues and puzzles left by Captain Blackwater to guard his treasure.",
                options: [
                "Solve the first riddle": ("first_riddle", []),
                "Search for another way": ("search_island", [])
            ]),
            "continue_alone": GameState(dialogue: "You refuse the natives' offer and decide to continue the search on your own. After a long and arduous journey, you finally find a hidden cave.",
                options: [
                "Enter the cave": ("first_riddle", [])
            ]),
            "first_riddle": GameState(dialogue: "The first riddle reads: 'I speak without a mouth and hear without ears. I have no body, but I come alive with the wind. What am I?'",
                options: [
                "Echo": ("riddle_correct", []),
                "Wind": ("riddle_wrong", []),
                "Whisper": ("riddle_wrong", [])
            ]),
            "riddle_correct": GameState(dialogue: "Correct! The path ahead opens, revealing more of the cave. You find another clue leading deeper into the cave.",
                options: [
                "Continue deeper": ("second_riddle", [])
            ]),
            "riddle_wrong": GameState(dialogue: "Wrong answer! The cave shakes, and you narrowly escape a trap. You decide to try another path.",
                options: [
                "Search another path": ("search_island", [])
            ]),
            "second_riddle": GameState(dialogue: "The second riddle reads: 'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?'",
                options: [
                "Map": ("riddle_correct_2", []),
                "Ocean": ("riddle_wrong_2", []),
                "Desert": ("riddle_wrong_2", [])
            ]),
            "riddle_correct_2": GameState(dialogue: "Correct again! The final chamber opens, revealing the legendary treasure of Captain Blackwater!",
                options: [
                "Take the treasure": ("treasure_found", []),
                "Explore further": ("explore_cave", [])
            ]),
            "riddle_wrong_2": GameState(dialogue: "Wrong answer! The cave starts to collapse. You narrowly escape with your life and decide to return to the ship.",
                options: [
                "Restart": ("start", [])
            ]),
            "explore_cave": GameState(dialogue: "Exploring deeper into the cave, you find additional riches and artifacts. However, you also encounter dangerous traps. It's a risk, but the rewards are great.",
                options: [
                "Take the additional treasure and risk the traps": ("treasure_found_extra", []),
                "Take only the main treasure and leave safely": ("treasure_found", [])
            ]),
            "treasure_found": GameState(dialogue: "You found the treasure and safely return to your ship. Your crew is overjoyed, and the journey back is filled with celebration.",
                options: [
                "Restart": ("start", [])
            ]),
            "treasure_found_extra": GameState(dialogue: "You managed to evade the traps and collect additional treasure. Your ship is now overflowing with riches. The journey back is a triumphant return.",
                options: [
                "Restart": ("start", [])
            ]),
            "treasure_giveup": GameState(dialogue: "You decided not to pursue the treasure. The crew is disappointed, but they respect your decision.",
                options: [
                "Restart": ("start", [])
            ]),
            "exit": GameState(dialogue: "You have exited the game.",
                options: [
                "Restart": ("start", [])
            ]),
        ]
    }
    
    
    
    static func getGameState(for key: String, gameData: [String: GameState]) -> GameState? {
        return gameData[key]
    }
}
