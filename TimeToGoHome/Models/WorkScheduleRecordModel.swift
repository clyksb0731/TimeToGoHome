//
//  WorkScheduleRecordModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/29.
//

import Foundation

enum RecordScheduleType {
    case morning(WorkTimeType)
    case afternoon(WorkTimeType)
    case overtime(Int)
}

struct WorkScheduleRecordModel {
    var dateId: Int
    
    var morning: WorkTimeType?
    var afternoon: WorkTimeType?
    var overtime: Int?
    
    var count: Int {
        if self.overtime != nil {
            return 3
            
        } else if self.afternoon != nil {
            return 2
            
        } else if self.morning != nil {
            return 1
            
        } else {
            return 0
        }
    }
    
    var regularWorkType: MenuCoverRegularWorkType? {
        if self.morning == .work && self.afternoon == .work {
            return .fullWork
            
        } else if self.afternoon == .work {
            return .halfWork
            
        } else {
            return nil
        }
    }
    
    func updateDB(companyModel: CompanyModel) {
        if let date = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.dateId)), let morning = self.morning, let afternoon = self.afternoon {
            let schedule = Schedule(date: date, morningType: morning, afternoonType: afternoon, overtime: self.overtime)
            
            companyModel.addSchedule(schedule)
            
            var vacation: Vacation!
            if morning == .vacation && afternoon == .vacation {
                vacation = Vacation(date: date, vacationType: .fullDay)
                
            } else if morning == .vacation {
                vacation = Vacation(date: date, vacationType: .morning)
                
            } else if afternoon == .vacation {
                vacation = Vacation(date: date, vacationType: .afternoon)
                
            } else {
                vacation = Vacation(date: date, vacationType: .none)
            }
            VacationModel.addVacation(vacation)
        }
    }
}
