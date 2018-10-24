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

enum Vibration {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case oldSchool
    
    func vibrate() {
        
        switch self {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
            
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
        case .medium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
}
class GameBoard<T: Piece>: GameRules {
    
    private var gameArea: UIView!
    var mapShape: MapShape!
    var boardSize: BoardSize!
    var pieceSize: PieceSize!
    
    var defaultSpacing:Float = 10 // cant be zero
    var touchArea: CGFloat = 10
    
    var selectedPiece: Piece!
    var position: Int!
    private var canMove = true

    private var gameMap: [[Int]]
    var gameRenderMap: [Int] = [Int]()
    var gamePieces: [Piece] = [Piece]()

    init(board: UIView, map: [[Int]]) {
        self.gameArea = board
        self.gameMap = map
        
        mapShape = getRowsAndColumns(for: map)
        boardSize = getSize(for: board)
        pieceSize = getPieceSize(with: mapShape, and: boardSize)
        gameRenderMap = render(map)
        renderGameBoard()
        print("Settings:")
        print("  ", mapShape!)
        print("  ", boardSize!)
        print("  ", mapShape!)
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
        if noPieceSelected() {return}
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
                Vibration.selection.vibrate()
                position = piece.id
                let colorType = gameRenderMap[selectedPiece.id]
                piece.updatePiece(type: colorType + 1)
                gameRenderMap[position] = colorType + 1
                print("Moving ","Selected Piece:",selectedPiece.id, "Position:",position)
            }
            
        }
    }
    func onTouchEnd(_ x: CGFloat, _ y: CGFloat) {
        if noPieceSelected() {return}
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
        if noPieceSelected() {return}
        for piece in gamePieces {
            if piece.type == gameRenderMap[selectedPiece.id] + 1 {
                piece.updatePiece(type: Block.empty_block)
                gameRenderMap[piece.id] = Block.empty_block
            }
            if piece.type == selectedPiece.type {
                piece.isConnected = false
            }
        }
        position = selectedPiece.id
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
        var Y: Float = 0;
        var X: Float = 0 + pieceSize.spacing / 2;
        for (i, blockType) in gameRenderMap.enumerated() {
            let piece = Piece(id: i, X: CGFloat(X), Y: CGFloat(Y), width: pieceSize.width, height: pieceSize.height, type: blockType)
            
            piece.updatePiece(type: blockType)
            
            gameArea.addSubview(piece.label)
            gamePieces.append(piece as! T)
            X += pieceSize.width + pieceSize.spacing
            if(((i + 1) % mapShape.column) == 0) {
                Y += pieceSize.height + pieceSize.spacing
                X = 0 + pieceSize.spacing / 2
            }
        }
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
        let pS = Float(board.width) / Float(map.column)
        let space = Float(pS - (Float(Int(pS / 10) * 10)))
        let spacing = (space < self.defaultSpacing ? self.defaultSpacing : space)
        return PieceSize(width: pS - spacing, height: pS - spacing, spacing: spacing)
    }
}


