//
//  GameModel.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit


class GameBoard<T: Piece>: GameRules {

    
    
    

    private var gameArea: UIView!
    var xPieces = 8
    private var yPieces = 8
    private var pieceWidth = 40
    private var pieceHeight = 40
    private let spacing = 8
    var selectedPiece: Piece!
    var position: Int = 0
    private var canMove = true
    
    // 0: No Block
    // 1: Empty Block
    // 10: Color X Start Block, 11: Color X Filled Block
    // 20: Color Y Start Block, 21: Color Y Filled Block
    // etc...
    private var gameMap: [[Int]] = [
        [10, 30,  1, 30, 20, 30, 10,  40],
        [ 1,  1,  1,  1,  1, 1,   1,  1],
        [ 1,  1, 40,  1,  1, 1,  10,  1],
        [10,  1,  1, 20, 40, 1,   40,  1],
        [ 0,  0, 10,  1, 10, 1,   1,  1],
        [ 0,  1,  1,  1,  30, 1,  0, 20],
        [ 0,  1,  0,  1,  1, 1,  0,  1],
        [20,  1,  0,  0,  0, 1,  1,  1]
        
    ]
    var gameRenderMap: [Int] = []
    
    var gamePieces: [Piece] = [Piece]();

    init(board: UIView, map: [[Int]]) {
        self.gameArea = board
        self.gameMap = map
        
        print()
        
        gameRenderMap = render(map)
        renderGameBoard()
    }
    
    func onTouch(_ x: CGFloat, _ y: CGFloat) {
        if let piece = getPieceFromCoord(x: x, y: y) {
            if isColoredBlock(piece.type) {
                selectedPiece = piece as! T
                position = piece.id
                print("Begin ", "Selected Piece:",selectedPiece.id)
            }
        }
    }
    func onTouchMove(_ x: CGFloat, _ y: CGFloat) {
        if let piece = getPieceFromCoord(x: x, y: y) {
            if piece.type == selectedPiece.type {
                if piece.id == position {canMove = true}
                if piece.id != selectedPiece.id || (isPieceConnected(piece) && isColoredBlock(piece.type)){
                    canMove = false
                    return
                }
            }
            if cannotMoveToPiece(piece.id) || isWall(piece.type) || isNotEmpty(piece.type){
                return
            }
            if canMove {
                position = piece.id
                let colorType = gameRenderMap[selectedPiece.id]
                piece.updatePiece(type: colorType + 1)
                gameRenderMap[position] = colorType + 1
                print("Moving ","Selected Piece:",selectedPiece.id, "Position:",position)
            }
            
        }
    }
    func onTouchEnd(_ x: CGFloat, _ y: CGFloat) {
        if let piece = getPieceFromCoord(x: x, y: y) {
            if piece.type == gameRenderMap[selectedPiece.id] {
                print("End ","Selected Piece:",selectedPiece.id, "Position:",position, "End Piece:", piece.id)
                if piece.id != selectedPiece.id && isNeighborSameColor(p: piece.id) && piece.isConnected == false {
                    
                    print("connected")
                    piece.isConnected = true
                    selectedPiece.isConnected = true
                    selectedPiece.connectedWith = piece.id
                    
                    if checkIfBoardIsFilled() && checkIfPiecesIsConnected() {print("Board is filled", " All pieces is connected")}
                } else {
                    print("Connected wrong")
                    clearColoredPath()
                }
            } else {
                clearColoredPath()
            }
        } else {
            clearColoredPath()
        }
        
        canMove = true
    }
    private func clearColoredPath() {
        for piece in gamePieces {
            if piece.type == gameRenderMap[selectedPiece.id] + 1 {
                piece.updatePiece(type: Block.empty_block)
                gameRenderMap[piece.id] = Block.empty_block
            }
            if piece.type == selectedPiece.type {
                piece.isConnected = false
            }
        }
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
        var Y = 0;
        var X = 0;
        for (i, blockType) in gameRenderMap.enumerated() {
            let piece = Piece(id: i, X: CGFloat(X), Y: CGFloat(Y), width: pieceWidth, height: pieceHeight, type: blockType, connectedWith: 10)
            
            piece.updatePiece(type: blockType)
            
            gameArea.addSubview(piece.label)
            gamePieces.append(piece as! T)
            X += pieceWidth + spacing
            if(((i + 1) % xPieces) == 0) {
                Y += pieceHeight + spacing
                X = 0
            }
        }
    }

}


