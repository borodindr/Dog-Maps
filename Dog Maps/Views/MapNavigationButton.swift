//
//  MapNavigationButton.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 21/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

@IBDesignable
class MapNavigationButton: UIButton {
    @IBInspectable
    var icon: UIImage? = nil {
        didSet {
            setImage(icon, for: .normal)
        }
    }
}
