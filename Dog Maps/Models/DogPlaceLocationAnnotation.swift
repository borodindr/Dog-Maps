//
//  DogGround.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import UIKit
import MapKit
import Contacts

protocol LocationAnnotationDelegate: AnyObject {
    func dogGround(didFinishLoading photos: [UIImage])
}

class DogPlaceLocationAnnotation: LocationAnnotaion {
    
    weak var delegate: LocationAnnotationDelegate?
    
    private var photosLnksSuffixes: [PhotosLnksSuffixes]?
    private var rawFacilities: [String]?
    private var loadedPhotos: [UIImage]?
    private var rawLighting: String?
    private var rawFencing: String?
    
    var facilities: [Facility] {
        var facilities = [Facility]()
        for facilityType in Facility.FacilityType.allCases {
            let isAvailable = rawFacilities!.contains(facilityType.rawValue)
            facilities.append(Facility(type: facilityType, isAvailable: isAvailable))
        }
        return facilities
    }
    
    var lighting: Bool? {
        return rawLighting?.convertToBool()
    }
    
    var fencing: Bool? {
        return rawFencing?.convertToBool()
    }
    
    override init(data: LocationData) {
        super.init(data: data)
        self.title = data.properties.Attributes.Location
        self.photosLnksSuffixes = data.properties.Attributes.Photo
        self.rawFacilities = data.properties.Attributes.Elements
        self.rawLighting = data.properties.Attributes.Lighting
        self.rawFencing = data.properties.Attributes.Fencing
    }
    
    var photos: [UIImage] {
        if loadedPhotos == nil {
            requestPhotos { (photos) in
                self.loadedPhotos = photos
                self.delegate?.dogGround(didFinishLoading: photos)
            }
        }
        return loadedPhotos ?? []
    }
    
    func requestPhotos(completion: @escaping ([UIImage]) -> Void) {
        var photos: [UIImage] = []
        
        DispatchQueue.global(qos: .utility).async {
            let semaphore = DispatchSemaphore(value: 0)
            guard let links = self.photosLnksSuffixes else { return }
            for photoLinkSuffix in links {
                
                let urlString = "https://op.mos.ru/MEDIA/showFile?id=" + photoLinkSuffix.Photo
                if let url = URL(string: urlString) {
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        if let error = error {
                            print("Photo loading error: \(error)")
                        }
                        
                        guard
                            let data = data,
                            let image = UIImage(data: data) else { return }
                        photos.append(image)
                        if photos.count == links.count {
                            semaphore.signal()
                        }
                        }.resume()
                }
            }
            
            semaphore.wait()
            DispatchQueue.main.async {
                completion(photos)
            }
        }
        
    }
}

struct Facility {
    let type: FacilityType
    let isAvailable: Bool
    
    enum FacilityType: String, CaseIterable {
        case beam = "балансир для собак"
        case doubleBarrier = "барьер двойной"
        case snakeBarrier = "барьер змейка"
        case ringBarrier = "барьер кольца"
        case singleBarrier = "барьер одинарный"
        case adjustableBarrier = "барьер регулируемый"
        case tripleBarrier = "барьер тройной"
        case boom = "бум для собак"
        case entrance = "входной элемент"
        case ladderWithRail = "вышка-лестница (с перилами)"
        case ladderWithoutRail = "горка-лестница (без перил)"
        case aShapeBridge = "горка-мостик А-форма"
        case infoStand = "информационный стенд"
        case tunnel = "туннель (нора)"
        case obstacleCourse = "полоса препятствий"
        case bench = "скамья для собаководов"
        case springboard = "трамплин"
        case trap = "трап"
        case tyre = "тренировочный снаряд с покрышкой"
        case bin = "урна"
        
    }
}
