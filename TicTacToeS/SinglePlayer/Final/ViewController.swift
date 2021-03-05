//
//  ViewController.swift
//  Final
//
//  Created by Carlos Jorge on 2/3/21.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var connectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }

    func setupUI() {
        connectBtn.layer.cornerRadius = 10
        startBtn.layer.cornerRadius = 10
        CardView.layer.cornerRadius = 10
        CardView.layer.shadowOpacity = 0.4
        CardView.layer.shadowColor = UIColor.black.cgColor
        CardView.layer.shadowRadius = 10
        CardView.layer.shadowOffset = .zero
    }
    @IBAction func StartClick(_ sender: UIButton) {
        guard !nameField.text!.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let controller = storyboard?.instantiateViewController(identifier: "GameScene") as! GameViewController
        controller.playerName = nameField.text
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func ConnectBtn(_ sender: UIButton) {
        
        let carlos = storyboard?.instantiateViewController(identifier: "Multiplayer") as! ConnectViewController
        carlos.playerNa = nameField.text
        carlos.modalPresentationStyle = .fullScreen
        self.present(carlos, animated: true, completion: nil)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
          case "controller":
            let controller = segue.destination as! GameViewController
            controller.playerName = nameField.text

          case "carlos":
            let carlos = segue.destination as! ConnectViewController
            carlos.playerNa = nameField.text

          default: break
        }
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "GameN" {
            if nameField.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
            else if identifier == "Multip" {
                if nameField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                    return false
                }
            }
        }
        return true
    }
    
    
}
