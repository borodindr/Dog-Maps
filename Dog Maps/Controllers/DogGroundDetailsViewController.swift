//
//  DogGroundDetailsViewController.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit

protocol DogGroundDelegate: AnyObject {
    func dogGround(didFinishLoading photos: [UIImage])
}


class DogGroundDetailsViewController: UIViewController {
    
    private var mainView: MapDetailsView {
        return view as! MapDetailsView
    }
    
    var dogGround: DogGround!
    var photos = [UIImage]()
    let minYPosition: CGFloat = 50
    var maxYPosition: CGFloat! {
        return UIScreen.main.bounds.height - mainView.previewHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setData()
        photos = dogGround.photos
        
        mainView.delegate = self
        mainView.dataSource = self
        dogGround.delegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        panGesture.delegate = self
        mainView.addGestureRecognizer(panGesture)
        //        photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) { [unowned self] in
            let frame = self.mainView.frame
            self.mainView.frame = CGRect(x: 0, y: self.maxYPosition, width: frame.width, height: frame.height)
        }
    }
    
    
    
    override func loadView() {
        view = MapDetailsView(dogGround: dogGround, frame: UIScreen.main.bounds)
    }
    
    override func updateViewConstraints() {
        mainView.tableHeightConstraint.constant = mainView.detailsTableView.contentSize.height
        super.updateViewConstraints()
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: mainView)
        let velocity = sender.velocity(in: mainView)
        let y = mainView.frame.minY
        let newYPosition = y + translation.y
        if newYPosition >= minYPosition {
            mainView.frame = CGRect(x: 0, y: newYPosition, width: mainView.frame.width, height: mainView.frame.height)
            sender.setTranslation(.zero, in: mainView)
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
    
    private func animateView(to state: ViewState, withDuration duration: TimeInterval = 0.3) {
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
            self.mainView.frame = CGRect(x: 0, y: newY, width: self.mainView.frame.width, height: self.mainView.frame.height)
            
        }, completion: { (isCompleted) in
            if isCompleted && state == .disappear {
                self.disapperView()
            }
        })
        
        
    }
    
    private func disapperView() {
        willMove(toParent: nil)
        mainView.removeFromSuperview()
        removeFromParent()
    }
    
    @objc func cancelButtonTapped() {
        animateView(to: .disappear)
    }
    
    //    @IBAction func cancelButtonTapped(_ sender: UIButton) {
    //        animateView(to: .disappear)
    //    }
    
    enum ViewState {
        case full, preview, disappear
    }
    
    
    
}


extension DogGroundDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.item]
        cell.photo = photo
        return cell
    }
    
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


extension DogGroundDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Содержимое площадки"
        case 1:
            return "График работы"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dogGround.facilities.count
        case 1:
            return dogGround.schedule.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell", for: indexPath) as! FacilityTableViewCell
            let facility = dogGround.facilities[indexPath.row]
            cell.facility = facility.type.rawValue.capitalizingFirstLetter()
            cell.isAvailable = facility.isAvailable
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
            let schedule = dogGround.schedule[indexPath.row]
            cell.schedule = schedule
            return cell
        }
        return UITableViewCell()
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 44
    //    }
    
    
}


extension DogGroundDetailsViewController: DogGroundDelegate {
    func dogGround(didFinishLoading photos: [UIImage]) {
        self.photos = photos
        mainView.photoCollectionView.reloadData()
    }
}

extension DogGroundDetailsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y
        
        let y = mainView.frame.minY
        
        print(!((y == minYPosition && mainView.scrollView.contentOffset.y == 0 && direction > 0) || (y == maxYPosition)))
        
        mainView.scrollView.isScrollEnabled = !((y == minYPosition && mainView.scrollView.contentOffset.y == 0 && direction > 0) || (y == maxYPosition))
        
        return false
    }
    
}

