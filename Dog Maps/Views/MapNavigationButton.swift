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
    
//    var deselectedTitntColor: UIColor = .customCyan {
//        didSet {
//            tintColor = deselectedTitntColor
//        }
//    }
//    
//    var deselectedBackgroundColor: UIColor = .white {
//        didSet {
//            backgroundColor = deselectedBackgroundColor
//        }
//    }
//
//    var selectedTitntColor: UIColor = .white
//
//    var selectedBackgroundColor: UIColor = .clear
    
//    override var isHighlighted: Bool {
//        didSet {
//            if isHighlighted {
//                tintColor = .white
//                backgroundColor = selectedBackgroundColor
//            }
//            else {
//                tintColor = deselectedTitntColor
//                backgroundColor = deselectedBackgroundColor
//            }
//        }
//    }
    
    
    
//    override func draw(_ rect: CGRect) {
//
//    }
 

}
