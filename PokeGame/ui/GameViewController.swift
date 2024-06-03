//
//  GameViewController.swift
//  PokeGame
//
//  Created by KsArT on 31.05.2024.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var statusGame: UILabel!
    @IBOutlet weak var nextDigit: UILabel!
    
    private lazy var game = Game(countItems: buttons.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func pressButtons(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        updateUI()
    }
    
    private func setupScreen() {
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].isHidden = false
            
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            buttons[index].isHidden = game.items[index].isFound
        }
        nextDigit.text = game.nextItem?.title
        
        if game.status == .win {
            statusGame.text = "Вы выйграли!"
            statusGame.textColor = .green
        }
    }
}
