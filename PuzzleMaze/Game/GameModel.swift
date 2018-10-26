//
//  GameModel.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit


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
    
    private var gameArea: UIView!
    var mapShape: MapShape!
    var boardSize: BoardSize!
    var pieceSize: PieceSize!
    
    var defaultSpacing: Float = 5 // cant be zero
    var touchArea: CGFloat   = 10
    
    var selectedPiece: Piece!
    var position: Int!
    private var canMove = true

    private var gameMap = [[Int]]()
    var gameRenderMap   = [Int]()
    var gamePieces      = [Piece]()

    init(board: UIView, map: [[Int]]) {
        self.gameArea = board
        self.gameMap = map
        
        mapShape = getRowsAndColumns(for: map)
        boardSize = getSize(for: board)
        pieceSize = getPieceSize(with: mapShape, and: boardSize)
        gameRenderMap = render(map)
        
        renderGameBoard()
        printSettings()
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
        printSettings()

    }
    func printSettings() {
        print("Settings:")
        print("  ", mapShape!)
        print("  ", boardSize!)
        print("  ", pieceSize!)
    }
    func onTouch(_ x: CGFloat, _ y: CGFloat) {
        if let piece = getPieceFromCoord(x: x, y: y) {
            if isColoredBlock(piece.block.type) {
                selectedPiece = piece as! T
                selectedPiece.isLit = true
                selectedPiece.litBlock()
                
                position = piece.id
                print("Begin ", "Selected Piece:",selectedPiece.id)
            }
        }
    }
    func onTouchMove(_ x: CGFloat, _ y: CGFloat) {
        if noPieceSelected() {return}
        if let piece = getPieceFromCoord(x: x, y: y) {
            if piece.block.type == selectedPiece.block.type {
                if piece.id == position {canMove = true}
                if piece.id != selectedPiece.id || (isPieceConnected(piece) && isColoredBlock(piece.block.type)){
                    piece.litBlock()
                    canMove = false
                    return
                }
            }
            if cannotMoveToPiece(piece.id) || isWall(piece.block.type) || isNotEmpty(piece.block.type){return}
            if canMove {
                
                position = piece.id
                piece.updatePiece(block: selectedPiece.block.upp())
                gameRenderMap[position] = selectedPiece.block.upp().type
                piece.litBlock()
                print("Moving ","Selected Piece:",selectedPiece.id, "Position:",position)
            }
            
        }
    }
    func onTouchEnd(_ x: CGFloat, _ y: CGFloat) {
        if noPieceSelected() {return}
        if let piece = getPieceFromCoord(x: x, y: y) {
            if piece.block.type == selectedPiece.block.type  {
                print("End ","Selected Piece:",selectedPiece.id, "Position:",position, "End Piece:", piece.id)
                if piece.id != selectedPiece.id && isNeighborSameColor(p: piece.id) && piece.isConnected == false {
                    
                    print("connected")
                    piece.isConnected = true
                    piece.litBlock()
                    piece.isLit = true
                    selectedPiece.isConnected = true
                    selectedPiece.connectedWith = piece.id
                    
                    
                    if checkIfBoardIsFilled() && checkIfPiecesIsConnected() {selectedPiece = nil;print("Board is filled", " All pieces is connected")}
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
        position = selectedPiece.id
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
            
            gameArea.addSubview(piece.label)
            gamePieces.append(piece as! T)
            X += pieceSize.width + pieceSize.spacing
            if(((i + 1) % mapShape.column) == 0) {
                Y += pieceSize.height + pieceSize.spacing
                X = 0 + offsetX + pieceSize.spacing / 2
            }
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
        let space = Float(pS - (Float(Int(pS / 10) * 10)))
        let spacing = (space < self.defaultSpacing ? self.defaultSpacing : space)
        return PieceSize(width: pS - spacing, height: pS - spacing, spacing: spacing)
    }

}


