//
//  Blocks.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/25/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import UIKit

enum Block: CaseIterable {
    // 0: Wall Block
    // 1: Empty Block
    
    // 10: Color X Start Block
    //      11: Color X Filled Block
    
    // 20: Color Y Start Block
    //      21: Color Y Filled Block
    
    // etc...
    case wall
    case empty
    case green_start
    case green
    case yellow_start
    case yellow
    case blue_start
    case blue
    case red_start
    case red
    
    var type: Int {
        get{
            switch self {
            case .wall: return 0
            case .empty: return 1
                
            case .green_start: return 10
            case .green: return 11
                
            case .yellow_start: return 20
            case .yellow: return 21
                
            case .blue_start: return 30
            case .blue: return 31
                
            case .red_start: return 40
            case .red: return 41
            }
        }
    }
    var color: CGColor {
        get {
            switch self {
            case .wall: return rgb(255, 255, 255, 0.2)
            case .empty: return rgb(255, 255, 255, 0.05)
                
                
            case .green_start: return rgb(0, 255, 0, 0.5)
            case .green: return rgb(0, 255, 0, 1)
                
            case .yellow_start: return rgb(255, 255, 0, 0.5)
            case .yellow: return rgb(255, 255, 0, 1)
                
            case .blue_start: return rgb(0, 102, 255, 0.5)
            case .blue: return rgb(0, 102, 255, 1)
                
            case .red_start: return rgb(255, 51, 0, 0.5)
            case .red: return rgb(255, 51, 0, 1)
            }
        }
    }
    func isStartBlock(type: Int) -> Bool {
        if type % 10 == 0 && type != Block.wall.type {
            return true
        }
        return false
    }
    func upp() -> Block {
        
        return getBlockFrom(val: self.type + 1)
    }
    func down() -> Block {
//        if self.type % 10 == 0 && type != Block.wall.type {
//            return nil
//        }
        return getBlockFrom(val: self.type - 1)
    }
    func rgb(_ r: Float, _ g: Float, _ b: Float, _ a: Float) -> CGColor {
        return UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(a)).cgColor
    }
    func getBlockFrom(val: Int) -> Block {
        for block in Block.allCases {
            if val == block.type {
                return block as Block
            }
        }
        return Block.empty
    }
    static func getBlockFrom(val: Int) -> Block {
        for block in Block.allCases {
            if val == block.type {
                return block as Block
            }
        }
        return Block.empty
    }
}

