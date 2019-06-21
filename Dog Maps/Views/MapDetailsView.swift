//
//  MapDetailsView.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

class MapDetailsView: UIViewController {
    
    //MARK: Properties
    //public
    var locationAnnotation: DogPlaceLocationAnnotation! {
        didSet {
            addressLabel.text = locationAnnotation.title
            districtLabel.text = locationAnnotation.district
            admAreaLabel.text = locationAnnotation.admArea
            photos = locationAnnotation.photos
        }
    }
    
    weak var dataSource: NSObjectProtocol? {
        willSet {
            photoCollectionView.dataSource = newValue as? UICollectionViewDataSource
            detailsTableView.dataSource = newValue as? UITableViewDataSource
        }
    }
    
    var photos = [UIImage]() {
        didSet {
            removeLoadingIndicator()
        }
    }
    
    
    let minYPosition: CGFloat = 50
    var maxYPosition: CGFloat! {
        let previewHeight = scrollView.frame.minY + addressLabel.frame.maxY + 4
        return UIScreen.main.bounds.height - previewHeight
    }
    
    lazy var tableHeightConstraint = NSLayoutConstraint(item:       detailsTableView,
                                                        attribute:  .height,
                                                        relatedBy:  .equal,
                                                        toItem:     nil,
                                                        attribute:  .notAnAttribute,
                                                        multiplier: 1,
                                                        constant:   0)
    
    //private
    private var bluredView: UIVisualEffectView = {
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
    
    private let scrollView: UIScrollView = {
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
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let detailsTableView: UITableView = {
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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        setView()
        photoCollectionView.delegate = self
        detailsTableView.delegate = self
        
        addLoadingIndicatorToCollectionView()
        
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func updateViewConstraints() {
        tableHeightConstraint.constant = detailsTableView.contentSize.height
        super.updateViewConstraints()
    }
    
    func reloadTableView() {
        detailsTableView.reloadData()
    }
    
    func reloadCollectionView() {
        photoCollectionView.reloadData()
    }
    
    func animateView(to state: ViewState, withDuration duration: TimeInterval = 0.3) {
        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction, .curveEaseOut]
        var newY: CGFloat
        
        switch state {
        case .full:
            newY = minYPosition
        case .preview:
            newY = maxYPosition
        case .disappear:
            newY = UIScreen.main.bounds.maxY
        }
        
        let adjustedDeuration = duration > 0.3 ? 0.3 : duration
        
        UIView.animate(withDuration: adjustedDeuration, delay: 0, options: animationOptions, animations: {
            self.view.frame = CGRect(x: 0, y: newY, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: { (isCompleted) in
            if isCompleted && state == .disappear {
                self.disapperView()
            }
        })
    }
    
    func disapperView() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    func addLoadingIndicatorToCollectionView() {
        photoCollectionView.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: photoCollectionView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: photoCollectionView.centerYAnchor).isActive = true
        
        loadingIndicator.startAnimating()
    }
    
    func removeLoadingIndicator() {
        loadingIndicator.removeFromSuperview()
        loadingIndicator.stopAnimating()
    }
    
    @objc func cancelButtonTapped() {
        animateView(to: .disappear)
    }
    
    @objc private func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        let y = view.frame.minY
        let newYPosition = y + translation.y
        if newYPosition >= minYPosition {
            view.frame = CGRect(x: 0, y: newYPosition, width: view.frame.width, height: view.frame.height)
            sender.setTranslation(.zero, in: view)
        }
        
        if sender.state == .ended {
            var state: ViewState
            var duration: TimeInterval
            if newYPosition <= maxYPosition {
                if velocity.y <= 0 {
                    duration = Double((y - minYPosition) / -velocity.y)
                    state = .full
                } else {
                    duration = Double((maxYPosition - y) / velocity.y)
                    state = .preview
                }
            } else {
                duration = Double((UIScreen.main.bounds.maxY - y) / velocity.y)
                state = .disappear
            }
            animateView(to: state, withDuration: duration)
        }
    }
    
    enum ViewState {
        case full, preview, disappear
    }
}

//MARK: View Settings
extension MapDetailsView {
    fileprivate func setView() {
        setDragLineView()
        setCancelButton()
        setTitleLabel()
        setScrollView()
        setBluredView()
    }
    
    fileprivate func setDragLineView() {
        view.addSubview(dragLineView)
        dragLineView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        dragLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragLineView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        dragLineView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func setCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    fileprivate func setTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: dragLineView.bottomAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
    }
    
    fileprivate func setScrollView() {
        view.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
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
        detailsTableView.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 8).isActive = true
        detailsTableView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
        detailsTableView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        detailsTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8).isActive = true
        detailsTableView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: 0).isActive = true
        detailsTableView.addConstraint(tableHeightConstraint)
        tableHeightConstraint.isActive = true
    }
    
    fileprivate func setBluredView() {
        view.insertSubview(bluredView, at: 0)
        bluredView.layer.cornerRadius = 7
        let shadowColor            = UIColor.black
        shadowColor.withAlphaComponent(0.5)
        view.layer.shadowColor     = shadowColor.cgColor
        view.layer.shadowOpacity   = 0.5
        view.layer.shadowOffset    = .zero
        view.layer.shadowRadius    = 4
    }
}

//MARK: Scroll View
extension MapDetailsView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == self.scrollView && (targetContentOffset.pointee.y < addressLabel.frame.maxY + 4) {
            targetContentOffset.pointee = CGPoint(x: 0, y: 0)
        }
    }
}

//MARK: Gesture Recognizer
extension MapDetailsView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = view.frame.minY
        scrollView.isScrollEnabled = !((y == minYPosition && scrollView.contentOffset.y == 0 && direction > 0) || (y == maxYPosition))
        
        return false
    }
}

//MARK: Table View Delegate
extension MapDetailsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view = view as! UITableViewHeaderFooterView
        view.tintColor = .clear
        view.textLabel?.textAlignment = .center
        view.frame.size.height = 40
    }
}

//MARK: Collection View Delegate and Flow Layout
extension MapDetailsView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let photoSize = photos[indexPath.item].size
        let widthByHeightRatio = photoSize.width / photoSize.height
        let width = height * widthByHeightRatio
        return CGSize(width: width, height: height)
    }
}
