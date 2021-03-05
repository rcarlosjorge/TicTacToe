//
//  ConnectViewController.swift
//  Final
//
//  Created by Carlos Jorge on 3/3/21.
//

import UIKit
import MultipeerConnectivity

class ConnectViewController: UIViewController {

    @IBOutlet var Buttons: [xImageView]!
    var currentPlayer: String!
    var playerNa: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPlayer = "X"
        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        mpcHandler.delegate = self
        setupButtons()
    }
    
    // MARK: - IBActions
    @IBAction func Connect(_ sender: Any) {
        guard mpcHandler.session != nil else { return }
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    @IBAction func NewGame(_ sender: UIBarButtonItem) {
        resetGame()
        package(json: ["string":"New Game"])
    }
    
    @objc func ButtonsTapped(_ sender: UITapGestureRecognizer) {
        let tappedButtons = sender.view as! xImageView
        
        tappedButtons.setPlayer(player: currentPlayer)
        let messageDict = ["Button":tappedButtons.tag, "player":currentPlayer!] as [String : Any]
        package(json: messageDict)
        checkResults()
        pauseGame()
    }
    
    func setupButtons() {
        for index in 0 ... Buttons.count - 1 {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ButtonsTapped))
            Buttons[index].addGestureRecognizer(gesture)
        }
    }
    
    // Checks the possible winning combinations for the last selected square.
    func checkResults() {
        var winner = ""
        
        if Buttons[0].player == "x" && Buttons[1].player == "x" && Buttons[2].player == "x" {
            winner = "X"
        } else if Buttons[0].player == "o" && Buttons[1].player == "o" && Buttons[2].player == "o" {
            winner = "O"
        } else if Buttons[3].player == "x" && Buttons[4].player == "x" && Buttons[5].player == "x" {
            winner = "X"
        } else if Buttons[3].player == "o" && Buttons[4].player == "o" && Buttons[5].player == "o" {
            winner = "O"
        } else if Buttons[6].player == "x" && Buttons[7].player == "x" && Buttons[8].player == "x" {
            winner = "X"
        } else if Buttons[6].player == "o" && Buttons[7].player == "o" && Buttons[8].player == "o" {
            winner = "O"
        } else if Buttons[0].player == "x" && Buttons[3].player == "x" && Buttons[6].player == "x" {
            winner = "X"
        } else if Buttons[0].player == "o" && Buttons[3].player == "o" && Buttons[6].player == "o" {
            winner = "O"
        } else if Buttons[1].player == "x" && Buttons[4].player == "x" && Buttons[7].player == "x" {
            winner = "X"
        } else if Buttons[1].player == "o" && Buttons[4].player == "o" && Buttons[7].player == "o" {
            winner = "O"
        } else if Buttons[2].player == "x" && Buttons[5].player == "x" && Buttons[8].player == "x" {
            winner = "X"
        } else if Buttons[2].player == "o" && Buttons[5].player == "o" && Buttons[8].player == "o" {
            winner = "O"
        } else if Buttons[0].player == "x" && Buttons[4].player == "x" && Buttons[8].player == "x" {
            winner = "X"
        } else if Buttons[0].player == "o" && Buttons[4].player == "o" && Buttons[8].player == "o" {
            winner = "O"
        } else if Buttons[2].player == "x" && Buttons[4].player == "x" && Buttons[6].player == "x" {
            winner = "X"
        } else if Buttons[2].player == "o" && Buttons[4].player == "o" && Buttons[6].player == "o" {
            winner = "O"
        }
        
        if winner != "" {
            popUp(message: "Player \(winner) WINS!!!", action: pauseGame())
            package(json: ["string": "Game Over"])
        }
    }
    
}

// MARK: Multipeer Handling
extension ConnectViewController: MPCHandlerDelegate {
    
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
        guard let space = message["Buttons"] as? Int, let player = message["player"] as? String else {
            print("Missing message info.")
            return
        }
        
        Buttons[space].player = player
        Buttons[space].setPlayer(player: player)
        currentPlayer = player == "O" ? "X" : "O"
        unPauseGame()
        checkResults()
    }
}


extension ConnectViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

extension ConnectViewController {
    
    func pauseGame() {
        for index in 0 ... Buttons.count - 1 {
            Buttons[index].isUserInteractionEnabled = false
        }
    }
    
    func unPauseGame() {
        for index in 0 ... Buttons.count - 1 {
            Buttons[index].isUserInteractionEnabled = true
        }
    }
    
    // Used to reset the game.
    func resetGame() {
        for index in 0 ... Buttons.count - 1 {
            Buttons[index].image = nil
            Buttons[index].activated = false
            Buttons[index].player = ""
            Buttons[index].isUserInteractionEnabled = true
        }
        currentPlayer = "X"
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
        let alert = UIAlertController(title: "Tic Tac Toe", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  { (alert) in
            action
        }))
        present(alert, animated: true, completion: nil)
    }
}
