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
    
    enum Status: Error {
        case success([LocationData])
        case noConnection
        case badConnection
        case unknownError
        case fetchError
    }
    
    static var shared = OpenSourceService()
    
    func requestLocations(completion: @escaping (Status) -> Void) {
        let url = URL(string: dogGroundsUrlString)!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error as NSError? {
                
                let status = self.errorStatus(of: error)
                completion(status)
            }
            
            if let data = data {
                do {
                    let locationData = try JSONDecoder().decode(OperSourceData.self, from: data)
                    guard let locations = locationData.features else {
                        completion(Status.fetchError)
                        return
                    }
                    let status = Status.success(locations)
                    completion(status)
                    
                    
                } catch {
                    let status = Status.fetchError
                    completion(status)
                }
            }
            }.resume()
    }
    
    private func errorStatus(of error: NSError) -> Status {
        let errorCode = error.code
        switch errorCode {
        case -1009:
            return .noConnection
        case -1001:
            return .badConnection
        default:
            return .unknownError
        }
    }
}

struct OperSourceData: Decodable {
    var features: [LocationData]?
}

struct LocationData: Decodable {
    var geometry: Geometry
    var properties: Property
}

struct Geometry: Decodable {
    var coordinates: [Double]
}

struct Property: Decodable {
    var Attributes: Attribute
}

struct Attribute: Decodable {
    ///административный округ
    var AdmArea: String
    ///район
    var District: String
    var WorkingHours: [WorkingHours]
    
    ///фотографии
    var Photo: [PhotosLinksSuffixes]?
    ///адрес площадки
    var Location: String?
    ///что есть на площадке
    var Elements: [String]?
    ///освещение -> Bool
    var Lighting: String?
    ///ограда -> Bool
    var Fencing: String?
    
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

struct PhotosLinksSuffixes: Decodable {
    ///фотографии
    var Photo: String
}

struct WorkingHours: Decodable {
    ///режим работы: день
    var DayOfWeek: String
    ///режим работы: часы
    var Hours: String
    
}
