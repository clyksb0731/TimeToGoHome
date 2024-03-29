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
    
    func updateDB(companyModel: CompanyModel) {
        if let morning = self.morning, let afternoon = self.afternoon {
            if morning == .holiday && afternoon == .holiday {
                companyModel.removeScheduleAtDateId(self.dateId) // Remove full holiday from recorded schedules.
                
                print("Remove full holiday from recorded schedules.")
                
            } else {
                let date = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.dateId))!
                let schedule = Schedule(date: date, morningType: morning, afternoonType: afternoon, overtime: self.overtime)
                
                companyModel.applySchedule(schedule)
                
                print("Apply schedule of work record.")
                
                var vacation: Vacation!
                if morning == .vacation && afternoon == .vacation {
                    vacation = Vacation(date: date, vacationType: .fullDay)
                    print("Apply full vacation.")
                    
                } else if morning == .vacation {
                    vacation = Vacation(date: date, vacationType: .morning)
                    print("Apply morning vacation.")
                    
                } else if afternoon == .vacation {
                    vacation = Vacation(date: date, vacationType: .afternoon)
                    print("Apply afternoon vacation.")
                    
                } else {
                    vacation = Vacation(date: date, vacationType: .none)
                }
                VacationModel.addVacation(vacation)
            }
        }
    }
}
