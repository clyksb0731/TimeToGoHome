//
//  ReamDB.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/05/21.
//

import UIKit
import RealmSwift

struct CompanyModel {
    private let dateId: Int
    
    init(joiningDate: Date) {
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: joiningDate))!
    }
    
    var company: Company? {
        get {
            let realm = try! Realm()
            
            return realm.object(ofType: Company.self, forPrimaryKey: self.dateId)
        }
        
        set {
            let realm = try! Realm()
            
            if let newValue = newValue {
                try! realm.write {
                    realm.add(newValue, update: .modified)
                }
            }
        }
    }
    
    var schedules: List<Schedule>? {
        return self.company?.schedules
    }
    
    static var companies: Results<Company> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Company.self)
        }
    }
    
    func getScheduleOn(_ date: Date) -> Schedule? {
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
        let schedules = self.company?.schedules.where {
            $0.year == yearMonthDay.year &&
            $0.month == yearMonthDay.month &&
            $0.day == yearMonthDay.day
        }
        return schedules?.first
    }
    
    func setSchedule(_ schedule: Schedule) {
        let realm = try! Realm()
        
        let schedules = self.company?.schedules.where {
            $0.year == schedule.year &&
            $0.month == schedule.month &&
            $0.day == schedule.day
        }
        try! realm.write {
            schedules?.first?.year = schedule.year
            schedules?.first?.month = schedule.month
            schedules?.first?.day = schedule.day
            schedules?.first?.morning = schedule.morning
            schedules?.first?.afternoon = schedule.afternoon
            schedules?.first?.overtime = schedule.overtime
        }
    }
    
    func addSchedule(_ schedule: Schedule) {
        let realm = try! Realm()
        
        let schedules = self.company?.schedules.where {
            $0.year == schedule.year &&
            $0.month == schedule.month &&
            $0.day == schedule.day
        }
        
        if let existingSchedule = schedules?.first {
            try! realm.write {
                existingSchedule.year = schedule.year
                existingSchedule.month = schedule.month
                existingSchedule.day = schedule.day
                existingSchedule.morning = schedule.morning
                existingSchedule.afternoon = schedule.afternoon
                existingSchedule.overtime = schedule.overtime
            }
            
        } else {
            try! realm.write {
                self.schedules?.append(schedule)
            }
        }
    }
    
    static func addCompany(_ company: Company) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(company, update: .all)
        }
    }
    
    static func checkDuplicateJoiningDate(_ date: Date) -> Bool {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let joiningDateId = Int(dateFormatter.string(from: date))!
        
        let realm = try! Realm()
        
        let companies = realm.objects(Company.self)
        for company in companies {
            if let leftDate = company.leavingDate {
                let joinedDateId = Int(String(format: "%02d%02d%02d", company.year, company.month, company.day))!
                let leftDateId = Int(dateFormatter.string(from: leftDate))!
                
                if joiningDateId >= joinedDateId && joiningDateId <= leftDateId {
                    return true
                }
            }
        }
        
        return false
    }
}

struct VacationModel {
    private let dateId: Int
    
    init(date: Date) {
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
    }
    
    var vacation: Vacation? {
        get {
            let realm = try! Realm()
            
            return realm.object(ofType: Vacation.self, forPrimaryKey: self.dateId)
        }
        
        set {
            let realm = try! Realm()
            
            if let newValue = newValue {
                realm.add(newValue, update: .modified)
            }
        }
    }
    
    static var vacations: Results<Vacation> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Vacation.self)
        }
    }
    
    static func addVacation(_ vacation: Vacation) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(vacation, update: .all)
        }
    }
}

class Company: Object {
    @Persisted(primaryKey: true) var dateId: Int = 0
    @Persisted var leavingDate: Date?
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var name: String = ""
    @Persisted var address: String = ""
    @Persisted var latitude: Double = 0
    @Persisted var longitude: Double = 0
    @Persisted var schedules: List<Schedule>
    
    convenience init(joiningDate: Date, leavingDate: Date? = nil, name: String, address: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: joiningDate))!
        self.leavingDate = leavingDate
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(joiningDate)
        self.year = yearMonthDay.year
        self.month = yearMonthDay.month
        self.day = yearMonthDay.day
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}

class Schedule: EmbeddedObject {
    @Persisted var dateId: Int = 0
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var morning: String = ""
    @Persisted var afternoon: String = ""
    @Persisted var overtime: Int?
    
    convenience init(date: Date, morningType morning: WorkTimeType, afternoonType afternoon: WorkTimeType, overtime: Int? = nil) {
        self.init()
        
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
        self.year = yearMonthDay.year
        self.month = yearMonthDay.month
        self.day = yearMonthDay.day
        self.morning = morning.rawValue
        self.afternoon = afternoon.rawValue
        self.overtime = overtime
    }
}

class Vacation: Object {
    @Persisted(primaryKey: true) var dateId: Int = 0
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var vacationType: String = VacationType.none.rawValue
    
    convenience init(date: Date, vacationType: VacationType) {
        self.init()
        
        self.dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
        self.year = yearMonthDay.year
        self.month = yearMonthDay.month
        self.day = yearMonthDay.day
        self.vacationType = vacationType.rawValue
    }
}
