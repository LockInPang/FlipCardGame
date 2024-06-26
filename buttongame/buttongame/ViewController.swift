//
//  ViewController.swift
//  buttongame
//
//  Created by 庞力鑫 on 2023/05/30.
//


import UIKit

class ViewController: UIViewController {
    
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet{
                updateFlipCountLabel()
        }
    }
    //更新计数器label
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.orange
            ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    //MARK: 重新开始游戏按钮
    @IBAction func restartGame(_ sender: UIButton) {
        restartGameFunc()
    }
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: { sender.isSelected = sender.isSelected
        }, completion: nil)
        if let cardNumber = cardButtons.firstIndex(of: sender){
            let card = game.cards[cardNumber]
            if !card.isFaceUp, !card.isMatched{
                game.chooseCard(at: cardNumber)
                flipCount += 1
                updateViewFormModel()
//                print("cardNumber = \(cardNumber)")
                if game.isAllMatched{
                    showGameResultAlert()
                }
            }
        }
        else{
            print("card not exist")
        }
    }
    
    private func updateViewFormModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setAttributedTitle(emoji(for: card), for: UIControl.State())
                button.backgroundColor = UIColor.white
                
                //print("card is faceup")
            }else{
                let attributedSpace = NSAttributedString(string: " ", attributes: nil)
                button.setAttributedTitle(attributedSpace, for: .normal)
                button.backgroundColor = card.isMatched ? UIColor.black : UIColor.orange
                //print("card is not faceup")
            }
        }
    }
    private var emojiChoices = "🤖👾🎃👻🦄🐯🙈🐣🦊🚦✈️🚌💣🔮🖼️🧸🎁🚭📸🕹️🗿🚀🎲"

    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> NSAttributedString{
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            }
        //设置emoji显示大小
        let fontSize: CGFloat = 43
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        
        return NSAttributedString(string: emoji[card] ?? "?", attributes: attributes)
    }
    
    private func showGameResultAlert(){
        let alertController = UIAlertController(title: "Well Done!", message: "Player: \(game.endGame()?.name ?? " ") \n Duraction: \(Int(game.endGame()!.gameDuration)) seconds \n FlipCount: \(game.endGame()!.flipCount)", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Restart", style: .default){_ in
            self.restartGameFunc()
        }
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func restartGameFunc(){
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        flipCount = 0
        emojiChoices = "🤖👾🎃👻🎒🐯🙈🐣🚦✈️🚌💣🔮🖼️🧸🎁🚭📸🕹️🗿🚀🎲"
        emoji = [:]
        game.resetCards()
        updateViewFormModel()
    }
    
}//end of UIViewController

extension Int{
    var arc4random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
            
        }else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
    
    
    
}//end of extension
