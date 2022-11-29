//
//  MenuViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class MenuViewController: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var menuMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "메뉴"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var topViewBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.register(MenuHeaderView.self, forHeaderFooterViewReuseIdentifier: "MenuHeaderView")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var leavingDate: Date? = {
        return ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date
    }()
    
    let menuArray: [(header: String, items:[(menuStyle: MenuSettingCellType, menuText: String)])] = [
        (header: "근무",
         items: [
            (menuStyle: .openVC, menuText: "근무 내역"),
            (menuStyle: .openVC, menuText: "근무 통계")
         ]
        ),
        
        (header: "휴가",
         items: [
            (menuStyle: .openVC, menuText: "휴가 사용 현황"),
            (menuStyle: .openVC, menuText: "휴가 일정")
         ]
        ),
        
        (header: "경력관리",
         items: [
            (menuStyle: .label(SupportingMethods.shared.makeDateFormatter("yyyy.M.d").string(from: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)), menuText: "입사일"),
            (menuStyle: .openVC, menuText: "경력 사항"),
            (menuStyle: .button, menuText: "퇴직 처리")
         ]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewFoundation()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- MenuViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension MenuViewController: EssentialViewMethods {
    func setViewFoundation() {
        // Backgroud color
        self.view.backgroundColor = .white
        
        // Navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        
        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.topView,
            self.menuTableView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.menuMarkLabel,
            self.topViewBottomLineView
        ], to: self.topView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // topView
        NSLayoutConstraint.activate([
            self.topView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topView.heightAnchor.constraint(equalToConstant: 96),
            self.topView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.topView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // dismissButton
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.topView.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // menuMarkLabel
        NSLayoutConstraint.activate([
            self.menuMarkLabel.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: -8),
            self.menuMarkLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 16)
        ])
        
        // topViewBottomLineView
        NSLayoutConstraint.activate([
            self.topViewBottomLineView.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.topViewBottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.topViewBottomLineView.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor),
            self.topViewBottomLineView.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor)
        ])
        
        // menuTableView
        NSLayoutConstraint.activate([
            self.menuTableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.menuTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.menuTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.menuTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MenuViewController {
    func convertToWorkRecordsFromSchedules() -> [WorkRecord] {
        if let schedules = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date).schedules {
            var workRecords: [WorkRecord] = []
            var workRecord = WorkRecord(yearMonth: "", schedules: [])
            
            for schedule in schedules {
                let yearMonth = "\(schedule.year)년 \(schedule.month)월"
                if workRecord.yearMonth != yearMonth {
                    if workRecord.yearMonth != "" {
                        workRecords.append(workRecord)
                    }
                    
                    workRecord = WorkRecord(yearMonth: yearMonth, schedules: [])
                }
                
                let morning = WorkTimeType(rawValue: schedule.morning)!
                let afternoon = WorkTimeType(rawValue: schedule.afternoon)!
                if morning != .holiday && afternoon != .holiday {
                    let dailySchedule = DailySchedule(dateId: schedule.dateId,
                                                      day: schedule.day,
                                                      morning: morning,
                                                      afternoon: afternoon,
                                                      overtime: schedule.overtime)
                    workRecord.schedules.append(dailySchedule)
                }
            }
            
            if workRecord.yearMonth != "" {
                workRecords.append(workRecord)
            }
            
            return workRecords
            
        } else {
            return []
        }
    }
}

// MARK: - Extension for Selector methods
extension MenuViewController {
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderView") as! MenuHeaderView
        headerView.setHeaderView(categoryText: self.menuArray[section].header)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: Date()))!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        if let leavingDate = self.leavingDate {
            let leavingDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: leavingDate))!
            cell.setCell(self.menuArray[indexPath.section].items[indexPath.row].menuStyle,
                         itemText: self.menuArray[indexPath.section].items[indexPath.row].menuText,
                         isEnable: todayDateId <= leavingDateId || (indexPath.section == 2 && indexPath.row == 1))
            
        } else {
            cell.setCell(self.menuArray[indexPath.section].items[indexPath.row].menuStyle,
                         itemText: self.menuArray[indexPath.section].items[indexPath.row].menuText,
                         isEnable: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 1 {
//            let careerVC = CareerViewController()
//
//            self.navigationController?.pushViewController(careerVC, animated: true)
            
            // FIXME: for test
            let dayWorkRecordVC = DayWorkRecordViewController(workScheduleRecord: WorkScheduleRecordModel(dateId: 20221130, morning: .work, afternoon: .work, overtime: 3600))
            
            self.navigationController?.pushViewController(dayWorkRecordVC, animated: true)
        }
        
        let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: Date()))!
        if let leavingDate = self.leavingDate {
            let leavingDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: leavingDate))!
            if todayDateId > leavingDateId {
                return
            }
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let workRecordVC = WorkRecordViewController()
            workRecordVC.workRecords = self.convertToWorkRecordsFromSchedules()
            
            self.navigationController?.pushViewController(workRecordVC, animated: true)
        }
        
        if indexPath.section == 2 && indexPath.row == 2 {
            let menuCoverVC = MenuCoverViewController(.lastDateAtWork, delegate: self)
            
            self.present(menuCoverVC, animated: false)
        }
    }
}

// MARK: - Extension for MenuCoverDelegate
extension MenuViewController: MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date) {
        let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
        
        let targetDate = SupportingMethods.shared.makeDateFormatter("yyyy년 M월 d일").string(from: date)
        
        if let schedules = companyModel.getSchedulesAfter(date), !schedules.isEmpty {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "퇴직 처리", andMessage: "\(targetDate) 이후에 기록된 일정이 있습니다. 퇴직 처리 시 해당 일정이 삭제됩니다. 퇴직 처리할까요?", okAction: UIAlertAction(title: "퇴직 처리", style: .default, handler: { _ in
                companyModel.removeSchedules(schedules)
                companyModel.setLeavingDate(date)
                
                self.leavingDate = date
                ReferenceValues.initialSetting.updateValue(date, forKey: InitialSetting.leavingDate.rawValue)
                SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                
                // FIXME: Go to menu? Main? How to handle today schedule after this?
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
            
        } else {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "퇴직 처리", andMessage: "\(targetDate)부로 퇴직 처리할까요?", okAction: UIAlertAction(title: "퇴직 처리", style: .default, handler: { _ in
                companyModel.setLeavingDate(date)
                
                self.leavingDate = date
                ReferenceValues.initialSetting.updateValue(date, forKey: InitialSetting.leavingDate.rawValue)
                SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                
                // FIXME: Go to menu? Main? How to handle today schedule after this?
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
        }
    }
}
