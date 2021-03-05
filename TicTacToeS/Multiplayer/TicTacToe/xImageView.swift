//
//  xImageView.swift
//  TicTacToe
//
//  Created by Carlos Jorge on 4/3/21.
//

import UIKit

class xImageView: UIImageView {
    var player: String?
    var activated: Bool! = false
    
    func setPlayer(player: String) {
        self.player = player
        if activated == false {
            self.image = player == "x" ? #imageLiteral(resourceName: "Rectangle") : #imageLiteral(resourceName: "Oval")
            activated = true
        }
    }

}
