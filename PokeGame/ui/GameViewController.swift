//
//  GameViewController.swift
//  PokeGame
//
//  Created by KsArT on 31.05.2024.
//

import UIKit

class GameViewController: UIViewController {

    
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func pressButtons(_ sender: UIButton) {
        sender.isHidden = true
        print(sender.currentTitle ?? "-")
    }
}
