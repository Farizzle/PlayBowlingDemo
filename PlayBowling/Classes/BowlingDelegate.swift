//
//  BowlingDelegate.swift
//  PlayBowling
//
//  Created by Faris Zaman on 9/2/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import Foundation

protocol BowlingDelegate {
    func didFinishFrame(_ sender: Bowling)
    func wasStrike(_ sender: Bowling)
    func wasSpare(_ sender: Bowling)
    func rollOneComplete(_ sender:Bowling)
    func rollTwoComplete(_ sender:Bowling)
    func gameFinished(_ sender: Bowling)
}
