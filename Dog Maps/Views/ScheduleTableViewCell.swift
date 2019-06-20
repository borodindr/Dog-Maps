//
//  ScheduleTableViewCell.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    var schedule: Schedule? {
        willSet {
            weekDayLabel.text = newValue?.day.rawValue.capitalizingFirstLetter()
            hoursLabel.text = newValue?.hours.capitalizingFirstLetter()
        }
    }
    
    private var weekDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var hoursLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setView() {
        addSubview(stackView)
        stackView.addArrangedSubview(weekDayLabel)
        stackView.addArrangedSubview(hoursLabel)
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
}

