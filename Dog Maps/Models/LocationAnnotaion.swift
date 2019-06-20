//
//  LocationAnnotaion.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import Foundation
import MapKit
//import Contacts



class LocationAnnotaion: NSObject, MKAnnotation {
    
    //    weak var delegate: DogGroundDelegate?
    
    
    var title: String?
    var address: String?
    var admArea: String
    var district: String
    private var rawCoordinates: [Double]
    private var rawSchedule: [WorkingHours]
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: rawCoordinates[1], longitude: rawCoordinates[0])
    }
    
    var schedule: [Schedule] {
        var schedule = [Schedule]()
        for day in rawSchedule {
            schedule.append(Schedule(dayString: day.DayOfWeek, hours: day.Hours))
        }
        return schedule
    }
    
    
    
    
    
    
    //    private var photosLnksSuffixes: [PhotosLnksSuffixes]
    //    private var rawFacilities: [String]?
    //
    //    private var loadedPhotos: [UIImage]?
    //    private var rawLighting: String
    //    private var rawFencing: String
    //
    //
    //    var facilities: [Facility] {
    //        var facilities = [Facility]()
    //        for facilityType in Facility.FacilityType.allCases {
    //            if rawFacilities!.contains(facilityType.rawValue) {
    //                facilities.append(Facility(type: facilityType, isAvailable: true))
    //            } else {
    //                facilities.append(Facility(type: facilityType, isAvailable: false))
    //            }
    //        }
    //        return facilities
    //    }
    //
    //    var lighting: Bool? {
    //        return stringToBoolConverter(rawLighting)
    //    }
    //
    //    var fencing: Bool? {
    //        return stringToBoolConverter(rawFencing)
    //    }
    
    
    
    
    
    init(data: LocationData) {
        //        self.title = data.properties.Attributes.Location
        self.rawCoordinates = data.geometry.coordinates
        //        self.photosLnksSuffixes = data.properties.Attributes.Photo
        self.admArea = data.properties.Attributes.AdmArea
        self.district = data.properties.Attributes.District
        //        self.rawFacilities = data.properties.Attributes.Elements
        //        self.rawLighting = data.properties.Attributes.Lighting
        //        self.rawFencing = data.properties.Attributes.Fencing
        self.rawSchedule = data.properties.Attributes.WorkingHours
    }
    
    //    private func stringToBoolConverter(_ value: String) -> Bool? {
    //        switch value {
    //        case "да":
    //            return true
    //        case "нет":
    //            return false
    //        default:
    //            return nil
    //        }
    //    }
    
    //    func photos() -> [UIImage] {
    //        if loadedPhotos == nil {
    //            print("nil")
    //            requestPhotos { (photos) in
    //                self.loadedPhotos = photos
    //                self.delegate?.dogGround(didFinishLoading: photos)
    //            }
    //        }
    //        return loadedPhotos ?? []
    //    }
    
    //    func requestPhotos(completion: @escaping ([UIImage]) -> Void) {
    //        var photos: [UIImage] = []
    //
    //        DispatchQueue.global(qos: .utility).async {
    //            let semaphore = DispatchSemaphore(value: 0)
    //            for photoLinkSuffix in self.photosLnksSuffixes {
    //
    //                let urlString = "https://op.mos.ru/MEDIA/showFile?id=" + photoLinkSuffix.Photo
    //                if let url = URL(string: urlString) {
    //                    URLSession.shared.dataTask(with: url) { (data, response, error) in
    //                        if let error = error {
    //                            print("Photo loading error: \(error)")
    //                        }
    //
    //                        guard
    //                            let data = data,
    //                            let image = UIImage(data: data) else { return }
    //                        photos.append(image)
    //                        if photos.count == self.photosLnksSuffixes.count {
    //                            semaphore.signal()
    //                        }
    //                        }.resume()
    //                }
    //            }
    //
    //            semaphore.wait()
    //            DispatchQueue.main.async {
    //                print("call")
    //                completion(photos)
    //            }
    //        }
    //
    //    }
    
    //    func mapItem() -> MKMapItem {
    //        let addressDict = [CNPostalAddressStreetKey: title!]
    //        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    //        let mapItem = MKMapItem(placemark: placemark)
    //        mapItem.name = "Собачья площадка"
    //        return mapItem
    //    }
}

struct Schedule {
    var day: WeekDay
    var hours: String
    
    init(dayString: String, hours: String) {
        self.day = WeekDay(rawValue: dayString)!
        self.hours = hours
    }
    
    enum WeekDay: String {
        case monday = "понедельник"
        case tuesday = "вторник"
        case wednesday = "среда"
        case thursday = "четверг"
        case friday = "пятница"
        case saturday = "суббота"
        case sunday = "воскресенье"
    }
}

