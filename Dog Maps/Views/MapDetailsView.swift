//
//  MapDetailsView.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

class MapDetailsView: UIView {
    
    var dogGround: DogGround!
    
    weak var delegate: NSObjectProtocol? {
        willSet {
            photoCollectionView.delegate = newValue as? UICollectionViewDelegate
            detailsTableView.delegate = newValue as? UITableViewDelegate
        }
    }
    
    weak var dataSource: NSObjectProtocol? {
        willSet {
            photoCollectionView.dataSource = newValue as? UICollectionViewDataSource
            detailsTableView.dataSource = newValue as? UITableViewDataSource
        }
    }
    
    var previewHeight: CGFloat {
        return scrollView.frame.minY + addressLabel.frame.maxY + 4
    }
    
    lazy var tableHeightConstraint = NSLayoutConstraint(item: detailsTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
    
    var bluredView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let bluredView = UIVisualEffectView(effect: blurEffect)
        bluredView.frame = UIScreen.main.bounds
        bluredView.clipsToBounds = true
        return bluredView
    }()
    
    private let dragLineView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5 / 2
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Clear"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Площадки для выгула собак"
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let districtLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let admAreaLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        //        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        //        layout.minimumLineSpacing = 0
        //        layout.minimumLineSpacing = 8
        layout.scrollDirection = .horizontal
        //        let collectionViewHeight = cellHeight + (eachInset * 2)
        //        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: collectionViewHeight), collectionViewLayout: layout)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let detailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FacilityTableViewCell.self, forCellReuseIdentifier: "FacilityCell")
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleCell")
        tableView.rowHeight = 30
        tableView.estimatedRowHeight = 30
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    init(dogGround: DogGround, frame: CGRect) {
        super.init(frame: frame)
        scrollView.delegate = self
        setView()
        addressLabel.text = dogGround.title
        districtLabel.text = dogGround.district
        admAreaLabel.text = dogGround.admArea
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    fileprivate func setView() {
        setDragLineView()
        setCancelButton()
        setTitleLabel()
        setScrollView()
        
//        let backView = UIView()
//        backView.backgroundColor = .customCyan
//        backView.clipsToBounds = true
//        insertSubview(backView, at: 0)
//        backView.translatesAutoresizingMaskIntoConstraints = false
//        backView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
//        backView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
//        backView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
//        backView.bottomAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4).isActive = true
        
        insertSubview(bluredView, at: 0)
        bluredView.layer.cornerRadius = 7
        let shadowColor       = UIColor.black
        shadowColor.withAlphaComponent(0.5)
        layer.shadowColor     = shadowColor.cgColor
        layer.shadowOpacity   = 0.5
        layer.shadowOffset    = .zero
        layer.shadowRadius    = 4
    }
    
    fileprivate func setDragLineView() {
        addSubview(dragLineView)
        dragLineView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        dragLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dragLineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        dragLineView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func setCancelButton() {
        addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setTitleLabel() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: dragLineView.bottomAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setScrollView() {
        addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        
        setAddressLabel()
        setDistrictLabel()
        setAdmAreaLabel()
        setPhotoCollectionView()
        setDetailsTabelView()
    }
    
    fileprivate func setAddressLabel() {
        scrollView.addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 4).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16).isActive = true
        addressLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setDistrictLabel() {
        scrollView.addSubview(districtLabel)
        districtLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
        districtLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16).isActive = true
        districtLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setAdmAreaLabel() {
        scrollView.addSubview(admAreaLabel)
        admAreaLabel.topAnchor.constraint(equalTo: districtLabel.bottomAnchor, constant: 8).isActive = true
        admAreaLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16).isActive = true
        admAreaLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setPhotoCollectionView() {
        scrollView.addSubview(photoCollectionView)
        photoCollectionView.topAnchor.constraint(equalTo: admAreaLabel.bottomAnchor, constant: 16).isActive = true
        photoCollectionView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16).isActive = true
        photoCollectionView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16).isActive = true
        photoCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        photoCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32).isActive = true
    }
    
    fileprivate func setDetailsTabelView() {
        scrollView.addSubview(detailsTableView)
        detailsTableView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 16).isActive = true
        detailsTableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
        detailsTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        detailsTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
        //        detailsTableView.heightAnchor.constraint(equalToConstant: detailsTableView.contentSize.height).isActive = true
        detailsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
        
        detailsTableView.addConstraint(tableHeightConstraint)
        tableHeightConstraint.isActive = true
    }
}

extension MapDetailsView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("WillEndDragging")
        print(targetContentOffset.pointee)
        
        if targetContentOffset.pointee.y < addressLabel.frame.maxY + 4 {
            targetContentOffset.pointee = CGPoint(x: 0, y: 0)
        }
    }
}
