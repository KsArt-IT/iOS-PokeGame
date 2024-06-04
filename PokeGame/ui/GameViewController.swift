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
                if game.isNewRecord {
                    showNewRecordAlert()
                } else {
                    showNextActionAlertSheet()
                }
            case .lose:
                statusGame.text = "Вы проиграли!"
                statusGame.textColor = .red
                newGame.isHidden = false
                showNextActionAlertSheet()
        }
    }
    
    private func showNewRecordAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы установили новый рекорд!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showNextActionAlertSheet() {
        let alert = UIAlertController(title: "Что вы хотите сделать далее?", message: nil, preferredStyle: .actionSheet)
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        // для iPad необходимо указать popover, иначе будет ошибка
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            // убрать стрелку popover
            popover.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        }
        
        present(alert, animated: true)
    }
}
