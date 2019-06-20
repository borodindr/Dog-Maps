//
//  Extension.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import Foundation
import UIKit

//Main color theme
extension UIColor {
    static let customCyan = UIColor(red: 57 / 255, green: 230 / 255, blue: 223 / 255, alpha: 1)
}

//Capitalize first letter of String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

//Conversion from String да/нет to Bool
extension String {
    func convertToBool() -> Bool? {
        let value = self.lowercased()
        switch value {
        case "да":
            return true
        case "нет":
            return false
        default:
            return nil
        }
    }
}
