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
    
//    mutating func addShedule(_ schedule: RecordScheduleType) {
//        switch schedule {
//        case .morning(let morning):
//            self.morning = morning
//            
//        case .afternoon(let afternoon):
//            self.afternoon = afternoon
//            
//        case .overtime(let overtime):
//            self.overtime = overtime
//        }
//    }
}
