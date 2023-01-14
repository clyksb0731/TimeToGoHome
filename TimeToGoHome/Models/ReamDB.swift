//
//  ReamDB.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/05/21.
//

import UIKit
import RealmSwift
import CoreLocation

// MARK: - CompanyModel
struct CompanyModel {
    // MARK: Handling company
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
    
    static private var companyNotification: NotificationToken?
    
    static var companies: Results<Company> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Company.self)
        }
    }
    
    func setCompanyLocation(address: String?, latitude: Double?, longitude: Double?) {
        let realm = try! Realm()
        
        try! realm.write {
            self.company?.address = address
            self.company?.latitude = latitude
            self.company?.longitude = longitude
        }
    }
    
    func setLeavingDate(_ date: Date?) {
        let realm = try! Realm()
        
        try! realm.write {
            self.company?.leavingDate = date
        }
    }
    
    func update(leavingDate: Date?, companyName name: String) {
        let realm = try! Realm()
        
        try! realm.write {
            self.company?.leavingDate = leavingDate
            self.company?.name = name
        }
    }
    
    static func addCompany(_ company: Company) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(company, update: .all)
        }
    }
    
    static func removeCompanyWithDateId(_ dateId: Int) {
        let realm = try! Realm()
        
        if let company = realm.object(ofType: Company.self, forPrimaryKey: dateId) {
            try! realm.write {
                realm.delete(company)
            }
        }
    }
    
    static func removeCompany(_ company: Company) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(company)
        }
    }
    
    static func observe(_ closure: (() -> ())?) {
        self.companyNotification = self.companies.observe({ changes in
            switch changes {
            case .initial(_):
                closure?()
                
            case .update(_, deletions: _, insertions: _, modifications: _):
                closure?()
                
            case .error(let error):
                fatalError("vacationNotification error: \(error.localizedDescription)")
            }
        })
    }
    
    static func invalidateObserving() {
        self.companyNotification?.invalidate()
    }
    
    static func checkIfJoiningDateIsNew(_ date: Date) -> Bool {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let joiningDateId = Int(dateFormatter.string(from: date))!
        
        let realm = try! Realm()
        let companies = realm.objects(Company.self).sorted(by: { $0.dateId < $1.dateId })
        
        if let lastCompany = companies.last, // sorted
            let leavingDate = lastCompany.leavingDate,
            let leavingDateId = Int(dateFormatter.string(from: leavingDate)) {
            
            return joiningDateId > leavingDateId
            
        } else {
            return true
        }
    }
    
    static func hasAnyCompanyExistedFor(joiningDate: Date, andLeavingDate leavingDate: Date, exceptCompany company: Company? = nil) -> Bool {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let joiningDateId = Int(dateFormatter.string(from: joiningDate))!
        let leavingDateId = Int(dateFormatter.string(from: leavingDate))!
        
        let realm = try! Realm()
        
        if let company = company {
            let companies = realm.objects(Company.self).filter {
                $0.dateId != company.dateId
            }
            
            for company in companies {
                let companyLeavingDateId = Int(dateFormatter.string(from: company.leavingDate ?? Date()))!
                if (company.dateId >= joiningDateId && company.dateId <= leavingDateId) ||
                (companyLeavingDateId >= joiningDateId && companyLeavingDateId <= leavingDateId) ||
                    (joiningDateId >= company.dateId && joiningDateId <= companyLeavingDateId) ||
                    (leavingDateId >= company.dateId && leavingDateId <= companyLeavingDateId) {
                    return true
                }
            }
            
        } else {
            let companies = realm.objects(Company.self)
            
            for company in companies {
                let companyLeavingDateId = Int(dateFormatter.string(from: company.leavingDate ?? Date()))!
                if (company.dateId >= joiningDateId && company.dateId <= leavingDateId) ||
                (companyLeavingDateId >= joiningDateId && companyLeavingDateId <= leavingDateId) ||
                    (joiningDateId >= company.dateId && joiningDateId <= companyLeavingDateId) ||
                    (leavingDateId >= company.dateId && leavingDateId <= companyLeavingDateId) {
                    return true
                }
            }
        }
        
        return false
    }
    
    static func getLastCompany() -> Company? {
        let realm = try! Realm()
        let companies = realm.objects(Company.self).sorted(by: { $0.dateId < $1.dateId })
        
        return companies.last
    }
    
    static func replaceCompany(_ company: Company, withJoiningDate joiningDate: Date, leavingDate: Date?, name: String) {
        let schedules = company.schedules
        
        let newCompany = Company(joiningDate: joiningDate, leavingDate: leavingDate, name: name, address: company.address, latitude: company.latitude, longitude: company.longitude)
        self.addCompany(newCompany)
        
        self.replaceSchedules(schedules, inCompany: newCompany)
        
        self.removeCompany(company)
    }
    
    // MARK: Handling schedule
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
    
    func getSchedulesBefore(_ date: Date) -> Results<Schedule>? {
        let dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: date))!
        
        let schedules = self.schedules?.where {
            $0.dateId < dateId
        }
        
        return schedules
    }
    
