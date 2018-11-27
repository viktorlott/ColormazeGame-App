//
//  GameModel.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

struct MapShape {
    let row: Int
    let column: Int
}
struct BoardSize {
    let width: Int
    let height: Int
}
struct PieceSize {
    let width: Float
    let height: Float
    let spacing: Float
}


class GameBoard<T: Piece>: GameRules {
    var t = false
    var isInPlay = true
    var mySound = Sounds()
    private var gameArea: UIView!
    var mapShape: MapShape!
    var boardSize: BoardSize!
    var pieceSize: PieceSize!
    var sound = Sounds()
    var defaultSpacing: Float = 1// cant be zero
    var touchArea: CGFloat   = 10
    
    var missLabel: UILabel!
    
    var selectedPiece: Piece!
    var selectedPieceEnd: Piece! = nil
    var position: Int!
    private var canMove = true

    private var gameMap = [[Int]]()
    var gameRenderMap   = [Int]()
    var gamePieces      = [Piece]()

    init(board: UIView, map: [[Int]]) {
        self.gameArea = board
        self.gameMap = map
        createNewGame(map: map)
    }
    deinit {
        print("GameModel deinited")
    }
    private func updateWallSize() {
        for p in gamePieces {
            p.ifWallUpdateSize()
        }
    }
    private func removeAllElements() {
        for piece in gamePieces { piece.label.removeFromSuperview() }
        gameMap       = [[Int]]()
        gameRenderMap = [Int]()
        gamePieces    = [Piece]()
        
    }
    func createNewGame(map: [[Int]]) {
        removeAllElements()
        mapShape = getRowsAndColumns(for: map)
        boardSize = getSize(for: gameArea)
        pieceSize = getPieceSize(with: mapShape, and: boardSize)
        gameRenderMap = render(map)
        renderGameBoard()
        updateWallSize()
        printSettings()
        
        self.isInPlay = true

    }
    func printSettings() {
        print("Settings:")
        print("  ", mapShape!)
        print("  ", boardSize!)
        print("  ", pieceSize!)
    }
    func stopBoard() {
        self.canMove = false
        self.isInPlay = false
        self.clearColoredPath()
    }
    func startBoard() {
        self.isInPlay = true
        self.canMove = true
        
    }
    func onTouch(_ x: CGFloat, _ y: CGFloat) {
//        if canMove == false { return}
        if !self.isInPlay {return}
        canMove = true
        if let piece = getPieceFromCoord(x: x, y: y) {
            if isColoredBlock(piece.block.type){
                selectedPiece = piece as! T
                if piece.isLit {
                    canMove = false
//                    piece.hold() {
//
//                    }
                    piece.start?.hold {
                        
                    }
                    piece.end?.hold {
                        
                    }
//                    mySound.missBubble()
                    Vibration.sound(1130).vibrate()
                    piece.start?.release() {
                        
                    }
                    piece.end?.release() {
                        
                    }
                    selectedPiece.release() {
                        if let ep = piece.end {
                            if let sp = piece.start {
                                print("lost")
                                self.resetPiecesPaths(p: sp.start!, pos: sp.end!.id)
                            }
                        }
                        
//                        self.clearColoredPath()
                    }
                    selectedPiece = piece as! T
                    selectedPiece.isLit = true
                    selectedPiece.litBlock()
                    position = piece.id
                    canMove = true
                    return

                }
                selectedPiece.isLit = true
                selectedPiece.litBlock()
//                sound.selectSound.play()
                Vibration.sound(1130).vibrate()
//                sound.play()
                position = piece.id
                print("Begin ", "Selected Piece:",selectedPiece.id)
            }
        }
    }
    func checkIfPieceMatchPath(p: Piece, pos: Int?) -> Bool {
        
        if let mpos = pos {
            if gamePieces[mpos].connectedWith == p.id {
                return true
            }
            return checkIfPieceMatchPath(p: p, pos: gamePieces[mpos].connectedWith)
        }
        return false

    }
    func resetPiecesPath(p: Piece, pos: Int?) {
        if let mpos = pos {
            if gamePieces[mpos].connectedWith == p.id {
                gamePieces[mpos].dimBlock()
                if !isColoredBlock(gamePieces[mpos].block.type) {
                    gamePieces[mpos].updatePiece(block: Block.empty)
                    gameRenderMap[mpos] = 1
                    Vibration.sound(1397).vibrate()
                }
                if selectedPieceEnd != nil {
                    selectedPieceEnd.dimBlock()
                    Vibration.sound(1130).vibrate()
                }
                
                self.position = p.id
                return
            }

            resetPiecesPath(p: p, pos: gamePieces[mpos].connectedWith)
            gamePieces[mpos].dimBlock()
            if !isColoredBlock(gamePieces[mpos].block.type) {
                gamePieces[mpos].updatePiece(block: Block.empty)
                gameRenderMap[mpos] = 1
                Vibration.sound(1397).vibrate()
            }
            
            
            return
        }
        return
    }
    func onTouchMove(_ x: CGFloat, _ y: CGFloat) {
        if noPieceSelected()  {return}
        
        if let piece = getPieceFromCoord(x: x, y: y) {
            if piece.isConnected == true {return}
            
            if let selectEnd = selectedPieceEnd {
                if selectEnd.id != piece.id && piece.isConnected == false {
                    selectedPieceEnd.dimBlock()
                    selectedPieceEnd = nil
                }
            }
//            if t {
//                            if checkIfPieceMatchPath(p: piece, pos: position) {
//                                print("match")
//                                resetPiecesPath(p: piece, pos: position)
//                                if let sp = selectedPieceEnd {
//                                    selectedPieceEnd.dimBlock()
//                                }
//
//                                selectedPieceEnd = nil
//                                t = false
//                            }
//            }
            if !canMove {
 
//                else if gamePieces[self.position].connectedWith == piece.id {
//                    print("cant move - ", piece.id)
//                    gamePieces[self.position].dimBlock()
//                    gamePieces[self.position].updatePiece(block: Block.empty)
//                    gameRenderMap[position] = 1
//                    self.position = piece.id
//                    print("previous")
//                    Vibration.sound(1397).vibrate()
//                    selectedPieceEnd.dimBlock()
////
//                    selectedPieceEnd = nil
//                    canMove = true
//                }
                return
                
            }

            
            if piece.block.type == selectedPiece.block.type {
                if piece.id == position {canMove = true}
                if piece.isConnected == false && piece.id != selectedPiece.id && !cannotMoveToPiece(piece.id) || (isPieceConnected(piece) && isColoredBlock(piece.block.type)){


                    if selectedPieceEnd == nil {
                        Vibration.sound(1130).vibrate()
                    }
                    
                    piece.litBlock()
                    selectedPieceEnd = piece
                    selectedPieceEnd.connectedWith = position
                    
                    return
                }
            }
            if cannotMoveToPiece(piece.id) || isWall(piece.block.type) || isNotEmpty(piece.block.type){
                if piece.isConnected == false && checkIfPieceMatchPath(p: piece, pos: position) {
                    resetPiecesPath(p: piece, pos: position)
                }
//                if gamePieces[self.position].connectedWith == piece.id {
//                    gamePieces[self.position].dimBlock()
//                    gamePieces[self.position].updatePiece(block: Block.empty)
//                    gameRenderMap[position] = 1
//                    self.position = piece.id
//                    print("previous")
//                    Vibration.sound(1397).vibrate()
//                }
                return
                
            }
            if canMove  {
//                sound.play()
                
              
                piece.connectedWith = position
//                Vibration.sound(1397).vibrate()
                mySound.play()
                position = piece.id
                piece.updatePiece(block: selectedPiece.block.upp())
                gameRenderMap[position] = selectedPiece.block.upp().type
                piece.litBlock()
                print("Moving ","Selected Piece:",selectedPiece.id, "Position:",piece.id, "- connectedWith:", piece.connectedWith)
                
                
            }
            
        }
    }
    var missText = ["HAH!", "MISS", "STUPID", "U MISSED", "LOL"]
    func onTouchEnd(_ x: CGFloat, _ y: CGFloat, _ win: () -> (), _ lose: () -> ()) {
        if noPieceSelected() {return}

        if let piece = getPieceFromCoord(x: x, y: y) {
            guard selectedPieceEnd != nil else {

                showMissLabelAt(gamePieces[self.position].x, gamePieces[self.position].y, txt: missText[Int.random(in: 0..<missText.count)])
                self.resetPiecesPaths(p: piece, pos: self.position)
                lose()
                selectedPieceEnd = nil
                
                
                self.position = nil
                
                selectedPiece = nil
                selectedPieceEnd = nil
                print(gameRenderMap)
                return
            }
            
            if piece.block.type == selectedPiece.block.type || isNearSelectedBlock(x, y, selectedPieceEnd) && selectedPieceEnd.block.type == selectedPiece.block.type {
                print("End ","Selected Piece:",selectedPiece.id, "Position:",position, "End Piece:", selectedPieceEnd.id)
                if (piece.isConnected == false && piece.id != selectedPiece.id || isNearSelectedBlock(x, y, selectedPieceEnd)) && (isNeighborSameColor(p: piece.id) || isNeighborSameColor(p: selectedPieceEnd.id)) && (piece.isConnected == false || selectedPieceEnd.isConnected == false) {
                    
                    print("connected")
                    
                    selectedPieceEnd.isConnected = true
                    selectedPieceEnd.litBlock()
                    
                    selectedPieceEnd.isLit = true
                    selectedPiece.isConnected = true
                    selectedPiece.connectedWith = piece.id
                    selectedPiece.end = selectedPieceEnd
                    selectedPieceEnd.end = selectedPieceEnd
                    selectedPiece.start = selectedPiece
                    selectedPieceEnd.start = selectedPiece
                    
//                    print(selectedPiece.connectedWith, selectedPieceEnd.connectedWith)
                    selectedPiece = nil
                    selectedPieceEnd = nil
                    
                    print(piece.isConnected)
                    if checkIfBoardIsFilled() && checkIfPiecesIsConnected() {
                        selectedPiece = nil;print("Board is filled", " All pieces is connected")
                        self.isInPlay = false
                        win()
                    }
                } else {
                    
                    print("Connected wrong")
                    self.resetPiecesPaths(p: piece, pos: self.position)
//                    clearColoredPath()
                    lose()
                }
            } else {
                print("connection wrong")
                self.resetPiecesPaths(p: piece, pos: self.position)
//                clearColoredPath()

                lose()
            }
        } else {
            showMissLabelAt(CGFloat(boardSize.width / 3), CGFloat(boardSize.height / 3), txt: "MISSED")
            clearColoredPath()
            lose()
        }
        
        canMove = true
        
    }
    
