//
//  ButtonView.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 20/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

@IBDesignable
class MapNavigationView: UIView {
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.customCyan {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
