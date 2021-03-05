//
//  GameController.swift
//  TicTacToe
//
//  Created by Carlos Jorge on 4/3/21.//

import UIKit
import MultipeerConnectivity

class GameController: UIViewController {
    
    @IBOutlet var fields: [xImageView]!
    
    var currentPlayer: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayer = "x"
        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        mpcHandler.delegate = self
        setupFields()
    }
    
    // MARK: - IBActions
    @IBAction func connectWithPlayer(_ sender: Any) {
        guard mpcHandler.session != nil else { return }
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        resetGame()
        package(json: ["string":"New Game"])
    }
    
    @objc func fieldsTapped(_ sender: UITapGestureRecognizer) {
        let tappedField = sender.view as! xImageView
        tappedField.setPlayer(player: currentPlayer)
        let messageDict = ["field":tappedField.tag, "player":currentPlayer!] as [String : Any]
        package(json: messageDict)
        checkResults()
        pauseGame()
    }
    
    func setupFields() {
        for index in 0 ... fields.count - 1 {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(fieldsTapped))
            fields[index].addGestureRecognizer(gesture)
        }
    }
    
    // Checks the possible winning combinations for the last selected square.
    func checkResults() {
        var winner = ""
        
        if fields[0].player == "x" && fields[1].player == "x" && fields[2].player == "x" {
            winner = "X"
        } else if fields[0].player == "o" && fields[1].player == "o" && fields[2].player == "o" {
            winner = "O"
        } else if fields[3].player == "x" && fields[4].player == "x" && fields[5].player == "x" {
            winner = "X"
        } else if fields[3].player == "o" && fields[4].player == "o" && fields[5].player == "o" {
            winner = "O"
        } else if fields[6].player == "x" && fields[7].player == "x" && fields[8].player == "x" {
            winner = "X"
        } else if fields[6].player == "o" && fields[7].player == "o" && fields[8].player == "o" {
            winner = "O"
        } else if fields[0].player == "x" && fields[3].player == "x" && fields[6].player == "x" {
            winner = "X"
        } else if fields[0].player == "o" && fields[3].player == "o" && fields[6].player == "o" {
            winner = "O"
        } else if fields[1].player == "x" && fields[4].player == "x" && fields[7].player == "x" {
            winner = "X"
        } else if fields[1].player == "o" && fields[4].player == "o" && fields[7].player == "o" {
            winner = "O"
        } else if fields[2].player == "x" && fields[5].player == "x" && fields[8].player == "x" {
            winner = "X"
        } else if fields[2].player == "o" && fields[5].player == "o" && fields[8].player == "o" {
            winner = "O"
        } else if fields[0].player == "x" && fields[4].player == "x" && fields[8].player == "x" {
            winner = "X"
        } else if fields[0].player == "o" && fields[4].player == "o" && fields[8].player == "o" {
            winner = "O"
        } else if fields[2].player == "x" && fields[4].player == "x" && fields[6].player == "x" {
            winner = "X"
        } else if fields[2].player == "o" && fields[4].player == "o" && fields[6].player == "o" {
            winner = "O"
        }
        
        if winner != "" {
            popUp(message: "Player \(winner) WINS!!!", action: pauseGame())
            package(json: ["string": "Game Over"])
        }
    }
    
}

// MARK: Multipeer Handling
extension GameController: MPCHandlerDelegate {
    
    // Updates the screen with connection status.
    func changed(state: MCSessionState, of peer: MCPeerID) {
        guard state == .connected else {
            navigationItem.title = "No Connection"
            navigationItem.leftBarButtonItem?.isEnabled = true
            mpcHandler.advertiseSelf(advertise: true)
            return
        }
        navigationItem.title = "Connected"
        navigationItem.leftBarButtonItem?.isEnabled = false
        mpcHandler.advertiseSelf(advertise: false)
        resetGame()
    }
    
    // Updates screen with other player's actions.
    func received(data: Data, from peer: MCPeerID) {
        let message = unpack(json: data)
        let senderDisplayName = peer.displayName
        guard message["string"] as? String != "Game Over" else {
            popUp(message: "You Lose!!!", action: pauseGame())
            return
        }
        guard message["string"] as? String != "New Game" else {
            popUp(message: "\(senderDisplayName) has started a new Game!", action: resetGame())
            return
        }
        guard let space = message["field"] as? Int, let player = message["player"] as? String else {
            print("Missing message info.")
            return
        }
        
        fields[space].player = player
        fields[space].setPlayer(player: player)
        currentPlayer = player == "o" ? "x" : "o"
        unPauseGame()
        checkResults()
    }
}


extension GameController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

extension GameController {
    
    func pauseGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].isUserInteractionEnabled = false
        }
    }
    
    func unPauseGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].isUserInteractionEnabled = true
        }
    }
    
    // Used to reset the game.
    func resetGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
            fields[index].isUserInteractionEnabled = true
        }
        currentPlayer = "x"
    }
    
    // Used to convert data into native Dictionary object.
    func unpack(json: Data) -> [String: Any] {
        var message = [String: Any]()
        message = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String : Any]
        return message
    }
    
    // Creates data object for IoT/net communications and syncs with other player.
    func package(json message: [String : Any]) {
        var messageData : Data
        do {
            messageData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
        } catch {
            print("Error packaging message: \(error.localizedDescription)")
            return
        }
        syncPlayers(with: messageData)
    }
    
    // Sends data objects to other IoT players/devices.
    func syncPlayers(with message: Data) {
        do {
            try mpcHandler.session.send(message, toPeers: mpcHandler.session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending: \(error.localizedDescription)")
        }
    }
    
    // Pops up a specified alert message and performs associated action.
    func popUp(message: String, action: ()) {
        let alert = UIAlertController(title: "Carlos Jorge", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar!", style: .default, handler:  { (alert) in
            action
        }))
        present(alert, animated: true, completion: nil)
    }
}
