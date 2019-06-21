//
//  DogGroundDetailsViewController.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit




class MapDetailsViewController: MapDetailsView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        delegate = self
        dataSource = self
        locationAnnotation.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateView(to: .preview)
    }
    
    override func updateViewConstraints() {
        tableHeightConstraint.constant = detailsTableView.contentSize.height
        super.updateViewConstraints()
    }
}


extension MapDetailsViewController: LocationAnnotationDelegate {
    func dogGround(didFinishLoading photos: [UIImage]) {
        self.photos = photos
        photoCollectionView.reloadData()
    }
}



extension MapDetailsViewController: UICollectionViewDataSource {
    
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
}

//MARK: Table View Data Source
extension MapDetailsViewController: UITableViewDataSource {
    
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
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        print("viewForHeaderInSection")
//        guard let headerView = tableView else { return nil }
//        print("header found")
//        headerView.backgroundColor = .clear
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return locationAnnotation.facilities.count
        case 1:
            return locationAnnotation.schedule.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell", for: indexPath) as! FacilityTableViewCell
            let facility = locationAnnotation.facilities[indexPath.row]
            cell.facility = facility.type.rawValue.capitalizingFirstLetter()
            cell.isAvailable = facility.isAvailable
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as! ScheduleTableViewCell
            let schedule = locationAnnotation.schedule[indexPath.row]
            cell.schedule = schedule
            return cell
        }
        return UITableViewCell()
    }
}
