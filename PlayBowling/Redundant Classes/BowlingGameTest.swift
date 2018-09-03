//
//  BowlingGame.swift
//  PlayBowling
//
//  Created by Faris Zaman on 8/27/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import Foundation

class BowlingGameTest : NSObject, BowlingGameTestDelegate {
    
    let maxNumberOfPins = 10
    var frameScore = 0
    var previousFrameScore = 0
    var currentFrameNumber = 1
    var rollOneScore = 0
    var rollTwoScore = 0
    var remainingPins = 0
    var totalScore = 0
    var strikeBonus = 0
    var strike = false
    var spare = false
    var bonusStrikeAccumilator = 0
    var frameTenThrows = 0
    var gameFinished = false
    var finalComboScore = false
    var rollIndex = 0
    
    var delegate : BowlingGameTestDelegate?
    
    override init() {
        super.init()
        delegate = self
    }
    
    func roll(){
        if ((0 <= frameTenThrows && frameTenThrows < 3) && currentFrameNumber <= 10){
            let randomInt2 = Int.random(in: 9..<maxNumberOfPins+1)
            let randomInt = Int.random(in: 0..<maxNumberOfPins+1)
            if (strike){
                rollBall(randomInt2, wasSpare: false, wasStrike: true)
                return
            } else if (spare){
                rollBall(randomInt2, wasSpare: true, wasStrike: false)
                return
            } else {
                rollBall(randomInt2, wasSpare: false, wasStrike: false)
                return
            }
        } else {
            endGame()
        }
    }
    
    private func rollBall(_ pins: Int, wasSpare: Bool, wasStrike: Bool){
        if (!gameFinished){
            remainingPins = maxNumberOfPins - pins
            rollOneScore = pins
            print("Roll one score: ", rollOneScore)
            delegate?.rollOneComplete(self)
            rollIndex += 1
            if (currentFrameNumber > 10 && rollOneScore == 10){
                previousFrameScore += rollOneScore
                print("Total Score: ", previousFrameScore)
                frameTenThrows += 1
                if (frameTenThrows > 2){
                    finalComboScore = true
                    endGame()
                    return
                }
                return
            }
            
            if(wasSpare){
                totalScore = totalScore + rollOneScore
                previousFrameScore = totalScore
                print("Previous frame score: ", previousFrameScore)
                if (rollOneScore == 10){
                    totalScore += rollOneScore
                    print("Total score: ", totalScore)
                    bonusStrikeAccumilator = 0
                    frameComplete()
                    return
                }
                spare = false
                if(frameTenThrows == 1){
                    endGame()
                }
            }
            
            //        if (bonusStrikeAccumilator < 0 && bonusStrikeAccumilator <= 2){
            //            rollSecondBall(remainingPins, wasStrike: strike)
            //            return
            //        }
            
            if (!gameFinished){
                if (rollOneScore == 10){
                    handleStrike()
                } else {
                    rollSecondBall(remainingPins, wasStrike: strike)
                }
            }
        }
    }
    
    private func rollSecondBall(_ pins: Int, wasStrike: Bool){
        rollTwoScore = Int.random(in: 0..<remainingPins+1)
        print("Roll two score: ", rollTwoScore)
        strike = false
        delegate?.rollTwoComplete(self)
        rollIndex += 1
        frameScore = combinedRollScore(rollOne: rollOneScore, rollTwo: rollTwoScore)
        if (wasStrike){
            strikeBonus = rollOneScore + rollTwoScore
            print("Bonus strike points: ", rollOneScore + rollTwoScore)
            strike = false
            previousFrameScore = totalScore + strikeBonus
            print("Frame", currentFrameNumber-1, "score: ", previousFrameScore)
            totalScore = previousFrameScore + strikeBonus
        } else {
            frameScore = combinedRollScore(rollOne: rollOneScore, rollTwo: rollTwoScore)
            totalScore = totalScore + frameScore
        }
        print("Current frame score: ", frameScore)
        print("Total score: ", totalScore)
        checkForSpare()
        //        if (currentFrameNumber == 10){
        //            if (spare || strike){
        //                frameTenThrows += 1
        //                roll()
        //            }
        //        }
        //        frameComplete()
        return
    }
    
    func isStrike()->Bool{
        return true
    }
    
    func isSpare()->Bool{
        return true
    }
    
    func combinedRollScore(rollOne: Int, rollTwo: Int) -> Int {
        frameScore = rollOne + rollTwo
        return frameScore
    }
    
    func checkForSpare(){
        if(rollTwoScore == remainingPins){
            print("WAS A SPARE!!!")
            spare = isSpare()
            if (currentFrameNumber == 10){
                print("EXTRA THROW")
                frameTenThrows += 1
                if (frameTenThrows >= 2){
                    currentFrameNumber += 1
                    frameComplete()
                    return
                }
            } else {
                frameComplete()
            }
        }
        else {
            frameComplete()
        }
       
    }
    
    func handleStrike(){
        print("WAS A STRIKE")
        delegate?.wasStrike(self)
        totalScore = totalScore + rollOneScore
        strike = isStrike()
        if(bonusStrikeAccumilator > 2){
            strikeBonus = 10 + rollOneScore + 10
            print("Bonus strike points: ", strikeBonus)
            totalScore = totalScore + strikeBonus
            bonusStrikeAccumilator = 0
        }
        print("Frame", currentFrameNumber-1, "score: ", previousFrameScore)

        print("Total Frame Score: ", totalScore)

        bonusStrikeAccumilator += 1
        if (currentFrameNumber >= 10){
            return
        } else {
            frameComplete()
        }
    }
    
    func endGame(){
        if (gameFinished){
            return
        } else {
            if (finalComboScore){
                print("Final Score : ", previousFrameScore)
            } else {
                print("Final Score : ", totalScore)
            }
            gameFinished = true
            frameTenThrows += 1
        }
    }
    
    func frameComplete(){
        print("Frame: ", currentFrameNumber, " Completed")
        currentFrameNumber = currentFrameNumber+1
        remainingPins = maxNumberOfPins
        rollOneScore = 0
        rollTwoScore = 0
        delegate?.didFinishFrame(self)
    }
    
    func didFinishFrame(_ sender: BowlingGameTest) {
        return
    }
    
    func updatePreviousFrame(_ sender: BowlingGameTest) {
        return
    }
    
    func wasStrike(_ sender: BowlingGameTest) {
        return
    }
    
    func wasSpare(_ sender: BowlingGameTest) {
        return
    }
    
    func wasGutter(_ sender: BowlingGameTest) {
        return
    }
    
    func rollOneComplete(_ sender: BowlingGameTest) {
        return
    }
    
    func rollTwoComplete(_ sender: BowlingGameTest) {
        return
    }

}