//    func setSchedule(_ schedule: Schedule) {
//        let realm = try! Realm()
//
//        let schedules = self.company?.schedules.where {
//            $0.dateId == schedule.dateId
//        }
//        try! realm.write {
//            schedules?.first?.year = schedule.year
//            schedules?.first?.month = schedule.month
//            schedules?.first?.day = schedule.day
//            schedules?.first?.morning = schedule.morning
//            schedules?.first?.afternoon = schedule.afternoon
//            schedules?.first?.overtime = schedule.overtime
//        }
//    }
    
    func applySchedule(_ schedule: Schedule) {
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
    
    func removeScheduleAtDateId(_ dateId: Int) {
        let realm = try! Realm()
        
        if let index = self.schedules?.firstIndex(where: { $0.dateId == dateId }) {
            try! realm.write {
                self.schedules?.remove(at: index)
            }
        }
    }
    
    func replaceSchedules(_ schedules: List<Schedule>) {
        let realm = try! Realm()
        
        try! realm.write {
            self.company?.schedules.removeAll()
            
            for schedule in schedules {
                let date = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(schedule.dateId))!
                let schedule = Schedule(date: date, morningType: WorkTimeType(rawValue: schedule.morning)!, afternoonType: WorkTimeType(rawValue: schedule.afternoon)!, overtime: schedule.overtime)
                self.company?.schedules.append(schedule)
            }
        }
    }
    
    func convertSchedulesToWorkRecords() -> [WorkRecord] {
        if let schedules = self.schedules?.sorted(by: { $0.dateId < $1.dateId }) {
            var workRecords: [WorkRecord] = []
            var workRecord = WorkRecord(yearMonth: "", schedules: [])
            let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: Date()))
            
            for schedule in schedules {
                let morning = WorkTimeType(rawValue: schedule.morning)!
                let afternoon = WorkTimeType(rawValue: schedule.afternoon)!
                
                if schedule.dateId == todayDateId || (morning == .holiday && afternoon == .holiday) {
                    continue
                }
                
                let yearMonth = String(format: "%02d%02d", schedule.year, schedule.month)
                if workRecord.yearMonth != yearMonth {
                    if workRecord.yearMonth != "" {
                        workRecord.schedules = workRecord.schedules.sorted {
                            $0.dateId < $1.dateId
                        }
                        workRecords.append(workRecord)
                    }
                    
                    workRecord = WorkRecord(yearMonth: yearMonth, schedules: [])
                }
                
                let dailySchedule = DailySchedule(dateId: schedule.dateId,
                                                  day: schedule.day,
                                                  morning: morning,
                                                  afternoon: afternoon,
                                                  overtime: schedule.overtime)
                workRecord.schedules.append(dailySchedule)
            }
            
            if workRecord.yearMonth != "" {
                workRecord.schedules = workRecord.schedules.sorted {
                    $0.dateId < $1.dateId
                }
                workRecords.append(workRecord)
            }
            
            return workRecords
            
        } else {
            return []
        }
    }
    
    static func replaceSchedules(_ schedules: List<Schedule>, inCompany company: Company) {
        let realm = try! Realm()
        
        try! realm.write {
            company.schedules.removeAll()
            
            for schedule in schedules {
                let date = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(schedule.dateId))!
                let schedule = Schedule(date: date, morningType: WorkTimeType(rawValue: schedule.morning)!, afternoonType: WorkTimeType(rawValue: schedule.afternoon)!, overtime: schedule.overtime)
                company.schedules.append(schedule)
            }
        }
    }
}

// MARK: VacationModel
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
    
    static private var vacationNotification: NotificationToken?
    
    static var vacations: Results<Vacation> {
        get {
            let realm = try! Realm()
            
            return realm.objects(Vacation.self)
        }
    }
    
    static var annualPaidHolidaysType: AnnualPaidHolidaysType {
        set {
            ReferenceValues.initialSetting.updateValue(newValue.rawValue, forKey: InitialSetting.annualPaidHolidaysType.rawValue)
            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
        }
        
        get {
            if let annualPaidHolidaysType = ReferenceValues.initialSetting[InitialSetting.annualPaidHolidaysType.rawValue] as? String,
               let annualPaidHolidaysType = AnnualPaidHolidaysType(rawValue: annualPaidHolidaysType) {
                return annualPaidHolidaysType
                
            } else {
                return .fiscalYear
            }
        }
    }
    
    static func observe(_ closure: (() -> ())?) {
        self.vacationNotification = self.vacations.observe({ changes in
            switch changes {
            case .initial(_):
                closure?()
                
            case .update(_, deletions: _, insertions: _, modifications: _):
                closure?()
                
            case .error(let error):
                fatalError("vacationNotification error: \(error.localizedDescription)")
            }
        })
    }
    
    static func invalidateObserving() {
        self.vacationNotification?.invalidate()
    }
    
    static func addVacation(_ vacation: Vacation) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(vacation, update: .all)
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
    
    static func determineVacationScheduleDateRange() -> (startDate: Date, endDate: Date) {
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
            
            if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date, leavingDate < endDate {
                return (startDate, leavingDate)
                
            } else {
                return (startDate, endDate)
            }
            
            
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
            
            if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date, leavingDate < endDayOfVacationDate {
                return (firstDayOfVacationDate, leavingDate)
                
            } else {
                return (firstDayOfVacationDate, endDayOfVacationDate)
            }
        }
    }
    
    func removeFromDB() {
        let realm = try! Realm()
        
        if let vacation = self.vacation {
            try! realm.write {
                realm.delete(vacation)
            }
        }
    }
    
    static func removeVacationAtDateId(_ dateId: Int) {
        let realm = try! Realm()
        
        if let vacation = realm.object(ofType: Vacation.self, forPrimaryKey: dateId) {
            try! realm.write {
                realm.delete(vacation)
            }
        }
    }
    
    static func removeAllVacations() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(self.vacations)
        }
    }
}

// MARK: - Realm Scheme
class Company: Object {
    @Persisted(primaryKey: true) var dateId: Int = 0
    @Persisted var leavingDate: Date?
    @Persisted var year: Int = 0
    @Persisted var month: Int = 0
    @Persisted var day: Int = 0
    @Persisted var name: String = ""
    @Persisted var address: String?
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var schedules: List<Schedule>
    
    convenience init(joiningDate: Date, leavingDate: Date? = nil, name: String, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
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
