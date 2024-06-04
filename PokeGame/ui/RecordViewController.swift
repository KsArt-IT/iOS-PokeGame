//
//  RecordViewController.swift
//  PokeGame
//
//  Created by KsArT on 04.06.2024.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        showRecord()
    }

    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func showRecord() {
        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = "Ваш рекорд: \(record)"
        } else {
            recordLabel.text = "Рекорд еще не установлен!"
        }
    }
}
