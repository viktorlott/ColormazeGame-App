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
class Box: UILabel {
    
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
    var mutatingSizeValue: CGFloat = 5
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
        label.layer.cornerRadius = (label.layer.frame.height) / 4
        return label
    }
    func updatePiece(block: Block) {
        self.block = block
//        if block.isStartBlock(type: self.block.type) {
//            self.label.layer.backgroundColor = self.block.getBlockFrom(val: self.block.type).upp().color
//            return
//        }
        self.label.layer.backgroundColor = self.block.color
    }
    func ifWallUpdateSize() {
        if self.block.type == Block.wall.type {
             label.layer.frame = mutateShape(val: mutatingSizeValue, with: .grow)
            label.layer.cornerRadius = (label.layer.frame.height) / 4
        }
    }
    func litBlock() {
        isLit = true

        label.layer.shadowColor = block.upp().color
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.0
        label.layer.shadowRadius = 0
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        if block.isStartBlock(type: self.block.type) {
            animate {
                self.label.layer.frame = self.mutateShape(val: self.mutatingSizeValue, with: .grow)

            }
            self.label.layer.backgroundColor = self.block.getBlockFrom(val: self.block.type).upp().color


        } else {
            animate {
                self.label.layer.backgroundColor = self.block.color
                self.label.layer.frame = self.mutateShape(val: self.mutatingSizeValue, with: .grow)
            }

        }
        

        
    }
    private func animate(animations: @escaping () -> ()) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 500, initialSpringVelocity: 500, options: .allowAnimatedContent, animations: {animations()}) {(_) in}
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
        animate {
            self.label.layer.frame = self.mutateShape(val: self.mutatingSizeValue, with: .normal)
        }
        
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

