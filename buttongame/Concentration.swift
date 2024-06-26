//
//  Concentration.swift
//  buttongame
//
//  Created by 庞力鑫 on 2023/05/30.
//

import Foundation

struct Concentration{
    
    private(set) var cards = [Card]()
    private(set) var playerName: String = ""
    var startTime: Date?
    var flipCount: Int = 0
    
    //检测是否所有卡片都完成匹配
    var isAllMatched: Bool{
        return cards.allSatisfy { card in
            return card.isMatched
        }
    }
    
    //将所有卡片翻转到背面向下用于重置
    mutating func resetCards(){
        for index in cards.indices{
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
    }
    
    //获取只有一张卡正面朝上的时候该卡的index
    var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
             }
            set{
                for index in cards.indices{
                    cards[index].isFaceUp = (index == newValue)
                }
                
            }
        }
        
        mutating func chooseCard(at index: Int){
            if !cards[index].isMatched{
                flipCount += 1
                if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                    //检测卡片匹配
                    if cards[matchIndex] == cards[index]{
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                    }
                    cards[index].isFaceUp = true
                }else{
                    //either no cards or 2 cards are face up
                    
                    indexOfOneAndOnlyFaceUpCard = index
                }
                if isAllMatched{
                    print("Game Over - All cards matched!")
                    if let stats = endGame(){
                        print("Player: \(stats.name)")
                        print("Duraction: \(Int(stats.gameDuration)) seconds")
                        print("FlipCount: \(stats.flipCount)")
                    }
                    
                }
            }
        }
        
        init(numberOfPairsOfCards: Int){
            for _ in 1...numberOfPairsOfCards {
                let card = Card()
                cards += [card, card]
            }
            setPlayerName("YOU")
            startGame()
            shuffleCards()
        }
    }
    

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Concentration {
    mutating func shuffleCards() {
        cards.shuffle()
    }

    mutating func setPlayerName(_ name: String){
        self.playerName = name
    }
    
    mutating func startGame(){
        self.startTime = Date()
    }
    
    mutating func endGame() -> PlayerStats? {
        guard let start = self.startTime else {
            print("fail to startime")
            return nil
        }
        let duration = Date().timeIntervalSince(start)
        return PlayerStats(name: self.playerName, gameDuration: duration, flipCount: self.flipCount)
    }
}


struct PlayerStats: Comparable{
    var name: String = "You"
    var gameDuration: TimeInterval //存储游戏时间
    var flipCount: Int
    
    
    //排序运算
    static func < (lhs: PlayerStats, rhs: PlayerStats) -> Bool{
        //线根据时长排序，时长相同再根据翻转次数排序
        if lhs.gameDuration == rhs.gameDuration{
            return lhs.flipCount < rhs.flipCount
        }else{
            return lhs.gameDuration < rhs.gameDuration
        }
    }
    
    static func == (lhs: PlayerStats, rhs: PlayerStats) -> Bool{
        return lhs.name == rhs.name && lhs.gameDuration == rhs.gameDuration
            }
    
}//end of PlayerStates


//MARK: 存储，排序显示玩家数据
class Leaderboard {
    var playerStats: [PlayerStats] = []
    
    //添加玩家信息并排列
    func addPlayerStats(_ stats: PlayerStats){
        playerStats.append(stats)
        playerStats.sort()
    }
    
    //显示函数
    func displayLeaderboard() {
        for (index, stats) in playerStats.enumerated() {
            print("\(index+1). \(stats.name) - Time: \(stats.gameDuration) seconds, Flips: \(stats.flipCount)")
        }
    }
    
}//end of leaderboard
