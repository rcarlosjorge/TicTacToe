//
//  GameViewController.swift
//  Final
//
//  Created by Carlos Jorge on 3/3/21.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var PlayerName: UILabel!
    @IBOutlet weak var PlayerScore: UILabel!
    @IBOutlet weak var ComputerScore: UILabel!
    @IBOutlet weak var Card1: UIImageView!
    @IBOutlet weak var Card2: UIImageView!
    @IBOutlet weak var Card3: UIImageView!
    @IBOutlet weak var Card4: UIImageView!
    @IBOutlet weak var Card5: UIImageView!
    @IBOutlet weak var Card6: UIImageView!
    @IBOutlet weak var Card7: UIImageView!
    @IBOutlet weak var Card8: UIImageView!
    @IBOutlet weak var Card9: UIImageView!
    
    var playerName: String!
    var lastValue = "O"
    var playerChoices: [Card] = []
    var AIChoices: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayerName.text = playerName + ":"

        createTap(on: Card1, type: .uno)
        createTap(on: Card2, type: .dos)
        createTap(on: Card3, type: .tres)
        createTap(on: Card4, type: .cuatro)
        createTap(on: Card5, type: .cinco)
        createTap(on: Card6, type: .seis)
        createTap(on: Card7, type: .siete)
        createTap(on: Card8, type: .ocho)
        createTap(on: Card9, type: .nueve)
        
    }
  
    func createTap(on imageView: UIImageView, type card: Card){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.CardClick(_:)))
        tap.name = card.rawValue
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func CardClick(_ sender: UITapGestureRecognizer) {
        let selectCard = getCard(from: sender.name ?? "")
        MakeChoice(selectCard)
        playerChoices.append(Card(rawValue: sender.name!)!)
        checkWon()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.AI()
        }
    }
    
    func AI() {
        var avaspace = [UIImageView]()
        var avaCard = [Card]()
        for name in Card.allCases {
            let card = getCard(from: name.rawValue)
            if card.image == nil {
                avaspace.append(card)
                avaCard.append(name)
            }
        }
        guard avaCard.count > 0 else {return}
        
        let RandIndex = Int.random(in: 0 ..< avaspace.count)
        MakeChoice(avaspace[RandIndex])
        AIChoices.append(avaCard[RandIndex])
        checkWon()
    }
    
    func MakeChoice(_ selectCard: UIImageView){
        guard selectCard.image == nil else { return }
        
        if lastValue == "X" {
            selectCard.image = UIImage(named: "oh")
            lastValue = "O"
        }
        else {
            selectCard.image = UIImage(named: "ex")
            lastValue = "X"
        }
        
    }
    
    func checkWon() {
        var correct = [[Card]]()
        let firstRow: [Card] = [.uno, .dos, .tres]
        let secondRow: [Card] = [.cuatro, .cinco, .seis]
        let thirdRow: [Card] = [.siete, .ocho, .nueve]

        let linea1: [Card] = [.uno, .cuatro, .siete]
        let linea2: [Card] = [.dos, .cinco, .ocho]
        let linea3: [Card] = [.tres, .seis, .nueve]
        
        let diago1: [Card] = [.uno, .cinco, .nueve]
        let diago2: [Card] = [.tres, .cinco, .siete]


        correct.append(firstRow)
        correct.append(secondRow)
        correct.append(thirdRow)
        correct.append(linea1)
        correct.append(linea2)
        correct.append(linea3)
        correct.append(diago1)
        correct.append(diago2)
        
        for valid in correct {
            let userMatch = playerChoices.filter { valid.contains($0)}.count
            let AIMatch = AIChoices.filter { valid.contains($0)}.count
            
            if userMatch == valid.count{
                PlayerScore.text = String((Int(PlayerScore.text ?? "0") ?? 0) + 1)
                resetGame()
                break
            }
            else if AIMatch == valid.count {
                ComputerScore.text = String((Int(ComputerScore.text ?? "0") ?? 0) + 1)
                resetGame()
                break
            }
            else if AIChoices.count + playerChoices.count == 9 {
                resetGame()
                break
            }
        }
    }
    
    func resetGame() {
        for name in Card.allCases{
            let card = getCard(from: name.rawValue)
            card.image = nil
        }
        lastValue = "O"
        playerChoices = []
        AIChoices = []
    }
    
    func getCard(from name: String) -> UIImageView{
        let card = Card(rawValue: name) ?? .uno
        switch card {
        case .uno:
            return Card1
        case .dos:
            return Card2
        case .tres:
            return Card3
        case .cuatro:
            return Card4
        case .cinco:
            return Card5
        case .seis:
            return Card6
        case .siete:
            return Card7
        case .ocho:
            return Card8
        case .nueve:
            return Card9
        }
    }
    
    @IBAction func CloseBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

enum Card: String, CaseIterable {
    case uno, dos, tres, cuatro, cinco, seis, siete, ocho, nueve
}
