//
//  ViewController.swift
//  PlayBowling
//
//  Created by Faris Zaman on 8/27/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    @IBOutlet var singlePlayer: UIImageView!
    @IBOutlet var twoPlayer: UIImageView!
    
    var onePlayerStart = UITapGestureRecognizer()
    var twoPlayerStart = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

