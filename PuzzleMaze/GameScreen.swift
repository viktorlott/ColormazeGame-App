//
//  ViewController.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 9/20/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


struct Settings {
    let mapSize: MapShape
    let pieceSize: PieceSize
}

struct Map {
    let map: [[Int]]
    let settings: Settings
    
}

protocol GameDelegate {
    func myDelegateFunc(value: Any?) -> ()
}


class GameScreen: UIViewController {
    var myVal: Any?
    @IBOutlet weak var LoadingTitle: UILabel!
    @IBOutlet weak var gameArea: UIView!
    var currentMap = 0
    var sound = Sounds()
    @IBOutlet weak var failVal: UILabel!
    @IBOutlet weak var timeCounterLbl: UILabel!
    var isBoardNotLoaded = true;
    var wins = 0
    @IBOutlet weak var winCounter: UILabel!
    var callOnce = true
    var myGame: GameBoard<Piece>?
    var map5x5 = [[[Int]]]()
    
    var timer: Timer!
    
    var time = 50
    
    var loseValue = -1
    var winValue = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeCounterLbl.text = String(self.time) + "s"

    }

    override func viewDidLayoutSubviews() {
        if callOnce {
            print(gameArea.bounds)
//            self.map5x5 = MapGenerator(dimensions: 15, seed: 10, limit: Limit(min: 10, max: 12, unique: 8)).buildMaps(size: 4, tries: 2000)
            self.myGame = GameBoard(board: gameArea, map: map[currentMap])
            self.LoadingTitle.isHidden = true
            isBoardNotLoaded = false
            callOnce = false
            self.setupTimer()
            
            Vibration.win.vibrate()
            
        }
 
    }
    func setupTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            if self.time <= 0 {
                self.time = 0
                self.timer.invalidate()
                self.timer = nil
                self.updateTimeLable()
                self.myGame!.stopBoard()
                
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameScreen") as! GameScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                self.time += -1
                self.updateTimeLable()
                Vibration.sound(1467).vibrate()

            }
        })
        self.failVal.transform = CGAffineTransform(scaleX: 0, y: 0)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBoardNotLoaded {return}
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouch(location.x, location.y)
    }
    
    @IBAction func startgame1(_ sender: Any) {
        if currentMap == 0 {return}
        currentMap -= 1
        self.myGame?.createNewGame(map: map[currentMap])
    }
    @IBAction func startgame2(_ sender: Any) {
        self.myGame?.createNewGame(map: Maps.smallmaze.render())
    }
    @IBAction func startgame3(_ sender: Any) {
        if currentMap == map.count - 1 {return}
        currentMap += 1
        self.myGame?.createNewGame(map: map[currentMap] )
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBoardNotLoaded {return}
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouchMove(location.x, location.y)

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBoardNotLoaded {return}
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouchEnd(location.x, location.y, didWin, didLose)
        animate {
            self.winCounter.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    private func didWin(){
        self.wins += 1
        self.currentMap += 1
        self.time += winValue
        self.myGame?.createNewGame(map: map[self.currentMap ] )
        animate {
            self.winCounter.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        self.winCounter.text = String(wins)
        self.failVal.textColor = .green
        self.failVal.text = "+" + String(winValue)
        self.failVal.transform = CGAffineTransform(scaleX: 1, y: 1)
        quickAnimate(animations: {
            self.failVal.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) {
            self.failVal.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        self.updateTimeLable()
//        self.playSound()
        sound.win()
//        Vibration.sound(1100).vibrate()
        //1100 1533
    }
    func didLose() {
        if self.time <= 0 {return}
        self.time += loseValue
        self.failVal.textColor = .red
        self.failVal.text = String(loseValue)
        self.updateTimeLable()
        self.failVal.transform = CGAffineTransform(scaleX: 1, y: 1)
        quickAnimate(animations: {
            self.failVal.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) {
            self.failVal.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        print("did lose")
//        missSound.play()
        sound.miss()
//        Vibration.sound(1055).vibrate()
    }
    func updateTimeLable() {
        self.timeCounterLbl.text = String(self.time) + "s"
        self.animate {
            self.timeCounterLbl.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        self.animate {
            self.timeCounterLbl.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    private func animate(animations: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 500, initialSpringVelocity: 600, options: .allowAnimatedContent, animations: {animations()}) {(_) in}
    }
    private func quickAnimate(animations: @escaping () -> (), endAnimation: @escaping () -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 500, initialSpringVelocity: 500, options: .allowAnimatedContent, animations: {animations()}) {(_) in
            endAnimation()
        }
    }
}

extension GameScreen {
   
    func myDelegateFunc(value: Any?) {
        print(value as! String)
    }

}




