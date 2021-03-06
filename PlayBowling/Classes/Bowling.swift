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
    var gameOver = Bool()
    var frameTenThrows = Int()
    
    var delegate : BowlingDelegate?
    
    override init() {
        super.init()
        rolls = []
        frameIndex = 1
        throw1 = 0
        throw2 = 0
        frameTenThrows = 0
        delegate = self
        gameOver = false
    }
    
    func rollBall(){
        if (frameIndex < 10 && !gameOver){
            handleStandardFrames()
        } else if (frameIndex == 10  && frameTenThrows < 3) {
            handleTenthFrame()
        } else {
            if (gameOver){
            delegate?.gameFinished(self)
            gameOver = false
            }
        }
    }
    
    
    func score(frameIndex: Int)-> Int{
        var result : Int
        result = 0
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
    
    private func makeRoll(_ pins: Int){
        rolls.append(pins)
    }
    
    private func handleStandardFrames(){
        throw1 = Int.random(in: 9...10)
        makeRoll(throw1)
        delegate?.rollOneComplete(self)
        if (throw1 == 10) {
            delegate?.wasStrike(self)
            delegate?.didFinishFrame(self)
            frameIndex += 1
        } else {
            throw2 = Int.random(in: 0...10-throw1)
            makeRoll(throw2)
            delegate?.rollTwoComplete(self)
            if (throw1 + throw2 == 10){
                delegate?.wasSpare(self)
                delegate?.didFinishFrame(self)
                frameIndex += 1
            } else {
                delegate?.didFinishFrame(self)
                frameIndex += 1
            }
        }
    }
    
    private func handleTenthFrame(){
        throw1 = Int.random(in: 9...10)
        makeRoll(throw1)
        delegate?.rollOneComplete(self)
        frameTenThrows += 1
        if (frameTenThrows == 3){
            delegate?.didFinishFrame(self)
            frameIndex += 1
            gameOver = true
            return
        }
        if (throw1 == 10){
            delegate?.wasStrike(self)
            return
        } else {
            throw2 = Int.random(in: 0...10-throw1)
            makeRoll(throw2)
            delegate?.rollTwoComplete(self)
            if (throw1 + throw2 == 10){
                delegate?.wasSpare(self)
                frameTenThrows += 1
                if (frameTenThrows == 3){
                    delegate?.didFinishFrame(self)
                    frameIndex += 1
                    gameOver = true
                }
                return
            } else {
                delegate?.didFinishFrame(self)
                frameIndex += 1
                gameOver = true
            }
        }
    }
    
    private func isSpare(rollIndex: Int) -> Bool{
        return rolls[rollIndex] + rolls[rollIndex + 1] == 10
    }
    
    private func isStrike(rollIndex: Int) -> Bool{
        return rolls[rollIndex] == 10
    }
    
    private func spareScore(rollIndex: Int) -> Int{
        let validIndex2 = rolls.indices.contains(rollIndex+2)
        var additionalSpareScore = 0
        if (validIndex2){
            additionalSpareScore = 10 + rolls[rollIndex + 2]
        }
        return additionalSpareScore
    }
    
    private func strikeScore(rollIndex: Int) -> Int{
        let validIndex1 = rolls.indices.contains(rollIndex+1)
        let validIndex2 = rolls.indices.contains(rollIndex+2)
        var additionalStrikeScore = 0
        if (validIndex1 && validIndex2){
            additionalStrikeScore = 10 + rolls[rollIndex + 1] + rolls[rollIndex + 2]
        }
        return additionalStrikeScore
    }
    
    private func frameScore(rollIndex: Int) -> Int{
        return rolls[rollIndex] + rolls[rollIndex + 1]
    }
    
    func didFinishFrame(_ sender: Bowling) {
        return
    }
    
    func wasStrike(_ sender: Bowling) {
        return
    }
    
    func wasSpare(_ sender: Bowling) {
        return
    }
    
    func rollOneComplete(_ sender: Bowling) {
        return
    }
    
    func rollTwoComplete(_ sender: Bowling) {
        return
    }
    
    func gameFinished(_ sender: Bowling) {
        return
    }
    
}
