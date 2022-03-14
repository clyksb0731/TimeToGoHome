//
//  MainCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/15.
//

import UIKit

protocol MainCoverDelegate {
    func mainCoverDidSelectNormalSchedule(_ scheduleType: ScheduleType)
}

extension MainCoverDelegate {
    func mainCoverDidSelectNormalSchedule(_ scheduleType: ScheduleType) { } // Optional effect
}

enum MainCoverType {
    case normalSchedule
    case overtimeSchedule
}

class MainCoverViewController: UIViewController {
    
    var delegate: MainCoverDelegate?
    
    init(_ mainCoverType: MainCoverType) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
