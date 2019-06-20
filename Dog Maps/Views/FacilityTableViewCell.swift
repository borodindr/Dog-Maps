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
//            isAvailbleImageView.image = newValue! ? #imageLiteral(resourceName: "Yes") : #imageLiteral(resourceName: "No")
        }
    }
    
    var isAvailbleImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(isAvailbleImageView)
        let margin: CGFloat = 8
        isAvailbleImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        isAvailbleImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).isActive = true
        isAvailbleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        isAvailbleImageView.widthAnchor.constraint(equalTo: isAvailbleImageView.heightAnchor).isActive = true
    }
    
    
}

