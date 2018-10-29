//
//  ViewController.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 9/20/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import UIKit

struct Settings {
    let mapSize: MapShape
    let pieceSize: PieceSize
}

struct Map {
    let map: [[Int]]
    let settings: Settings
    
}


class GameScreen: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var gameArea: UIView!
    var currentMap = 0
    
    var isBoardNotLoaded = true;
    var wins = 0
    @IBOutlet weak var winCounter: UILabel!
    var callOnce = true
    var myGame: GameBoard<Piece>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        if callOnce {
            print(gameArea.bounds)
            self.myGame = GameBoard(board: gameArea, map: map[currentMap])
            isBoardNotLoaded = false
            callOnce = false
        }
 
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
        myGame!.onTouchEnd(location.x, location.y) {
            self.wins += 1
            self.currentMap += 1
            self.myGame?.createNewGame(map: map[self.currentMap ] )
            winCounter.text = "Wins: " + String(wins)
        }
    }

}




