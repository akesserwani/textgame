//
//  GamePlay.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/31/24.
//

import Foundation

struct GameState {
    var dialogue: String
    var options: [String: (nextState: String, actions: [() -> Void])]
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

    // Function to return game data for "Raid Ships"
    static func raidShipsGame() -> [String: GameState] {
        return [
            "start": GameState(dialogue: "Do you want to raid ships?", options: [
                "Yes": ("raid_start", [{}, { print("Raiding Ships Started!") }]),
                "No": ("raid_no", [])
            ]),
            "raid_start": GameState(dialogue: "You are preparing to raid ships. What do you want to do next?", options: [
                "Attack": ("raid_attack", [{ print("Attacking...") }]),
                "Retreat": ("raid_retreat", [])
            ]),
            "raid_no": GameState(dialogue: "You decided not to raid ships.", options: [
                "Try Again": ("start", []),
                "Exit": ("exit", [])
            ]),
            "raid_attack": GameState(dialogue: "You engage in a naval battle.", options: [
                "Win": ("raid_win", []),
                "Lose": ("raid_lose", [])
            ]),
            "raid_retreat": GameState(dialogue: "You retreat to safety.", options: [
                "Continue": ("raid_start", [])
            ]),
            "raid_win": GameState(dialogue: "You won the battle!", options: [
                "Restart": ("start", [])
            ]),
            "raid_lose": GameState(dialogue: "You lost the battle.", options: [
                "Restart": ("start", [])
            ]),
            "exit": GameState(dialogue: "You have exited the game.", options: [
                "Restart": ("start", [])
            ])
        ]
    }
    
