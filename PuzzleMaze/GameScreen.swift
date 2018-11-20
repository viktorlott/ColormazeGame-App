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
    @IBOutlet var myView: UIView!
    @IBOutlet weak var staticTimeLabel: UILabel!
    @IBOutlet weak var backgroundFIlter: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var staticScoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    var myVal: Any?
    @IBOutlet weak var LoadingTitle: UILabel!
    @IBOutlet weak var gameArea: UIView!
    var currentMap = 0
    var sound: Sounds! = Sounds()
    @IBOutlet weak var failVal: UILabel!
    @IBOutlet weak var timeCounterLbl: UILabel!
    var isBoardNotLoaded = true;
    var wins = 0
    @IBOutlet weak var winCounter: UILabel!
    var callOnce = true
    var myGame: GameBoard<Piece>?
    var mapDefault: progMap?
    var myMapGenerator: MapGenerator!
    var useNoTime = false
    var timer: Timer!
    
    
    var selectedMap = 0
    var mapDimensions = ["3x3","4x4","5x5","6x6","7x7","8x8", "9x9", "10x10", "11x11"]
    var currentDimension = 0
    var intervalForDimension = 5
    
    var time = 50
    var customSeed: Double = 0
    
    var loseValue = -1
    var winValue = 2
    
    @IBOutlet weak var backButton: UIButton!
    deinit {
        
        print("gameScreen denit")
    }
    override func viewWillLayoutSubviews() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalTransitionStyle = .crossDissolve
        let im = UIImage.gif(name: "bg", ext: "gif")
        self.backgroundImage.image = im
        self.timeCounterLbl.text = String(self.time) + "s"
        
        
        if self.useNoTime {
            self.failVal.isHidden = true
            self.timeCounterLbl.isHidden = true
            self.staticTimeLabel.isHidden = true
        } else {
//            switch self.selectedMap {
//            case "Map": do {
//                self.winValue = 3
//                self.loseValue = -5
//                }
//            case "3x3": do {
//                self.winValue = 1
//                self.loseValue = -10
//                }
//            default: do {
//                self.winValue = 1
//                self.loseValue = -5
//                }
//
//            }
        }
        
        

    }

    override func viewDidLayoutSubviews() {
        if callOnce {
            backgroundImage.layer.zPosition = -2
            backgroundFIlter.layer.zPosition = -1
        }
 
    }
    func startGameWithTypeMap(){
//        if self.selectedMap == "Easy" {
//            self.myGame?.createNewGame(map: (self.mapDefault?.generate())! )
//        } else {

            self.myGame?.createNewGame(map: self.myMapGenerator.generate(tries: 2000) )
//        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        if self.selectedMap == "Easy" {
//            self.mapDefault = progMap()
//            self.myGame = GameBoard(board: gameArea, map: (self.mapDefault?.generate())!)
//
//        } else {
        
        self.currentDimension = self.selectedMap == 3 ? 6 : self.selectedMap
            self.myMapGenerator = self.getMapGeneratorBy(self.mapDimensions[self.currentDimension])
            self.myGame = GameBoard(board: gameArea, map: self.myMapGenerator.generate(tries: 2000))
//        }
        
        
        self.LoadingTitle.isHidden = true
        isBoardNotLoaded = false
        callOnce = false
        self.setupTimer()
        Vibration.win.vibrate()
        self.backButton.layer.cornerRadius = self.backButton.layer.bounds.height / 6
   
        self.backButton.layer.zPosition = 3
    }

    func getMapGeneratorBy(_ type: String) -> MapGenerator {
        print("awdawdaw----awdawdawd---awdawdaw", self.customSeed)
        let isHard = selectedMap >= 2 ? 4 : 1
        switch type {
        case "3x3":
            return MapGenerator(dimensions: 3, seed: 54 + self.customSeed, limit: Limit(min: 0, max: 2, unique: 1))
        case "4x4":
            return MapGenerator(dimensions: 4, seed: 150 + self.customSeed, limit: Limit(min: 0, max: 3, unique: 1))
        case "5x5":
            return MapGenerator(dimensions: 5, seed: 706 + self.customSeed, limit: Limit(min: 0, max: 4, unique: isHard))
        case "6x6":
            return MapGenerator(dimensions: 6, seed: 1233 + self.customSeed, limit: Limit(min: 0, max: 5, unique: isHard))
        case "7x7":
            return MapGenerator(dimensions: 7, seed: 2443 + self.customSeed, limit: Limit(min: 0, max: 6, unique: isHard))
        case "8x8":
            return MapGenerator(dimensions: 8, seed: 4003 + self.customSeed, limit: Limit(min: 0, max: 7, unique: isHard))
        case "9x9":
            return MapGenerator(dimensions: 9, seed: 5032 + self.customSeed, limit: Limit(min: 0, max: 4, unique: isHard))
        case "10x10":
            return MapGenerator(dimensions: 10, seed: 6443 + self.customSeed, limit: Limit(min: 0, max: 4, unique: isHard))
        case "11x11":
            return MapGenerator(dimensions: 11, seed: 7443 + self.customSeed, limit: Limit(min: 0, max: 4, unique: isHard))
        default:
            return MapGenerator(dimensions: 3, seed: 54 + self.customSeed, limit: Limit(min: 0, max: 1, unique: isHard))
        }
    }
    @IBAction func onClickBack(_ sender: Any) {
        self.presentScoreScreen()
    }
    
    
    func presentScoreScreen() {
        if self.timer != nil {
            self.timer.invalidate()
        }
        
        if let g = self.myGame {
            g.stopBoard()
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreBoardController") as! ScoreBoardController
        vc.done = self.presentStartScreen
        vc.score = "" + String(self.wins)
        
        self.present(vc, animated: true)
    }
    func setupTimer() {
        if self.useNoTime {
            
            
            return
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            if self.time <= 0 {
                self.presentScoreScreen()
            } else {
                self.time += -1
                self.updateTimeLable()
                Vibration.sound(1467).vibrate()
//                if self.time == 49 {
//                    print("wr")
//                    self.myGame?.spinAll()
//                }
//                if self.time == 48 {
//                    self.myGame?.resetspinAll()
//                }

            }
        })
        self.failVal.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    func presentStartScreen() {
        
        
        if !self.useNoTime {
            self.timer.invalidate()
        }
        self.timer = nil
        
        if let g = self.myGame {
            g.stopBoard()
        }
        
        self.sound = nil
        self.myGame = nil
        
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StartScreen") as! StartScreen
        
        self.dismiss(animated: true) {
            print("GameScreen Dismissed")
        }

//        self.present(vc, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBoardNotLoaded {return}
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouch(location.x, location.y)
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
        if timer != nil {
            timer.invalidate()
        }
        self.wins += 1
        self.currentMap += 1
        self.time += winValue
        self.myGame?.spinAll()
        self.sound.win()
        self.animate {
            self.winCounter.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        self.winCounter.text = String(self.wins)
        self.failVal.textColor = .green
        self.failVal.text = "+" + String(self.winValue)
        self.failVal.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.quickAnimate(animations: {
            self.failVal.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) {
            self.failVal.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        self.updateTimeLable()
        //        self.playSound()
        if ((self.wins % self.intervalForDimension) == 0) {
            if self.currentDimension < self.mapDimensions.count - 1{
                self.currentDimension += 1
                self.myMapGenerator = self.getMapGeneratorBy(self.mapDimensions[self.currentDimension])
            }
         
            
        }
        print(self.currentDimension, self.mapDimensions.count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startGameWithTypeMap()
            self.setupTimer()
            
            self.sound.miss()
        }
        
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
        sound.selectSound.play(atTime: 0.0001)
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





class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        let gradientLayer = layer as! CAGradientLayer
//        gradientLayer.colors = [self.rgb(35, 35, 35, 1), self.rgb(35, 35, 35, 0)]
//
        
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [self.rgb(35, 35, 35, 1), self.rgb(35, 35, 35, 0)]
        
        self.layer.addSublayer(gradientLayer)
    }
    func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> CGColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a)).cgColor
    }
}


