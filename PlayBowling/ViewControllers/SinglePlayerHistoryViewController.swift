//
//  SinglePlayerHistoryViewController.swift
//  PlayBowling
//
//  Created by Faris Zaman on 9/3/18.
//  Copyright © 2018 Faris Zaman. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SinglePlayerHistoryViewController: UIViewController {

    @IBOutlet weak var historySheet: UILabel!
    var historyString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let db = Firestore.firestore()
        historySheet.sizeToFit()
        historySheet.numberOfLines = 0
        
        db.collection("SinglePlayer").getDocuments()
            {
                (querySnapshot, err) in
                
                if let err = err
                {
                    print("Error getting documents: \(err)");
                }
                else
                {
                    var count = 0
                    for document in querySnapshot!.documents {
                        count += 1
                        self.historyString.append("Game: \(count) -- Date: \(document.documentID)\n\(document.data())\n\n")
                        print("\(document.documentID) => \(document.data())");
                    }
                    self.historySheet.text = self.historyString
                    print("Count = \(count)");
                }
        }
    }
}
