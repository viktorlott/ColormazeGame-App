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
    var block: Block
    var isLit: Bool = false
    var connectedWith: Int?
    var isConnected: Bool = false
    var shrink: CGFloat = 10
    private enum Shape {
        case grow, shrink, normal
    }
    
    init(id: Int, X: CGFloat, Y: CGFloat, width: Float, height: Float, block: Block) {
        self.id = id
        self.x = X
        self.y = Y
        self.width = width
        self.height = height
        self.block = block
        self.label = Piece.createPiece(x: X, y: Y, width: width, height: height, block: block)
    }
    private static func createPiece(x: CGFloat, y: CGFloat, width: Float, height: Float, block: Block) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height)))
        label.isUserInteractionEnabled = true
        
        label.layer.backgroundColor = block.color
        label.layer.cornerRadius = label.layer.frame.height / 4
        return label
    }
    func updatePiece(block: Block) {
        self.block = block

        self.label.layer.backgroundColor = self.block.color
    }
    
    func litBlock() {
        isLit = true
        label.layer.shadowColor = block.upp().color
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 0
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        if block.isStartBlock(type: self.block.type) {
            label.layer.frame = mutateShape(val: shrink, with: .shrink)
            
        } else {
            label.layer.frame = mutateShape(val: shrink, with: .shrink)
        }
        
//        self.label.layer.borderColor = rgb(42,42,42, 1)
//        self.label.layer.borderWidth = 2
        self.label.layer.backgroundColor = self.block.color
    }
    private func mutateShape(val: CGFloat, with shape: Shape) -> CGRect {
        switch shape {
        case .grow: return CGRect(x: self.x - val / 2, y: y.self - val / 2, width: CGFloat(self.width) + val, height: CGFloat(self.height) + val)
        case .shrink: return CGRect(x: self.x + val / 2, y: y.self + val / 2, width: CGFloat(self.width) - val, height: CGFloat(self.height) - val)
        case .normal: return CGRect(x: self.x, y: y.self, width: CGFloat(self.width), height: CGFloat(self.height))
        }
    }
    func dimBlock() {
        isLit = false

        label.layer.frame = mutateShape(val: shrink, with: .normal)
        label.layer.shadowOpacity = 0

        self.label.layer.backgroundColor = self.block.color
    }
    func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> CGColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a)).cgColor
    }
    func getBlockFrom(val: Int) -> Block {
        for block in Block.allCases {
            if val == block.type {
                return block
            }
        }
        return Block.empty
    }
}

