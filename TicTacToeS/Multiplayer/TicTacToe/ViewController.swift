//
//  GameController.swift
//  TicTacToe
//
//   Created by Carlos Jorge on 4/3/21.
//

import UIKit
import MultipeerConnectivity

class GameController: UIViewController {
    
    @IBOutlet var fields: [xImageView]!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        mpcHandler.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func connectWithPlayer(_ sender: Any) {
        guard mpcHandler.session != nil else { return }
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    @IBAction func fieldsTapped(_ sender: UITapGestureRecognizer) {
        let tappedField = sender.view as! xImageView
        tappedField.setPlayer(player: "x")
        

    }
    
    
}

// MARK: Multipeer Handling
extension GameController: MPCHandlerDelegate {
    
    /// Updates the screen with connection status.
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
    }
    
    /// Updates screen with other player's actions.
    func received(data: Data, from peer: MCPeerID) {
//        let message = unpack(json: data)
//        guard message["string"] as? String != "Game Over" else {
//            popUp(message: "You Lose!!!", action: gameOver())
//            return
//        }
//        guard message["string"] as? String != "New Game" else {
//            popUp(message: "New Game!!!", action: resetGame())
//            return
//        }
//        guard let space = message["field"] as? Int, let player = message["player"] as? String else {
//            print("Missing message info.")
//            return
//        }
        
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
