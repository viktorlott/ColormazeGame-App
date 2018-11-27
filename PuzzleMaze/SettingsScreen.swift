//
//  SettingsViewController.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 11/21/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit

protocol SetSettingsDelegate {
    func setDifficulty() -> ()
    func setGameMode() -> ()
    func setSeed() -> ()
}

class MyButton: UIButton {
    override func draw(_ rect: CGRect) {
         self.layer.cornerRadius = self.layer.frame.height / 4
    }
    
}

class SettingsScreen: UIViewController {
    var type: String!
    
    var pickerList: [String]!
    var currentlySelected = 0
    var difficultyList = ["Easy", "Normal", "Hard", "BIG"]
    var gamemodeList = ["Timed mode", "Free mode", "Life mode"]
    var settingsDelegate: SetSettingsDelegate!
    @IBOutlet weak var settingsPicker: UIPickerView!
    
    @IBOutlet weak var changeButton: MyButton!
    @IBOutlet weak var cancelButton: MyButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var settingsTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeSettingsView(type: self.type)
        setupSettingsPicker()
        blurView.layer.zPosition = -1
        

    }
    deinit {
        print("settings view deinited")
    }
    
    
    @IBAction func changeOnPress(_ sender: Any) {
    }
    @IBAction func cancelOnPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func changeSettingsView(type: String) {
        switch type {
        case "difficulty": do {
            self.settingsTitle.text = "SET DIFFICULTY"
            self.pickerList = self.difficultyList
            
            }
        case "mode": do {
            self.settingsTitle.text = "SET GAME MODE"
            self.pickerList = self.gamemodeList
            }
        default:
            print("adawd")
            break
        }
    }
    
    func hideSettingsPicker() {
        self.settingsPicker.isHidden = true
    }
    
}

extension SettingsScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupSettingsPicker() {
        
        self.settingsPicker.delegate = self
        self.settingsPicker.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = self.pickerList[row]
        
        let ns = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return ns
    }
    
}
