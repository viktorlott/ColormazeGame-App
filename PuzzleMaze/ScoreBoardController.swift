//
//  ScoreBoardController.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 11/18/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit

class ScoreBoardController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var rankLbl: UILabel!
    
    @IBOutlet weak var scoreLbl: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var nameLbl: UILabel!
    var updateScore: (() -> ())!
 
    var rank = "#1"
    var score = "99"
    var name = "You"
    
    var done: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .crossDissolve
       self.blurView.layer.zPosition = -1
        
        self.scoreView.layer.zPosition = 1;
        self.backBtn.layer.cornerRadius = self.backBtn.layer.frame.height / 4
        
        
        self.rankLbl.text = self.rank
        
        self.scoreLbl.text = self.score
        
        self.nameLbl.text = self.name
        
        
        
        if let oldscore = UserDefaults.standard.object(forKey: "Easy") as? String {
            UserDefaults.standard.set(self.score, forKey: "Easy")
            
        } else {
            UserDefaults.standard.set(self.score, forKey: "Easy")
            
        }
        
    }

    @IBAction func closePopup(_ sender: Any) {
        
        self.dismiss(animated: true) {
            if let d = self.done {
                d()
                self.updateScore()
            }
        }
        
 
        
    }
    
}
