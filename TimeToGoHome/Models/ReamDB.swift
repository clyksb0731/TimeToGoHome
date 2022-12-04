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
    
    static var companies: Results<Company> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Company.self)
        }
    }
    
    func setLeavingDate(_ date: Date?) {
        let realm = try! Realm()
        
        try! realm.write {
            self.company?.leavingDate = date
        }
    }
    
    var schedules: List<Schedule>? {
        return self.company?.schedules
    }
    
    func getScheduleOn(_ date: Date) -> Schedule? {
        let dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        
        let schedules = self.company?.schedules.where {
            $0.dateId == dateId
        }
        
        return schedules?.first
    }
    
    func getSchedulesAfter(_ date: Date) -> Results<Schedule>? {
        let dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        
        let schedules = self.schedules?.where {
            $0.dateId > dateId
        }
        
        return schedules
    }
    
    func setSchedule(_ schedule: Schedule) {
        let realm = try! Realm()
        
        let schedules = self.company?.schedules.where {
            $0.dateId == schedule.dateId
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
            $0.dateId == schedule.dateId
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
    
    func removeSchedules(_ schedules: Results<Schedule>) {
        let realm = try! Realm()
        
        for schedule in schedules {
            if let index = self.schedules?.firstIndex(where: { $0.dateId == schedule.dateId }) {
                try! realm.write {
                    self.schedules?.remove(at: index)
                }
            }
        }
    }
    
    func removeSchedule(_ schedule: Schedule) {
        let realm = try! Realm()
        
        if let index = self.schedules?.firstIndex(where: { $0.dateId == schedule.dateId }) {
            try! realm.write {
                self.schedules?.remove(at: index)
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
    
    static var annualPaidHolidaysType: AnnualPaidHolidaysType = {
        if let annualPaidHolidaysType = ReferenceValues.initialSetting[InitialSetting.annualPaidHolidayType.rawValue] as? String,
            let annualPaidHolidaysType = AnnualPaidHolidaysType(rawValue: annualPaidHolidaysType) {
            return annualPaidHolidaysType
            
        } else {
            return .fiscalYear
        }
    }() {
        didSet {
            ReferenceValues.initialSetting.updateValue(self.annualPaidHolidaysType.rawValue, forKey: InitialSetting.annualPaidHolidayType.rawValue)
            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
        }
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
    
    private static func determineVacationScheduleDateRange() -> (startDate: Date, endDate: Date) {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        if self.annualPaidHolidaysType == .fiscalYear {
            let yearMonthDayOfJoiningDate = SupportingMethods.shared.getYearMonthAndDayOf(ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
            let joiningDateFromYearMonthDay = SupportingMethods.shared.makeDateWithYear(yearMonthDayOfJoiningDate.year, month: yearMonthDayOfJoiningDate.month, andDay: yearMonthDayOfJoiningDate.day)
            
            let firstDayOfYearDateComponents = DateComponents(year: todayDateComponents.year!, month: 1, day: 1)
            let lastDayOfYearDateComponents = DateComponents(year: todayDateComponents.year!, month: 12, day: 31)
            
            let startDate = joiningDateFromYearMonthDay >= calendar.date(from: firstDayOfYearDateComponents)! ? joiningDateFromYearMonthDay : calendar.date(from: firstDayOfYearDateComponents)!
            let endDate = calendar.date(from: lastDayOfYearDateComponents)!
            
            return (startDate, endDate)
            
        } else { // joiningDay
            var firstDayOfVacationDate = ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date
            let joiningDateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfVacationDate)
            var endDayOfVacationDate: Date
            
            if joiningDateComponents.month! < todayDateComponents.month! {
                // First date of vacation
                let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                
                firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                
                // End date of vacation
                let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! + 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                
                endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                
            } else if joiningDateComponents.month! == todayDateComponents.month! {
                if joiningDateComponents.day! <= todayDateComponents.day! {
                    // First date of vacation
                    let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    
                    firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                    
                    // End date of vacation
                    let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! + 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                    
                    endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                    
                } else { // joiningDateComponents.day! > self.todayDateComponents.day!
                    // First date of vacation
                    let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! - 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    
                    firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                    
                    // End date of vacation
                    let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                    
                    endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                }
                
            } else { // joiningDateComponents.month! > self.todayDateComponents.month!
                // First date of vacation
                let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! - 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                
                firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                
                // End date of vacation
                let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                
                endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
            }
            
            return (firstDayOfVacationDate, endDayOfVacationDate)
        }
    }
    
    static var vacations: Results<Vacation> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Vacation.self)
        }
    }
    
    static var numberOfVacationsHold: Double {
        let vacations = VacationModel.vacations
        
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        
        let periodVacations = vacations.where {
            $0.dateId >= Int(dateFormatter.string(from: self.determineVacationScheduleDateRange().startDate))!
            && $0.dateId <= Int(dateFormatter.string(from: self.determineVacationScheduleDateRange().endDate))!
        }
        
        let fullDayVacations = periodVacations.where {
            $0.vacationType == VacationType.fullDay.rawValue
        }
        
        let halfDayVacations = periodVacations.where {
            $0.vacationType == VacationType.morning.rawValue ||
            $0.vacationType == VacationType.afternoon.rawValue
        }
        
        return Double(fullDayVacations.count) * 1 + Double(halfDayVacations.count) * 0.5
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
