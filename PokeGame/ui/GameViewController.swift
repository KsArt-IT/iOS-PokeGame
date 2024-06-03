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
    @IBOutlet weak var timerGame: UILabel!
    
    @IBOutlet weak var newGame: UIButton!
    
    private lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        guard let self = self else { return }
        self.timerGame.text = time.secondsToString()
        self.timerGame.isHidden = !Settings.shared.currentSettings.timerState
        self.updateInfoGame(with: status)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
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
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
        }
        
        nextDigit.text = game.nextItem?.title
    }
    
    private func updateUI() {
        for index in game.items.indices {
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] (_) in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }
            }
        }
        nextDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusGame.text = "Игра началась..."
            statusGame.textColor = .black
            newGame.isHidden = true
        case .win:
            statusGame.text = "Вы выиграли!"
            statusGame.textColor = .green
            newGame.isHidden = false
        case .lose:
            statusGame.text = "Вы проиграли!"
            statusGame.textColor = .red
            newGame.isHidden = false
        }
    }
}
