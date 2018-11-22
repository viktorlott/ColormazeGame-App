//
//  StartScreen.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/28/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit
//import Firebase
//
//
//class MyDataBase {
//    var ref: DatabaseReference!
//    
//    init() {
//        self.ref = Database.database().reference()
//        
//    }
//}



class StartScreen: UIViewController {
    
    
    @IBOutlet weak var highscorelbl: UILabel!
    @IBOutlet weak var bgGif: UIImageView!
    var settings: [[String]] = [["Easy", "Normal", "Hard", "Extreme"],["Timed mode", "Free mode", "Life mode"], ["Random", "Bronze", "Crap", "Diamond","Viktor"]]
    
    var selectedMap = 0
    var useTimer = 0
  
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var highscore: UILabel!
    var useNoTimer = false
    override func viewDidAppear(_ animated: Bool) {
        print("StartScreen appeared")
        
        self.setAllAnimations()
    }
    override func viewDidLoad() {
        
        

        
        
        
        if let name = UserDefaults.standard.object(forKey: "UserName") as? String {
            print("Device name:", name)
            
        } else {
            UserDefaults.standard.set(UIDevice.current.name, forKey: "UserName")
            print("set device name")
        }
       
        if let score = UserDefaults.standard.object(forKey: "Easy") as? String {
            highscore.text = score
            
        }
        
        
        super.viewDidLoad()
        setupView()
        startButton.layer.cornerRadius = startButton.layer.bounds.height / 3
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        self.fetchGif()
        startButton.titleLabel?.text = "Start Game"

        
    }
    func updateScore() {
        if let score = UserDefaults.standard.object(forKey: "Easy") as? String {
            self.highscore.text = score
            
        }
    }
    func setAllAnimations() {
        self.animateReapetBounce({
            self.highscorelbl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, {
            self.highscorelbl.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, 0)
        
        
        self.animateReapetBounce({
            self.highscore.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, {
            self.highscore.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, 0)
        
        self.animateReapetBounce({
            self.startButton.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }, {
            self.startButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, 0.2)
    }
    func fetchGif() {
        
        
        let im = UIImage.gif(name: "Dear")
        self.bgGif.image = im
    }
    func setupView() {
        view.backgroundColor = rgb(42, 42, 42, 1)
    }

    func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> UIColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a))
    }
    
    @IBAction func startGame(_ sender: Any) {
        self.startButton.titleLabel?.text = "Constructing..."
        
       
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameScreen") as! GameScreen
       
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
           
            
            vc.selectedMap = self.picker.selectedRow(inComponent: 0)
            vc.useNoTime = { () -> Bool in
                switch self.picker.selectedRow(inComponent: 1){
                case 0: return false
                case 1: return true
                default: return false
                }
            }()
            vc.customSeed = { () -> Double in
                switch self.picker.selectedRow(inComponent: 2){
                case 0: return Double.random(in: 7000..<9000)
                case 1: return 200
                case 2: return 340
                case 3: return 545
                case 4: return 700
                default: return 0
                }
            }()
            vc.updateScore = self.updateScore
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
    @IBAction func testScore(_ sender: Any) {
        
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreBoardController") as! ScoreBoardController
        
        self.present(vc, animated: true)
    }
    
    func animateReapetBounce(_ begin: @escaping () -> (), _ end: @escaping () -> (), _ delay: Double) {
        UIView.animateKeyframes(withDuration: 1.0, delay: delay, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                begin()
            })
            

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                end()
            })
        }, completion: nil)
    }
}

extension StartScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.settings[component].count
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = self.settings[component][row]
        
        let ns = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
        return ns
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.selectedMap = row
        }
        if component == 1 {
            print(row)
            self.useTimer = row
        }
        
        
    }
    

}