    func showMissLabelAt(_ x: CGFloat, _ y: CGFloat, txt: String) {
        mySound.play()
        let missLbl = createMissLabel()
        gameArea.addSubview(missLbl)
        var dir = [(20 * CGFloat.pi / 180),(-20 * CGFloat.pi / 180), 0]
        missLbl.text = txt
        missLbl.frame = CGRect(x: x, y: y, width: 100, height: 100)
        
        missLbl.isHidden = false
        missLbl.textColor = UIColor(displayP3Red: 237/255, green: 41/255, blue: 57/255, alpha: 1)
        missLbl.alpha = CGFloat(1)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
             missLbl.alpha = CGFloat(0)
            missLbl.font = UIFont(name: "AvenirNext-Bold", size: CGFloat(30))
            missLbl.frame = CGRect(x: x + 20, y: y - 70, width: 100, height: 100)
            
            missLbl.transform = CGAffineTransform(rotationAngle: dir[Int.random(in: 0..<dir.count)]).scaledBy(x: 1.2, y: 1.2)
        }) { (_) in
            missLbl.transform = CGAffineTransform.identity
            missLbl.isHidden = true
            missLbl.removeFromSuperview()
//            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 20, options: .allowUserInteraction, animations: {
//            self.missLabel.textColor = UIColor(displayP3Red: 1, green: 1, blue: 0, alpha: 0)
//            self.missLabel.transform = CGAffineTransform.identity
//
//            }) {(_) in
//               self.missLabel.isHidden = true
//
//            }
        }
        
    }
    func createMissLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(100), height: CGFloat(100)))
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        label.text = "MISS"
        
        label.font = UIFont(name: "AvenirNext-Bold", size: CGFloat(12))
        
        label.textColor = UIColor(displayP3Red: 1, green: 1, blue: 0, alpha: 1)
        label.isHidden = true
        label.layer.zPosition = 10
        
        
        return label
        
    }
    
    private func clearColoredPath() {
        if noPieceSelected() {return}
        for piece in gamePieces {
            if piece.block.type == selectedPiece.block.upp().type {
                piece.updatePiece(block: Block.empty)
                piece.dimBlock()
                
                gameRenderMap[piece.id] = Block.empty.type
            }
            if piece.block.type == selectedPiece.block.type {
                piece.isConnected = false
            }

        }
        selectedPiece.dimBlock()
        dimAllColoredBlock()
        position = nil

        selectedPiece = nil
        selectedPieceEnd = nil
    }
    func dimAllColoredBlock() {
        for piece in gamePieces {
            if piece.block.type == selectedPiece.block.type && piece.isLit == true {
                piece.dimBlock()
            }
        }
    }
    func getAllStartingPositons(type: Int) -> [Int] {
        var pos = [Int]()
        for (i, Btype) in gameRenderMap.enumerated() {
            if Btype == type {
                pos.append(i)
            }
        }
        return pos
    }
    private func getPieceFromCoord(x:CGFloat, y: CGFloat) -> Piece? {
        for piece in gamePieces {
            if touchCollideWithPiece(x, y, piece) {
                return piece
            }
        }
        return nil
    }
    
    private func render(_ arr: [[Int]]) -> [Int] {
        var temp = [Int]()
        for row in arr {
            for column in row {
                temp.append(column)
            }
        }
        return temp
    }
    private func renderGameBoard() {
        let offsetX: Float = (Float(gameArea.frame.width) - (pieceSize.width + pieceSize.spacing) * Float(mapShape.column)) / 2
        var Y: Float = 0;
        var X: Float = 0 + offsetX + pieceSize.spacing / 2;

        for (i, blockType) in gameRenderMap.enumerated() {
            let block = getBlockFrom(type: blockType)
            let piece = Piece(id: i, X: CGFloat(X), Y: CGFloat(Y), width: pieceSize.width, height: pieceSize.height, block: block)
            
            piece.updatePiece(block: block)
            piece.fadeIn()
            
            gameArea.addSubview(piece.label)
            gamePieces.append(piece as! T)
            X += pieceSize.width + pieceSize.spacing
            if(((i + 1) % mapShape.column) == 0) {
                Y += pieceSize.height + pieceSize.spacing
                X = 0 + offsetX + pieceSize.spacing / 2
            }
        }
    }
    func spinAll() {
        for p in gamePieces {
            p.spin()
        }
    }
    func resetspinAll() {
        for p in gamePieces {
            p.resetSpin()
        }
    }
    private func getBlockFrom(type: Int) -> Block {
        for block in Block.allCases {
            if type == block.type {
                return block
            }
        }
        return Block.empty
    }
    private func getRowsAndColumns(for map: [[Int]]) -> MapShape {
        let row = map.count
        let column = map[0].count
        let size = MapShape(row: row, column: column)
        return size
    }
    private func getSize(for board: UIView) -> BoardSize {
        return BoardSize(width: Int(board.frame.width), height: Int(board.frame.height))
    }
    private func getPieceSize(with map: MapShape, and board: BoardSize) -> PieceSize {
        let biggest = (map.column > map.row ? map.column : map.row)
        let pS = Float(board.width) / Float(biggest)
//        let space = Float(pS - (Float(Int(pS / 10) * 10)))
        let spacing = self.defaultSpacing
//            (space < self.defaultSpacing ? self.defaultSpacing : space)
        return PieceSize(width: pS - spacing, height: pS - spacing, spacing: spacing)
    }

}


extension GameBoard {
    func resetPiecesPaths(p: Piece, pos: Int?) {
        if let mpos = pos {
            if gamePieces[mpos].connectedWith == p.id {
                gamePieces[mpos].dimBlock()
                if !isColoredBlock(gamePieces[mpos].block.type) {
                    gamePieces[mpos].updatePiece(block: Block.empty)
                    gameRenderMap[mpos] = 1
//                    Vibration.sound(1397).vibrate()
                }
                if selectedPieceEnd != nil {
                    selectedPieceEnd.dimBlock()
//                    Vibration.sound(1130).vibrate()
                }
                
                self.position = p.id
                p.dimBlock()
//                position = nil
//
//                selectedPiece = nil
//                selectedPieceEnd = nil
                return
            }
            
            resetPiecesPaths(p: p, pos: gamePieces[mpos].connectedWith)
            gamePieces[mpos].dimBlock()
            if !isColoredBlock(gamePieces[mpos].block.type) {
                gamePieces[mpos].updatePiece(block: Block.empty)
                gameRenderMap[mpos] = 1
//                Vibration.sound(1397).vibrate()
            }
            
            
            return
        }
        return
    }
}


