//
//  BlockPiece.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/13/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit


// Should do a enum instead of struct
struct Block {
    // 0: No Block
    // 1: Empty Block
    
    // 10: Color X Start Block
    //      11: Color X Filled Block
    
    // 20: Color Y Start Block
    //      21: Color Y Filled Block
    
    // etc...
    static let wall         =  0
    static let empty_block  =  1
    
    static let green_start  = 10
    static let green_block  = 11
    
    static let yellow_start = 20
    static let yellow_block = 21
    
    static let blue_start   = 30
    static let blue_block   = 31
    
    static let red_start    = 40
    static let red_block    = 41
}

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
    var connectedWith: Int?
    var isConnected: Bool = false
    
    init(id: Int, X: CGFloat, Y: CGFloat, width: Float, height: Float, type: Int) {
        self.id = id
        self.x = X
        self.y = Y
        self.width = width
        self.height = height
        self.label = Piece.createPiece(x: X, y: Y, width: width, height: height, type: type)
        self.type = type
    }
    private static func createPiece(x: CGFloat, y: CGFloat, width: Float, height: Float, type: Int) -> UILabel {
        let label = UILabel(frame: CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height)))
        label.isUserInteractionEnabled = true
        
        label.layer.backgroundColor = applyColor(for: type)
        
        return label
    }
    static func applyColor(for type: Int) -> CGColor {
        switch type {
        case Block.empty_block: return rgb(255, 255, 255, 0.05)
        case Block.wall:        return rgb(255, 255, 255, 0.2)
        
        case Block.green_start: return rgb(0, 255, 0, 0.8)
        case Block.green_block: return rgb(0, 255, 0, 1)
            
        case Block.yellow_start: return rgb(255, 255, 0, 0.8)
        case Block.yellow_block: return rgb(255, 255, 0, 1)
            
        case Block.blue_start: return rgb(0, 102, 255, 0.8)
        case Block.blue_block: return rgb(0, 102, 255, 1)
            
        case Block.red_start: return rgb(255, 51, 0, 0.8)
        case Block.red_block: return rgb(255, 51, 0, 1)
            
        default:                return rgb(255, 255, 255, 1)
        }
    }
    static func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> CGColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a)).cgColor
    }
    func updatePiece(type: Int) {
        self.type = type
        self.label.layer.backgroundColor = Piece.applyColor(for: type)
    }
}

