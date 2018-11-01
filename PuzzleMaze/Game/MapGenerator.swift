//
//  MapGenerator.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 11/1/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation

func LCG(seed: Double) -> () -> Double {
    let m = 4194301.0
    let a = 914334.0
    let c = 1406151.0
    var z = seed
    return {
        z = (a * z + c).truncatingRemainder(dividingBy: m)
        return z / m
    }
}

class MapGenerator {
    var random = LCG(seed: 10)
    var map = [[Int]]()
    private let directions = [[-1, 0], [1, 0],[0, -1],[0, 1]]
    private var dimensions = Int()
    private var seed = Double()
    
    struct ColorItem {
        let color: Block!
        let limits: Limit!
    }
    struct Limit {
        var min: Double = 0
        var max: Double = 10
        var unique: Int = 2
    }
    
    init(dimensions: Int, seed: Double) {
        self.map = self.createEmptyMap(dimensions: dimensions)
        self.dimensions = dimensions
        self.random = LCG(seed: seed)
        self.seed = seed

        
    }
    func random(min: Int, max: Int) -> Int {
        return Int( (self.random() * (Double(max - min + 1) + Double(min))).rounded(.down))
    }
    func createEmptyMap(dimensions: Int) -> [[Int]] {
        var newMap = [[Int]]()
        for r in 0..<dimensions {
            newMap.append([0])
            for _ in 0..<(dimensions - 1) {
                newMap[r].append(0)
            }
        }
        return [[Int]](repeating: [Int](repeating: 0, count: dimensions), count: dimensions)
    }
    func clone(map: [[Int]]) -> [[Int]] {
        var clonedMap = [[Int]](repeating: [Int](repeating: 0, count: self.dimensions), count: self.dimensions)
        for r in 0..<map.count {
            for c in 0..<map[r].count {
                clonedMap[r][c] = map[r][c]
            }
        }
        return clonedMap
    }
    
    func randomStartingPositionFor(map: [[Int]]) -> [Int] {
        var availablePositions = [[Int]]()
        for r in 0..<map.count {
            for c in 0..<map[r].count {
                if map[r][c] == 0 {
                    availablePositions.append([r, c])
                }
            }
        }
        return availablePositions[Int((self.random() * Double(availablePositions.count)).rounded(.down))]
    }
    func createColoredPath(color: Block, limit: Limit) {
        var trials = 0
        var randomLength = self.random(min: Int(limit.min), max: Int(limit.max))
        var storedDir = [[Int]]()
        var mMap = self.clone(map: self.map)
        var startingPositions = self.randomStartingPositionFor(map: self.map)
        var currentRow = startingPositions[0]
        var currentColumn = startingPositions[1]
        
        let maxLength = limit.max + 1
        mMap[currentRow][currentColumn] = color.type
        
        var randomDirection = [Int]()
        
        while (trials < Int(maxLength)) {
            var isNotRightDirection = true
            randomDirection = self.directions[self.random(min: 0, max: self.directions.count - 1)]
            
            let tries = 50
            var i = 0
            
            while (isNotRightDirection) {
                i += 1
                if i >= tries {
                    mMap[currentRow][currentColumn] = color.type
                    isNotRightDirection = false
                    return
                }
                
                var tempDir = self.directions[self.random(min: 0, max: self.directions.count - 1)]
                
                if ((i < tries) && (((currentRow == 0) && (tempDir[0] == -1)) ||
                    ((currentColumn == 0) && (tempDir[1] == -1)) ||
                    ((currentRow == self.dimensions - 1) && (tempDir[0] == 1)) ||
                    ((currentColumn == self.dimensions - 1) && (tempDir[1] == 1)))) {
                    continue
                }
                
                if ((mMap[currentRow + tempDir[0]][currentColumn + tempDir[1]] == 0)) {
                    
                        randomDirection = tempDir
                        isNotRightDirection = false
                        continue;
                }
                
            }
            
            
            if ((mMap[currentRow + randomDirection[0]][currentColumn + randomDirection[1]] != 0) && (((currentRow == 0) && (randomDirection[0] == -1)) ||
                ((currentColumn == 0) && (randomDirection[1] == -1)) ||
                ((currentRow == self.dimensions - 1) && (randomDirection[0] == 1)) ||
                ((currentColumn == self.dimensions - 1) && (randomDirection[1] == 1)))) {
                trials += 1
                continue
            } else {
                storedDir.append([randomDirection[0], randomDirection[1]])
                currentRow += randomDirection[0];
                currentColumn += randomDirection[1];
                mMap[currentRow][currentColumn] = 1;
                trials += 1
            }
        }
        
        if(storedDir.count > randomLength) {

            mMap[currentRow][currentColumn] = color.type;
            self.map = self.clone(map: mMap)
            return;
            
        }
    }
}


extension MapGenerator {
    func checkMapForColorUniques(_ color: Block, unique: Int) -> Bool {
        var unique = 0
        for r in 0..<self.map.count {
            for c in 0..<self.map[r].count {
                if self.map[r][c] == color.type {
                    unique += 1
                    if unique >= (unique * 2){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func generateRandomVariables(loops: Int, limit: Limit) -> [ColorItem] {
        var colors = Block.allColors()
        var randomVariables = [ColorItem]()
        for _ in 0..<loops {
            randomVariables.append(ColorItem(color: colors[self.random(min: 0, max: colors.count - 1)], limits: limit))
        }
        return randomVariables
    }
    func generate(size: Int, limit: Limit) -> [[Int]]{
        self.seed += 3
        self.random = LCG(seed: self.seed)
        var colorList = self.generateRandomVariables(loops: size, limit: limit)
        for i in 0..<colorList.count {
            
            self.createColoredPath(color: colorList[i].color, limit: colorList[i].limits)
            
            if limit.unique > 0 {
                if self.checkMapForColorUniques(colorList[i].color, unique: limit.unique) {
                    colorList = colorList.filter({$0.color.type != colorList[i].color.type})
                    
                }
            }
        }
        let newMap = self.clone(map: self.map)
        self.map = self.createEmptyMap(dimensions: self.dimensions)
        return newMap
    }
}
