//
//  FacilityTableViewCell.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

class FacilityTableViewCell: UITableViewCell {
    var facility: String? {
        willSet {
            textLabel?.text = newValue
        }
    }
    var isAvailable: Bool? {
        willSet {
            isAvailableImageView.image = newValue! ? #imageLiteral(resourceName: "IsAvailable") : #imageLiteral(resourceName: "NotAvailable")
        }
    }
    
    var isAvailableImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(isAvailableImageView)
        let margin: CGFloat = 8
        isAvailableImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        isAvailableImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin - 8).isActive = true
        isAvailableImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        isAvailableImageView.widthAnchor.constraint(equalTo: isAvailableImageView.heightAnchor).isActive = true
    }
}

