//
//  ReamDB.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/05/21.
//

import UIKit
import RealmSwift

class Company: Object {
    @Persisted(primaryKey: false) var entryDateId: Int = 0
    @Persisted var year: String = ""
    @Persisted var month: String = ""
    @Persisted var day: String = ""
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var schedule: List<Schedule>
    
    convenience init(entryDate: Date, name: String, address: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.entryDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: entryDate))!
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(entryDate)
        self.year = String(format: "%02d", yearMonthDay.year)
        self.month = String(format: "%02d", yearMonthDay.month)
        self.day = String(format: "%02d", yearMonthDay.day)
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Schedule: EmbeddedObject {
    //@Persisted(primaryKey: true) var dateId: String = ""
    @Persisted var year: String = ""
    @Persisted var month: String = ""
    @Persisted var day: String = ""
    @Persisted var morning: String = ""
    @Persisted var afternoon: String = ""
    @Persisted var overtime: Int = 0
    
    convenience init(date: Date, morningType morning: WorkTimeType, afternoonType afternoon: WorkTimeType, overtime: Int) {
        self.init()
        
        //self.dateId = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date)
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
        self.year = String(format: "%02d", yearMonthDay.year)
        self.month = String(format: "%02d", yearMonthDay.month)
        self.day = String(format: "%02d", yearMonthDay.day)
        self.morning = morning.rawValue
        self.afternoon = afternoon.rawValue
        self.overtime = overtime
    }
}

class Vacation: Object {
    @Persisted(primaryKey: true) var dateId: Int = 0
    @Persisted var year: String = ""
    @Persisted var month: String = ""
    @Persisted var day: String = ""
    @Persisted var vacationType: String = VacationType.none.rawValue
    
    convenience init(date: Date, vacationType: VacationType) {
        self.init()
        
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
        self.year = String(format: "%02d", yearMonthDay.year)
        self.month = String(format: "%02d", yearMonthDay.month)
        self.day = String(format: "%02d", yearMonthDay.day)
        self.vacationType = vacationType.rawValue
    }
}
