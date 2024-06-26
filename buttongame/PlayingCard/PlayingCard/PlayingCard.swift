//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by 庞力鑫 on 2023/06/05.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    var description: String{
        return "\(rank)\(suit)"
        
    }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible{
        var description: String{ return rawValue }
        
        case spades = "♠️"
        case hearts = "♥️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all = [Suit.spades, .hearts, .diamonds, .clubs]
    }
    
    enum Rank: CustomStringConvertible{
        
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int{
            switch self{
            case .ace: return 1
            case .numeric(let pips): return pips
                
            case .face(let kind):
                switch kind{
                    case "J": return 11
                    case "Q": return 12
                    case "K": return 13
                default:
                    return 0
                }
                
            }
            
        }
        
        static var all: [Rank]{
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"), .face("Q"), .face("K")]
            
            return allRanks
        }
        var description: String{
            switch self {
            case.ace: return "A"
            case.numeric(let pips): return String(pips)
            case.face(let kind): return kind
            }
        }
    }
}
