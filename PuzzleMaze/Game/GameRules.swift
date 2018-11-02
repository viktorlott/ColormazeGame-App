//
//  GameRules.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/23/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit

protocol GameRules {
    var selectedPiece: Piece! {get set}
    var mapShape: MapShape! {get set}
    var pieceSize: PieceSize! {get set}
    var position: Int! {get set}
    var gameRenderMap: [Int] {get set}
    var gamePieces: [Piece] {get set}
    var touchArea: CGFloat {get set}
    func touchCollideWithPiece(_ x: CGFloat, _ y: CGFloat, _ p: Piece) -> Bool
    func isColoredBlock(_ type: Int) -> Bool
    func isWall(_ type: Int) -> Bool
    func isNotEmpty(_ type: Int) -> Bool
    func isPieceConnected(_ p: Piece) -> Bool
    func cannotMoveToPiece(_ p: Int) -> Bool
    func checkIfBoardIsFilled() -> Bool
    func isNeighborSameColor(p: Int) -> Bool
}

extension GameRules {
    func touchCollideWithPiece(_ x: CGFloat, _ y: CGFloat, _ p: Piece) -> Bool {
        if isColoredBlock(p.block.type) {
            if x >= p.x - touchArea - 5 && x <= p.x + touchArea + 5 + CGFloat(p.width) && y >= p.y - touchArea - 5 && y <= p.y + touchArea + 5 + CGFloat(p.height) {
                return true
            }
        } else {
        if x >= p.x - touchArea && x <= p.x + touchArea + CGFloat(p.width) && y >= p.y - touchArea && y <= p.y + touchArea + CGFloat(p.height) {
            return true
        } else {
            return false
        }
    }
        return false
    }
    
    func isNearSelectedBlock(_ x: CGFloat, _ y: CGFloat, _ p: Piece) -> Bool {

        if x >= p.x - touchArea - CGFloat(p.width) && x <= p.x + touchArea + CGFloat(p.width) + CGFloat(p.width) && y >= p.y - touchArea - CGFloat(p.width) && y <= p.y + touchArea + CGFloat(p.width) + CGFloat(p.height) {
                return true
        } else {
            return false
        }
    }
    
    func isColoredBlock(_ type: Int) -> Bool {
        if type % 10 == 0 && type != Block.wall.type {
            return true
        } else {
            return false
        }
    }
    func isWall(_ type: Int) -> Bool {
        if type == Block.wall.type {
            return true
        } else {
            return false
        }
    }
    func isNotEmpty(_ type: Int) -> Bool {
        if type == Block.empty.type {
            return false
        } else {
            return true
        }
    }
    func isPieceConnected(_ p: Piece) -> Bool {
        if p.isConnected == true {
            return true
        }
        return false
    }
    func cannotMoveLeftOverCorner(_ p: Int) -> Bool {
        if p == mapShape.column - 1 && self.position == mapShape.column {
            return false
        }
        return true
    }
    func cannotMoveRightOverCorner(_ p: Int) -> Bool {
        if p == mapShape.column && self.position == mapShape.column - 1 {
            return false
        }
        return true
    }
    func cannotMoveToPiece(_ p: Int) -> Bool{
        //p != Block.empty.type && Bugg
        if !cannotMoveRightOverCorner(p) || !cannotMoveLeftOverCorner(p){ return true }
        
        if  p == self.position - 1 || p == self.position + 1 || p == self.position + self.mapShape.column || p == self.position - self.mapShape.column {
            return false
        } else {
            return true
        }
    }
    func checkIfBoardIsFilled() -> Bool {
        for piece in gamePieces {
            if piece.block.type == Block.empty.type {
                return false
            }
        }
        return true
    }
    func checkIfPiecesIsConnected() -> Bool{
        for piece in gamePieces where piece.isConnected == false && isColoredBlock(piece.block.type){
            return false
        }
        return true
    }
    func isNeighborSameColor(p: Int) -> Bool {
        if p == position + 1 || p == position - 1 || p == position + self.mapShape.column || p == position - self.mapShape.column {
            return true
        } else {
            return false
        }
        
    }
    func noPieceSelected() -> Bool {
        if selectedPiece == nil {
            return true
        }
        return false
    }
}
