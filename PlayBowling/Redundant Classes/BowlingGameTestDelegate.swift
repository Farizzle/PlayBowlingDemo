//
//  BowlingGameTestDelegate.swift
//  PlayBowling
//
//  Created by Faris Zaman on 9/2/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import Foundation

import UIKit

protocol BowlingGameTestDelegate {
    func didFinishFrame(_ sender: BowlingGameTest)
    func updatePreviousFrame(_ sender: BowlingGameTest)
    func wasStrike(_ sender: BowlingGameTest)
    func wasSpare(_ sender: BowlingGameTest)
    func wasGutter(_ sender: BowlingGameTest)
    func rollOneComplete(_ sender:BowlingGameTest)
    func rollTwoComplete(_ sender:BowlingGameTest)
}
