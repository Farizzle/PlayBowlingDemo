//
//  ViewController.swift
//  PlayBowling
//
//  Created by Faris Zaman on 8/27/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class SinglePlayerViewController: UIViewController, BowlingDelegate  {

    var game = Bowling()
    var delegate : BowlingDelegate?
    var rollString = String()
    @IBOutlet weak var rollsLabel: UILabel!
    var frameStrings = String()
    @IBOutlet weak var frameScoreLabel: UILabel!
    @IBOutlet weak var strikeImage: UIImageView!
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
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
        game.rollBall()
    }
    
    func didFinishFrame(_ sender: Bowling) {
        rollString.append("--------\n")
        rollsLabel.text = rollString
        frameStrings.append("Frame \(game.frameIndex) score : \(game.score(frameIndex: game.frameIndex))\n")
        frameScoreLabel.text = frameStrings
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
        rollString.append("Roll 1: \(game.throw1)\n")
        rollsLabel.text = rollString
        if (game.throw1 != 10){
            strikeImage.isHidden = true
        }
    }
    
    func rollTwoComplete(_ sender: Bowling, includeSecondThrow: Bool) {
        if (includeSecondThrow){
            rollString.append("Roll 2: \(game.throw2)\n")
            rollsLabel.text = rollString
        }
    }
    
    func gameFinished(_ sender: Bowling) {
        frameStrings.append("--------\n")
        frameStrings.append("GAME FINISHED\n")
        frameStrings.append("Final Score : \(game.score(frameIndex: game.frameIndex-1))\n")
        frameScoreLabel.text = frameStrings
        addScoreToFireBase()
    }
    
    func addScoreToFireBase(){
        db.collection("SinglePlayer").document("\(Date())").setData(["Player 1 Score" : "\(game.score(frameIndex: game.frameIndex-1))"]) { (error:Error?) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                print("Document Added")
            }
        }
    }
}

