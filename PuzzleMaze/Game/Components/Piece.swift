//
//  BlockPiece.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit


struct Size {
    let width: Int
    let height: Int
}
struct Position {
    let x: CGColor
    let y: CGColor
}

class Piece {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let width: Float
    let height: Float
    let label: UILabel
    var type: Int
    var block: Block
    var connectedWith: Int?
    var isConnected: Bool = false
    
    init(id: Int, X: CGFloat, Y: CGFloat, width: Float, height: Float, type: Int, block: Block) {
        self.id = id
        self.x = X
        self.y = Y
        self.width = width
        self.height = height
        self.type = type
        self.block = block
        self.label = Piece.createPiece(x: X, y: Y, width: width, height: height, block: block)
    }
    private static func createPiece(x: CGFloat, y: CGFloat, width: Float, height: Float, block: Block) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height)))
        label.isUserInteractionEnabled = true
        
        label.layer.backgroundColor = block.color
        
        return label
    }
    func updatePiece(block: Block) {
        self.block = block
        self.label.layer.backgroundColor = self.block.color
    }
    func getBlockFrom(val: Int) -> Block {
        for block in Block.allCases {
            if type == block.type {
                return block
            }
        }
        return Block.empty
    }
}

