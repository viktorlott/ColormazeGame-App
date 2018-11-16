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
    case invisible
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
    case orange_start
    case orange
    case purple_start
    case purple
    case teal_start
    case teal
    
    case brown_start
    case brown
    
    case pink_start
    case pink

    case budgreen_start
    case budgreen

    
    var type: Int {
        get{
            switch self {
            case .invisible: return -1
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
                
            case .orange_start: return 50
            case .orange: return 51
                
            case .purple_start: return 60
            case .purple: return 61
            
            case .teal_start: return 70
            case .teal: return 71
            
            case .brown_start: return 80
            case .brown: return 81
                
            case .pink_start: return 90
            case .pink: return 91
                
            case .budgreen_start: return 100
            case .budgreen: return 101
            }
        }
    }
    var color: CGColor {
        get {
            let a: Float = 0.5
            switch self {
            case .invisible: return rgb(1, 1, 1, 0)
            case .wall: return rgb(255, 255, 255, 0.3)
            case .empty: return rgb(255, 255, 255, 0.05)
                
            case .green_start: return rgb(0, 255, 0, a)
            case .green: return rgb(0, 255, 0, 1)
                
            case .yellow_start: return rgb(255, 255, 0, a)
            case .yellow: return rgb(255, 255, 0, 1)
                
            case .blue_start: return rgb(0, 102, 255, a)
            case .blue: return rgb(0, 102, 255, 1)
                
            case .red_start: return rgb(255, 51, 0, a)
            case .red: return rgb(255, 51, 0, 1)
                
            case .orange_start: return rgb(255, 147, 0, a)
            case .orange: return rgb(255, 147, 0, 1)
                
            case .purple_start: return rgb(148, 33, 146, a)
            case .purple: return rgb(148, 33, 146, 1)
                
            case .teal_start: return rgb(0, 255, 255, a)
            case .teal: return rgb(0, 255, 255, 1)
                
            case .brown_start: return rgb(123, 63, 0, a)
            case .brown: return rgb(123, 63, 0, 1)
                
            case .pink_start: return rgb(255, 0, 127, a)
            case .pink: return rgb(255, 0, 127, 1)
                
            case .budgreen_start: return rgb(123, 182, 97, a)
            case .budgreen: return rgb(123, 182, 97, 1)
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
    static func allColors() -> [Block] {
        var colors = [Block]()
        for block in Block.allCases {
            if( block.type != 0 && (Double(block.type).truncatingRemainder(dividingBy: 10) == 0)) {
                colors.append(block)
            }
        }
        return colors
    }
}

