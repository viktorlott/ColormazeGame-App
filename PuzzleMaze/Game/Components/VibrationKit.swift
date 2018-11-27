//
//  VibrationKit.swift
//  PuzzleMaze
//
//  Created by Viktor Lott on 10/25/18.
//  Copyright © 2018 Viktor Lott. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AudioToolbox
import CoreAudioKit



class Sounds {
    var player = AVAudioPlayer()
    var selectSound = AVAudioPlayer()
    var missSound: SystemSoundID = 0
    var moveSound = AVAudioPlayer()
    var test: SystemSoundID = 0
    var winSound: SystemSoundID = 0
    
    var bubbleMissSound: SystemSoundID = 0
     var bubbleHighSound: SystemSoundID = 0
    init() {
        loadSounds()
    }
    func play() {
        AudioServicesPlaySystemSound(test)
    }
    func miss() {
        AudioServicesPlaySystemSound(missSound)
    
    }
    func win() {
        AudioServicesPlaySystemSound(winSound)
    }
    func missBubble() {
        AudioServicesPlaySystemSound(bubbleMissSound)
    }
    func bubbleHigh() {
        AudioServicesPlaySystemSound(bubbleHighSound)
    }
    func loadSounds() {
        do {
            if let sURL = Bundle.main.url(forResource: "bubbleMove", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(sURL as CFURL, &test)
            }
            
            if let sURL = Bundle.main.url(forResource: "miss", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(sURL as CFURL, &missSound)
            }
            if let sURL = Bundle.main.url(forResource: "test", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(sURL as CFURL, &winSound)
            }
            if let sURL = Bundle.main.url(forResource: "bubbleMissSound", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(sURL as CFURL, &bubbleMissSound)
            }
            
            if let sURL = Bundle.main.url(forResource: "bubbleHighSound", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(sURL as CFURL, &bubbleHighSound)
            }
            
            
            selectSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath : Bundle.main.path(forResource: "bubbleMoveSound", ofType : "wav")!))
            
            selectSound.prepareToPlay()
            
            
            moveSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath : Bundle.main.path(forResource: "bubbleMove", ofType : "wav")!))
            
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath : Bundle.main.path(forResource: "test", ofType : "wav")!))
//            moveSound.prepareToPlay()
            
        } catch {
            print ("There is an issue with this code!")
        }
    }
}
enum Vibration {
    case win, win2, miss, miss2, miss3, miss4, miss5, oldSchool, dotSound, segue, startBlock, move, sound(Int), tick
    
    func isMuted() -> Bool {
        return true
    }
    func vibrate() {
        
        switch self {
        case .win:
            AudioServicesPlaySystemSound(SystemSoundID(1034))
        case .win2:
            AudioServicesPlaySystemSound(SystemSoundID(1035))
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .dotSound:
            AudioServicesPlaySystemSound(SystemSoundID(1104))
        case .miss:
            AudioServicesPlaySystemSound(SystemSoundID(1052))
        case .miss2:
            AudioServicesPlaySystemSound(SystemSoundID(1053))
        case .miss3:
            AudioServicesPlaySystemSound(SystemSoundID(1054))
        case .miss4:
            AudioServicesPlaySystemSound(SystemSoundID(1056))
        case .miss5:
            AudioServicesPlaySystemSound(SystemSoundID(1104))
        case .segue:
             AudioServicesPlaySystemSound(SystemSoundID(1100))
        case .sound(let val):
             AudioServicesPlaySystemSound(SystemSoundID(val))
        case .startBlock:
            AudioServicesPlaySystemSound(SystemSoundID(1130))
        case .move:
            AudioServicesPlaySystemSound(SystemSoundID(1397))
        case .tick:
            AudioServicesPlaySystemSound(SystemSoundID(1467))
        }
        
        
    }
    
}
