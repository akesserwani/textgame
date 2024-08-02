//
//  HomeViewController.swift
//  textgame
//
//  Created by Ali Kesserwani on 7/22/24.
//

import UIKit

// View Controller for the home screen
class HomeViewController: UIViewController {
    
    //actively changing data -> Gold, Ship condition, Crew Satisfaction
    //Label to display current gold amount
    @IBOutlet weak var goldLabel: UILabel!
    //Label to display ship condition
    @IBOutlet weak var shipCondition: UILabel!
    //Label to display crew satisfaction
    @IBOutlet weak var crewSatisfaction: UILabel!
    
    //label to dispay current text on the dialogue
    @IBOutlet weak var dialogueText: UITextView!
        
    //Variable to hold the mission passed from MissionViewController
    var mission: String?
    
    // Variable to hold the current game data
    var currentGameData: [String: GameState] = [:]

    //Outlets for options buttons
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dialogueText.isEditable = false
        dialogueText.isSelectable = false

        //Check to see what game is loaded from the Missions options
        if mission == "Raid Ships"{
            currentGameData = GamePlay.raidShipsGame()
        } else if mission == "Search for Treasure" {
            currentGameData = GamePlay.searchForTreasure()
        } else if mission == "Start New Game" {
            print("Start a Name Game")
            //create function to restart
            
        }
        //reset everything
        else {
            dialogueText.text = "Start a New Game in Missions"
            //hide option buttons when there is no game
            option1.isHidden = true
            option2.isHidden = true
        }
        
        //update game UI
        updateUI()
        
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
    
    
    var currentStateKey: String = "start"

    //function to update the UI
    func updateUI() {
        guard let state = GamePlay.getGameState(for: currentStateKey, gameData: currentGameData) else { return }

        dialogueText.text = state.dialogue
        let options = Array(state.options.keys)
        
        if options.count > 0 {
            option1.setTitle(options[0], for: .normal)
            option1.isHidden = false
        } else {
            option1.isHidden = true
        }
        
        if options.count > 1 {
            option2.setTitle(options[1], for: .normal)
            option2.isHidden = false
        } else {
            option2.isHidden = true
        }
    }
    
    //Button 1 to render new dialogues
    @IBAction func option1(_ sender: Any) {
        handleOption(selectedOption: option1.title(for: .normal))
    }
    
    //Button 2 to render new dialogues
    @IBAction func option2(_ sender: Any) {
        handleOption(selectedOption: option2.title(for: .normal))
    }
    
    func handleOption(selectedOption: String?) {
        guard let selectedOption = selectedOption,
              let state = GamePlay.getGameState(for: currentStateKey, gameData: currentGameData),
              let nextState = state.options[selectedOption] else { return }
        
        for action in nextState.actions {
            action()
        }
        
        currentStateKey = nextState.nextState
        updateUI()
    }

}
