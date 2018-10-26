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


class GameController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var gameArea: UIView!

    
    var isBoardNotLoaded = true;
    
    
    var myGame: GameBoard<Piece>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myGame = GameBoard(board: gameArea, map: Maps.maze.render())
        isBoardNotLoaded = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isBoardNotLoaded {return}
        let touch = touches.first!
        let location = touch.location(in: self.gameArea)
        myGame!.onTouch(location.x, location.y)
    }
    
    @IBAction func startgame1(_ sender: Any) {
        self.myGame?.createNewGame(map: Maps.maze.render())
    }
    @IBAction func startgame2(_ sender: Any) {
        self.myGame?.createNewGame(map: Maps.smallmaze.render())
    }
    @IBAction func startgame3(_ sender: Any) {
        self.myGame?.createNewGame(map: Maps.flag.render() )
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
        myGame!.onTouchEnd(location.x, location.y)
    }

}




