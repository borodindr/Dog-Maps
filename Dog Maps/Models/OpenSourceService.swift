//
//  OpenSourceService.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import Foundation

let dogGroundsUrlString = "https://apidata.mos.ru/v1/features/2663?api_key=616e9481d0a656c24ed6bf0055b27576"

struct OpenSourceService {
    static func requestLocations(completion: @escaping ([LocationData]?, Error?) -> Void) {
        let url = URL(string: dogGroundsUrlString)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let locationData = try JSONDecoder().decode(OperSourceData.self, from: data)
                    let locations = locationData.features
                    completion(locations, nil)
                    
                    
                } catch {
                    completion(nil, error)
                }
            }
            }.resume()
    }
}

struct OperSourceData: Decodable {
    var features: [LocationData]?
}

struct LocationData: Decodable {
    var geometry: Geometry
    var properties: Property
    //    var type: String //no need
}

struct Geometry: Decodable {
    var coordinates: [Double]
    //    var type: String //no need
}

struct Property: Decodable {
    //    var DatasetId: Int //no need
    //    var VersionNumber: Int //no need
    //    var ReleaseNumber: Int //no need
    //    var RowId: Int? //no need
    var Attributes: Attribute
}

struct Attribute: Decodable {
    //for all requests:
    //    var global_id: Int //no need
    ///административный округ
    var AdmArea: String
    ///район
    var District: String
    var WorkingHours: [WorkingHours]
    
    //for dog grounds only:
    ///фотографии
    var Photo: [PhotosLnksSuffixes]?
    ///адрес площадки
    var Location: String?
    ///что есть на площадге
    var Elements: [String]?
    ///освещение -> Bool
    var Lighting: String?
    ///ограда -> Bool
    var Fencing: String?
    //    var departamentalAffiliation: String? //no need
    //    var DogParkArea: Double //no need
    
    //for clinics only:
    ///Полное название
    var FullName: String?
    ///Короткое название
    var ShortName: String?
    ///Контактные телефоны
    var PublicPhone: [PublicPhone]?
    ///Описание
    var Comments: String?
    ///Адрес клиники
    var Address: String?
}

struct PublicPhone: Decodable {
    ///Контактный телефон
    var PublicPhone: String
}

struct PhotosLnksSuffixes: Decodable {
    ///фотографии
    var Photo: String
}

struct WorkingHours: Decodable {
    ///режим работы: день
    var DayOfWeek: String
    ///режим работы: часы
    var Hours: String
    
}