//
//  LocationAnnotaion.swift
//  Dog Maps
//
//  Created by Dmitry Borodin on 17/06/2019.
//  Copyright © 2019 Dmitry Borodin. All rights reserved.
//

import Foundation
import MapKit

class LocationAnnotaion: NSObject, MKAnnotation {
    
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
    
    init(data: LocationData) {
        self.rawCoordinates = data.geometry.coordinates
        self.admArea = data.properties.Attributes.AdmArea
        self.district = data.properties.Attributes.District
        self.rawSchedule = data.properties.Attributes.WorkingHours
    }
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