    // Function to return game data for "Search for Treasure"
    static func searchForTreasure() -> [String: GameState] {
        return [
            "start": GameState(dialogue: "Adventure beckons, Captain—shall we seek our fortune on the mysterious isles rumored to hold untold treasures? The choice is yours:",
                options: [
                    "Chart a course": ("treasure_explore", [{ changeCrewSatis(amount: 5) }]), // Crew is happy to explore
                    "Give Up": ("treasure_giveup", [{ changeCrewSatis(amount: -10) }]) // Crew disappointed
            ]),
            "treasure_explore": GameState(dialogue: "We shall set sail and look for an island rumored to hold the lost treasure of Captain Blackwater, a notorious pirate known for his cunning and ruthlessness. The journey is risky, and the seas are treacherous.",
                options: [
                    "Take the safe route": ("safe_route", [{ changeGold(minAmount: 5, maxAmount: 10) }, { changeCrewSatis(amount: 10) }]), // Gain some gold and crew satisfaction
                    "Take the risky route": ("risky_route", [{ changeShipCondition(amount: -20) }, { changeCrewSatis(amount: -5) }]) // Lose ship condition and some crew satisfaction
            ]),
            "safe_route": GameState(dialogue: "Choosing the longer route proves wise. The seas remain calm, and your crew's morale is high. As you approach the island, you notice another ship docked on the far side.",
                options: [
                    "Investigate the other ship": ("investigate_ship", [{ changeGold(minAmount: 0, maxAmount: 5) }, { changeCrewSatis(amount: 5) }]), // Gain gold and crew satisfaction
                    "Ignore it and focus on finding the treasure": ("arrive_island", [{ changeGold(minAmount: 0, maxAmount: 5) }]) // Gain a small amount of gold
            ]),
            "risky_route": GameState(dialogue: "The seas are rough, and a storm is brewing. Your ship takes damage, and you lose some crew members. But finally, you arrive at the island, weary but determined.",
                options: [
                    "Land on the island": ("arrive_island", [{ changeShipCondition(amount: -10) }, { changeCrewSatis(amount: -10) }]), // Further decrease in condition and satisfaction
                    "Retreat and repair the ship": ("repair_ship", [{ changeShipCondition(amount: 20) }]) // Repair ship
            ]),
            "investigate_ship": GameState(dialogue: "You approach the ship cautiously. It appears to be abandoned, but as you get closer, you realize it's a trap! Pirates ambush you, and a fierce battle ensues.",
                options: [
                    "Fight back": ("fight_pirates", [{ changeGold(minAmount: 10, maxAmount: 20) }, { changeCrewSatis(amount: 10) }]), // Win battle, gain gold, and crew satisfaction
                    "Flee back to your ship": ("flee_pirates", [{ changeCrewSatis(amount: -10) }, { changeShipCondition(amount: -10) }]) // Lose satisfaction and ship condition
            ]),
            "fight_pirates": GameState(dialogue: "You and your crew fight bravely. After a fierce battle, you manage to defeat the pirates and take their ship as a prize. The treasure hunt continues.",
                options: [
                    "Continue searching the island": ("arrive_island", [{ changeGold(minAmount: 5, maxAmount: 10) }]), // Gain additional gold
                    "Head back to the ship": ("repair_ship", [{ changeShipCondition(amount: 10) }]) // Repair and regroup
            ]),
            "flee_pirates": GameState(dialogue: "You retreat back to your ship and set sail immediately. The treasure will have to wait for another day.",
                options: [
                    "Reconsider and try again": ("start", []),
                    "Repair and plan anew": ("repair_ship", [])
            ]),
            "repair_ship": GameState(dialogue: "You decide to retreat and repair your ship. The crew works tirelessly, and soon the ship is seaworthy again. You set sail once more for the island.",
                options: [
                    "Continue to the island": ("arrive_island", [{ changeShipCondition(amount: 15) }, { changeCrewSatis(amount: 5) }]), // Improved condition and satisfaction
                    "Re-evaluate the journey": ("treasure_giveup", [{ changeCrewSatis(amount: -5) }]) // Doubts about the quest
            ]),
            "arrive_island": GameState(dialogue: "As you arrive on the island, you notice strange markings on the trees. The crew grows uneasy, but you press on. Suddenly, a group of natives appears, armed and wary of your presence.",
                options: [
                    "Communicate peacefully": ("peaceful_natives", [{ changeCrewSatis(amount: 10) }]), // Increase crew satisfaction
                    "Prepare for a fight": ("fight_natives", [{ changeCrewSatis(amount: -10) }, { changeShipCondition(amount: -10) }]) // Lose satisfaction and ship condition
            ]),
            "peaceful_natives": GameState(dialogue: "You manage to communicate with the natives peacefully. They are wary but agree to help you find the treasure in exchange for some of your supplies.",
                options: [
                    "Agree to the deal": ("natives_agree", [{ changeGold(amount: -5) }, { changeCrewSatis(amount: 5) }]), // Lose some gold, gain satisfaction
                    "Refuse and continue alone": ("continue_alone", [{ changeCrewSatis(amount: -5) }]) // Lose satisfaction
            ]),
            "fight_natives": GameState(dialogue: "A fierce battle ensues with the natives. You manage to fend them off, but your crew suffers heavy losses. The search for the treasure continues.",
                options: [
                    "Continue searching the island": ("search_island", [{ changeGold(minAmount: 0, maxAmount: 5) }]), // Small gold gain
                    "Return to the ship": ("repair_ship", [{ changeShipCondition(amount: 10) }]) // Repair and regroup
            ]),
            "natives_agree": GameState(dialogue: "The natives lead you to a hidden cave deep in the jungle. Inside, you find clues and puzzles left by Captain Blackwater to guard his treasure.",
                options: [
                    "Solve the first riddle": ("first_riddle", []),
                    "Search for another way": ("search_island", [])
            ]),
            "continue_alone": GameState(dialogue: "You refuse the natives' offer and decide to continue the search on your own. After a long and arduous journey, you finally find a hidden cave.",
                options: [
                    "Enter the cave": ("first_riddle", [{ changeCrewSatis(amount: -5) }]), // Lose satisfaction
                    "Explore the surrounding area": ("search_island", [{ changeCrewSatis(amount: -5) }]) // Further exploration
            ]),
            "first_riddle": GameState(dialogue: "The first riddle reads: 'I speak without a mouth and hear without ears. I have no body, but I come alive with the wind. What am I?'",
                options: [
                    "Echo": ("riddle_correct", [{ changeCrewSatis(amount: 5) }]), // Correct answer increases satisfaction
                    "Wind": ("riddle_wrong", [{ changeCrewSatis(amount: -5) }]) // Wrong answer decreases satisfaction
            ]),
            "riddle_correct": GameState(dialogue: "Correct! The path ahead opens, revealing more of the cave. You find another clue leading deeper into the cave.",
                options: [
                    "Continue deeper": ("second_riddle", []),
                    "Retreat and regroup": ("repair_ship", [{ changeShipCondition(amount: 10) }]) // Chance to regroup
            ]),
            "riddle_wrong": GameState(dialogue: "Wrong answer! The cave shakes, and you narrowly escape a trap. You decide to try another path.",
                options: [
                    "Search another path": ("search_island", [{ changeCrewSatis(amount: -5) }, { changeShipCondition(amount: -5) }]), // Lose satisfaction and ship condition
                    "Return to the ship": ("repair_ship", [{ changeShipCondition(amount: 10) }]) // Repair and regroup
            ]),
            "second_riddle": GameState(dialogue: "The second riddle reads: 'I have cities, but no houses. I have mountains, but no trees. I have water, but no fish. What am I?'",
                options: [
                    "Map": ("riddle_correct_2", [{ changeCrewSatis(amount: 5) }]), // Correct answer increases satisfaction
                    "Ocean": ("riddle_wrong_2", [{ changeCrewSatis(amount: -5) }]) // Wrong answer decreases satisfaction
            ]),
            "riddle_correct_2": GameState(dialogue: "Correct again! The final chamber opens, revealing the legendary treasure of Captain Blackwater!",
                options: [
                    "Take the treasure": ("treasure_found", [{ changeGold(minAmount: 50, maxAmount: 100) }, { changeCrewSatis(amount: 20) }]), // Huge gold gain and satisfaction
                    "Explore further": ("explore_cave", [])
            ]),
            "riddle_wrong_2": GameState(dialogue: "Wrong answer! The cave starts to collapse. You narrowly escape with your life and decide to return to the ship.",
                options: [
                    "Restart": ("start", [{ changeCrewSatis(amount: -10) }, { changeShipCondition(amount: -10) }]), // Significant losses
                    "Re-evaluate your options": ("treasure_giveup", [{ changeCrewSatis(amount: -5) }]) // Doubts about the quest
            ]),
            "explore_cave": GameState(dialogue: "Exploring deeper into the cave, you find additional riches and artifacts. However, you also encounter dangerous traps. It's a risk, but the rewards are great.",
                options: [
                    "Take the additional treasure and risk the traps": ("treasure_found_extra", [{ changeGold(minAmount: 20, maxAmount: 50) }, { changeShipCondition(amount: -10) }]), // Extra gold, potential ship damage
                    "Take only the main treasure and leave safely": ("treasure_found", [])
            ]),
            "treasure_found": GameState(dialogue: "You found the treasure and safely return to your ship. Your crew is overjoyed, and the journey back is filled with celebration.",
                options: [
                    "Restart": ("start", [{ changeCrewSatis(amount: 20) }]), // High satisfaction
                    "Plan the next adventure": ("treasure_explore", []) // Continue exploring
            ]),
            "treasure_found_extra": GameState(dialogue: "You managed to evade the traps and collect additional treasure. Your ship is now overflowing with riches. The journey back is a triumphant return.",
                options: [
                    "Restart": ("start", [{ changeCrewSatis(amount: 30) }]), // Very high satisfaction
                    "Plan the next adventure": ("treasure_explore", []) // Continue exploring
            ]),
            "treasure_giveup": GameState(dialogue: "You decided not to pursue the treasure. The crew is disappointed, but they respect your decision.",
                options: [
                    "Restart": ("start", [{ changeCrewSatis(amount: -10) }]), // Crew disappointment
                    "Re-evaluate the journey": ("repair_ship", [{ changeCrewSatis(amount: -5) }]) // Doubts about the quest
            ]),
            "exit": GameState(dialogue: "You have exited the game.",
                options: [
                    "Restart": ("start", []),
                    "Exit completely": ("exit", []) // Ending point
            ]),
            // New intricate scenarios added below
            "search_island": GameState(dialogue: "As you search deeper into the island, you encounter treacherous terrain and wild animals. The path is difficult, and the crew begins to doubt the existence of the treasure.",
                options: [
                    "Encourage the crew": ("crew_boost", [{ changeCrewSatis(amount: 10) }]), // Boost morale
                    "Press on regardless": ("crew_discontent", [{ changeCrewSatis(amount: -10) }]) // Crew discontent
            ]),
            "crew_boost": GameState(dialogue: "Your words rally the crew, and their spirits lift. You press on through the dense jungle, overcoming challenges together.",
                options: [
                    "Climb the mountain": ("mountain_climb", [{ changeShipCondition(amount: -5) }]), // Ship remains anchored, possible wear
                    "Follow the river": ("follow_river", [{ changeGold(minAmount: 0, maxAmount: 10) }]) // Discover small treasures along the river
            ]),
            "crew_discontent": GameState(dialogue: "The crew grumbles and morale drops. You push forward, hoping to find something that will reignite their faith in the quest.",
                options: [
                    "Seek a high vantage point": ("mountain_climb", []),
                    "Search the dense forest": ("dense_forest", [])
            ]),
            "mountain_climb": GameState(dialogue: "Climbing the mountain gives you a clear view of the island. You spot a mysterious glint on a distant peak.",
                options: [
                    "Investigate the glint": ("investigate_glint", [{ changeGold(minAmount: 5, maxAmount: 15) }]), // Find gold
                    "Descend and explore further": ("descend_mountain", [{ changeCrewSatis(amount: 5) }]) // Crew morale boost
            ]),
            "follow_river": GameState(dialogue: "The river's path leads to a hidden waterfall concealing a cave entrance. You enter with caution.",
                options: [
                    "Explore the cave": ("cave_explore", [{ changeGold(minAmount: 10, maxAmount: 20) }]), // Discover hidden gold
                    "Turn back": ("turn_back", [{ changeCrewSatis(amount: -5) }]) // Slight crew disappointment
            ]),
            "investigate_glint": GameState(dialogue: "The glint was a cleverly disguised mirror used by Captain Blackwater to mark hidden treasure. You dig and uncover a chest of gold.",
                options: [
                    "Celebrate and return": ("treasure_found", []),
                    "Search for more clues": ("search_more_clues", [{ changeGold(minAmount: 10, maxAmount: 20) }]) // Extra treasure
            ]),
            "descend_mountain": GameState(dialogue: "Returning from the mountain, you lead your crew toward new discoveries, spirits high from the promising view.",
                options: [
                    "Explore the dense forest": ("dense_forest", []),
                    "Head to the coast": ("head_coast", [])
            ]),
            "dense_forest": GameState(dialogue: "Within the dense forest, you discover ancient ruins covered in vines. These remnants of an old civilization hold secrets.",
                options: [
                    "Study the ruins": ("study_ruins", [{ changeGold(minAmount: 5, maxAmount: 15) }]), // Find ancient coins
                    "Move on quickly": ("move_on", [{ changeCrewSatis(amount: -5) }]) // Crew wants to move
            ]),
            "study_ruins": GameState(dialogue: "Studying the ruins reveals inscriptions hinting at a buried artifact. You dig and find an amulet rumored to bring luck.",
                options: [
                    "Keep the amulet": ("treasure_found_extra", [{ changeGold(minAmount: 20, maxAmount: 30) }, { changeCrewSatis(amount: 10) }]), // Major find
                    "Leave it be": ("leave_amulet", [{ changeCrewSatis(amount: -5) }]) // Crew discontent
            ]),
            "leave_amulet": GameState(dialogue: "You decide not to disturb the artifact, respecting the ancient culture. Your crew respects your decision but is slightly disappointed.",
                options: [
                    "Move on": ("move_on", [{ changeCrewSatis(amount: 5) }]) // Small morale boost for respect
            ]),
            "move_on": GameState(dialogue: "As you move on, you come across signs of other pirates who might have landed here before.",
                options: [
                    "Investigate further": ("investigate_pirates", [{ changeGold(minAmount: 0, maxAmount: 10) }]), // Possible loot
                    "Avoid them": ("avoid_pirates", [{ changeCrewSatis(amount: 5) }]) // Play it safe
            ]),
            "head_coast": GameState(dialogue: "Reaching the coast, you find an old shipwreck partially buried in the sand.",
                options: [
                    "Explore the wreck": ("explore_wreck", [{ changeGold(minAmount: 5, maxAmount: 15) }, { changeCrewSatis(amount: 5) }]), // Discover gold and boost morale
                    "Ignore and move on": ("move_on", [{ changeCrewSatis(amount: -5) }]) // Crew disappointment
            ]),
            "explore_wreck": GameState(dialogue: "Exploring the wreck reveals it belonged to a well-known pirate. Inside, you find gold doubloons and a map to hidden riches.",
                options: [
                    "Take the map": ("map_found", [{ changeGold(minAmount: 10, maxAmount: 20) }]), // New treasure map
                    "Leave it": ("leave_wreck", [{ changeCrewSatis(amount: -5) }]) // Crew disappointment
            ]),
            "map_found": GameState(dialogue: "With the map in hand, you gain valuable information on where to find further treasures beyond this island.",
                options: [
                    "Follow the map": ("treasure_found_extra", [{ changeGold(minAmount: 20, maxAmount: 50) }, { changeCrewSatis(amount: 15) }]), // Extra treasure and satisfaction
                    "Keep it for later": ("treasure_found", [])
            ]),
            "leave_wreck": GameState(dialogue: "You decide not to disturb the wreck, considering it a tomb for lost souls. Your crew respects your decision.",
                options: [
                    "Return to ship": ("treasure_found", [{ changeCrewSatis(amount: 10) }]), // Small satisfaction boost
                    "Re-evaluate the journey": ("repair_ship", [{ changeCrewSatis(amount: -5) }]) // Doubts about the quest
            ]),
            "investigate_pirates": GameState(dialogue: "You find a makeshift camp and signs of recent activity. It seems another crew has also been searching.",
                options: [
                    "Confront them": ("confront_pirates", [{ changeCrewSatis(amount: -5) }]), // Tense standoff
                    "Steal their map": ("steal_map", [{ changeGold(minAmount: 10, maxAmount: 20) }]) // Gain treasure info
            ]),
            "confront_pirates": GameState(dialogue: "The other pirates are not pleased to see you. A tense negotiation begins as you barter for safe passage or treasure.",
                options: [
                    "Trade gold for peace": ("peace_trade", [{ changeGold(amount: -10) }, { changeCrewSatis(amount: 10) }]), // Lose gold, gain peace
                    "Challenge them": ("fight_natives", [{ changeGold(minAmount: 5, maxAmount: 15) }]) // Gain gold in battle
            ]),
            "steal_map": GameState(dialogue: "Under cover of night, you manage to steal their treasure map. It's a risky move, but it pays off with the promise of more riches.",
                options: [
                    "Follow the new map": ("treasure_found_extra", [{ changeGold(minAmount: 20, maxAmount: 50) }, { changeCrewSatis(amount: 15) }]), // New path to riches
                    "Save it for later": ("treasure_found", [])
            ]),
            "peace_trade": GameState(dialogue: "You exchange some of your gold for safe passage and gain valuable information about the treasure's location.",
                options: [
                    "Pursue the treasure": ("treasure_found", [{ changeGold(minAmount: 5, maxAmount: 15) }]), // Continue hunt
                    "Call it a day": ("treasure_found", [])
            ])
        ]
    }

    
    
    static func getGameState(for key: String, gameData: [String: GameState]) -> GameState? {
        return gameData[key]
    }
}
