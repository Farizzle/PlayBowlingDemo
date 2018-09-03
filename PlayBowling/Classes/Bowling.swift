//
//  BowlingGame.swift
//  bowlingTest
//
//  Created by Faris Zaman on 9/1/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import Foundation

class Bowling: NSObject, BowlingDelegate {
    
    var rolls = [Int]()
    var frameIndex = Int()
    var throw1 = Int()
    var throw2 = Int()
    var includeThrow = Bool()
    var gameOver = Bool()
    
    var delegate : BowlingDelegate?

    override init() {
        super.init()
        rolls = []
        frameIndex = 0
        throw1 = 0
        throw2 = 0
        includeThrow = true
        delegate = self
        gameOver = false
    }
    
    func rollBall(){
        if (frameIndex <= 10 && !gameOver){
            throw1 = Int.random(in: 0...10)
            makeRoll(throw1)
            delegate?.rollOneComplete(self)
            if (throw1 == 10) {
                delegate?.wasStrike(self)
                delegate?.didFinishFrame(self)
                frameIndex += 1
            } else {
                throw2 = Int.random(in: 0...10-throw1)
                makeRoll(throw2)
                includeThrow = true
                if (frameIndex >= 10 && !(isStrike(rollIndex: 19))){
                    includeThrow = false
                }
                delegate?.rollTwoComplete(self, includeSecondThrow: includeThrow)
                if (throw1 + throw2 == 10){
                    delegate?.wasSpare(self)
                    delegate?.didFinishFrame(self)
                    frameIndex += 1                    
                } else {
                    delegate?.didFinishFrame(self)
                    if(frameIndex > 10){
                        delegate?.gameFinished(self)
                        gameOver = true
                        return
                    }
                    frameIndex += 1
                }
            }
        } else {
            if (!gameOver){
                delegate?.gameFinished(self)
                gameOver = true
            }
        }
    }
    
    func makeRoll(_ pins: Int){
        rolls.append(pins)
    }
    
    func score(frameIndex: Int)-> Int{
        var result = 0
        var rollIndex = 0
        if (frameIndex < 11){
            for currentFrame in 0..<frameIndex{
                if (isStrike(rollIndex: rollIndex)){
                    result += strikeScore(rollIndex: rollIndex)
                    rollIndex += 1
                } else if (isSpare(rollIndex: rollIndex)){
                    result += spareScore(rollIndex: rollIndex)
                    rollIndex += 2
                } else {
                    result += frameScore(rollIndex: rollIndex)
                    rollIndex += 2
                }
            }
        }
        return result
    }
    
    func isSpare(rollIndex: Int) -> Bool{
        return rolls[rollIndex] + rolls[rollIndex + 1] == 10
    }
    
    private func isStrike(rollIndex: Int) -> Bool{
        return rolls[rollIndex] == 10
    }
    
    private func spareScore(rollIndex: Int) -> Int{
        return 10 + rolls[rollIndex + 2]
    }
    
    private func strikeScore(rollIndex: Int) -> Int{
        return 10 + rolls[rollIndex + 1] + rolls[rollIndex + 2]
    }
    
    private func frameScore(rollIndex: Int) -> Int{
        return rolls[rollIndex] + rolls[rollIndex + 1]
    }
    
    func didFinishFrame(_ sender: Bowling) {
        return
    }
    
    func updatePreviousFrame(_ sender: Bowling) {
        return
    }
    
    func wasStrike(_ sender: Bowling) {
        return
    }
    
    func wasSpare(_ sender: Bowling) {
        return
    }
    
    func wasGutter(_ sender: Bowling) {
        return
    }
    
    func rollOneComplete(_ sender: Bowling) {
        return
    }
    
    func rollTwoComplete(_ sender: Bowling, includeSecondThrow: Bool) {
        return
    }
    
    func gameFinished(_ sender: Bowling) {
        return
    }

}