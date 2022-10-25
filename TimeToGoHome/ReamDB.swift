//
//  ReamDB.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/05/21.
//

import UIKit
import RealmSwift

class Company: Object {
    @Persisted(primaryKey: false) var dateId: String = ""
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var isCurrent: Bool = false
    @Persisted var schedule: List<Schedule>
    
    convenience init(joiningDateId dateId: String, name: String, address: String, latitude: Double, longitude: Double, isCurrent: Bool) {
        self.init()

        self.dateId = dateId
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrent = isCurrent
    }
}

class Schedule: EmbeddedObject {
    @Persisted(primaryKey: true) var dateId: String = ""
    @Persisted var morning: String = ""
    @Persisted var afternoon: String = ""
    @Persisted var overtime: Int = 0
    
    convenience init(dayDateId dateId: String, morningType morning: WorkTimeType, afternoonType afternoon: WorkTimeType, overtime: Int) {
        self.init()
        
        self.dateId = dateId
        self.morning = morning.rawValue
        self.afternoon = afternoon.rawValue
        self.overtime = overtime
    }
}

class Vacation: Object {
    @Persisted(primaryKey: true) var dateId: String = ""
    @Persisted var vacationType: String = VacationType.none.rawValue
}
