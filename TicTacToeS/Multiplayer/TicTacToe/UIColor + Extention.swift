//
//  UIColor + Extention.swift
//  TicTacToe
//
//  Created by Carlos Jorge on 4/3/21.
//

import UIKit

extension UIColor {
    
    
    static func mainWhite() -> UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return #colorLiteral(red: 0.1154643521, green: 0.1147854105, blue: 0.1159910634, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
            }
        }
    }
    static func buttonDark() -> UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            }
        }
    }
    
    static func textLabel() -> UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                /// Return the color for Dark Mode
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            } else {
                /// Return the color for Light Mode
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
}
