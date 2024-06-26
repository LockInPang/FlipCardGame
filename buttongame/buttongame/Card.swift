//
//  Card.swift
//  buttongame
//
//  Created by 庞力鑫 on 2023/05/30.
//

import Foundation

struct Card: Hashable
{
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var identifier: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    

    var isFaceUp = false
    var isMatched = false
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
