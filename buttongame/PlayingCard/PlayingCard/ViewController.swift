//
//  ViewController.swift
//  PlayingCard
//
//  Created by 庞力鑫 on 2023/06/05.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        for _ in 1...10{
            if let card = deck.draw(){
                print("\(card)")
            }
            
        }
    }


}

