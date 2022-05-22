//
//  ReamDB.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/05/21.
//

import UIKit
import RealmSwift

class Company: Object {
    @Persisted(primaryKey: false) var joiningDateId: String = ""
    @Persisted var joingingDate:Date = Date()
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var isCurrent: Bool = false
    @Persisted var schedule: List<Schedule>
    
    init(joiningDateId: String,
         joingingDate: Date,
         name: String,
         address: String,
         latitude: Double,
         longitude: Double,
         isCurrent: Bool) {
        self.init()
        
        self.joiningDateId = joiningDateId
        self.joingingDate = joingingDate
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isCurrent = isCurrent
    }
}

class Schedule: EmbeddedObject {
    @Persisted(primaryKey: true) var dateId: String = ""
    @Persisted var date: Date = Date()
    @Persisted var morning: String = ""
    @Persisted var afternoon: String = ""
    @Persisted var overtime: Double = 0
}
