//
//  ViewController.swift
//  PlayBowling
//
//  Created by Faris Zaman on 8/27/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MultiPlayerViewController: UIViewController, BowlingDelegate  {
    
    var game = Bowling()
    var game2 = Bowling()
    var delegate : BowlingDelegate?
    var rollString = String()
    @IBOutlet weak var rollsLabel: UILabel!
    var frameStrings = String()
    @IBOutlet weak var frameScoreLabel: UILabel!
    @IBOutlet weak var strikeImage: UIImageView!
    var playerTurn = 1
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        game2.delegate = self
        rollsLabel.sizeToFit()
        rollsLabel.numberOfLines = 0
        frameScoreLabel.sizeToFit()
        frameScoreLabel.numberOfLines = 0
        strikeImage.loadGif(name: "strike")
        strikeImage.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @IBAction func rollLeBall(){
        if (playerTurn == 1){
            game.rollBall()
            playerTurn = 2
        } else if (playerTurn == 2){
            game2.rollBall()
            playerTurn = 1
        }
    }
    
    
    
    func didFinishFrame(_ sender: Bowling) {
        if (playerTurn == 1){
            rollString.append("--------\n")
            rollsLabel.text = rollString
            frameStrings.append("Player 1 - Frame \(game.frameIndex) score : \(game.score(frameIndex: game.frameIndex))\n")
            frameScoreLabel.text = frameStrings
        } else if (playerTurn == 2){
            rollString.append("--------\n")
            rollsLabel.text = rollString
            frameStrings.append("Player 2 - Frame \(game.frameIndex) score : \(game2.score(frameIndex: game2.frameIndex))\n")
            frameScoreLabel.text = frameStrings
        }
    }
    
    func wasStrike(_ sender: Bowling) {
        strikeImage.isHidden = false
    }
    
    func wasSpare(_ sender: Bowling) {
        print("SPARE")
    }
    
    func wasGutter(_ sender: Bowling) {
        return
    }
    
    func rollOneComplete(_ sender: Bowling) {
        if (playerTurn == 1){
            rollString.append("Player 1 - Roll 1: \(game.throw1)\n")
            rollsLabel.text = rollString
            if (game.throw1 != 10){
                strikeImage.isHidden = true
            }
        } else if (playerTurn == 2){
            rollString.append("Player 2 - Roll 1: \(game2.throw1)\n")
            rollsLabel.text = rollString
            if (game2.throw1 != 10){
                strikeImage.isHidden = true
            }
        }
    }
    
    func rollTwoComplete(_ sender: Bowling, includeSecondThrow: Bool) {
        if (playerTurn == 1){
            if (includeSecondThrow){
                rollString.append("Player 1 - Roll 2: \(game.throw2)\n")
                rollsLabel.text = rollString
            }
        } else if (playerTurn == 2){
            if (includeSecondThrow){
                rollString.append("Player 2 - Roll 2: \(game2.throw2)\n")
                rollsLabel.text = rollString
            }
        }
    }
    
    func gameFinished(_ sender: Bowling) {
        frameStrings.append("--------\n")
        frameStrings.append("GAME FINISHED\n")
        frameStrings.append("Player 1 - Final Score : \(game.score(frameIndex: game.frameIndex-1))\n")
        frameScoreLabel.text = frameStrings
        frameStrings.append("--------\n")
        frameStrings.append("GAME FINISHED\n")
        frameStrings.append("Player 2 - Final Score : \(game2.score(frameIndex: game2.frameIndex-1))\n")
        frameScoreLabel.text = frameStrings
        addScoreToFireBase()
    }
    
    func addScoreToFireBase(){
        db.collection("MultiPlayer").document("\(Date())").setData([
            "Player 1 Score" : "\(game.score(frameIndex: game.frameIndex-1))",
            "Player 2 Score" : "\(game2.score(frameIndex: game2.frameIndex-1))"
        ]) { (error:Error?) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print("Document Added")
            }
        }
    }
}

