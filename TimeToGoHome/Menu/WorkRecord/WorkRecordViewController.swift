//
//  WorkRecordViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/22.
//

import UIKit

class WorkRecordViewController: UIViewController {
    
    lazy var workRecordTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(WorkRecordCell.self, forCellReuseIdentifier: "WorkRecordCell")
        tableView.register(WorkRecordHeaderView.self, forHeaderFooterViewReuseIdentifier: "WorkRecordHeaderView")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var workRecords: [WorkRecord] = []
    
    var companyModel: CompanyModel
    
    var isThisVcSeen: Bool = false
    
    init(companyModel: CompanyModel) {
        self.companyModel = companyModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.determineTableViewWithRecordedSchedules()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- WorkRecordViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension WorkRecordViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "근무 내역"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusDataButtonImage"), style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
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
            self.workRecordTableView
        ], to: self.view)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // workRecordTableView
        NSLayoutConstraint.activate([
            self.workRecordTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.workRecordTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.workRecordTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.workRecordTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension WorkRecordViewController {
    func determineTableViewWithRecordedSchedules() {
        self.workRecords = self.companyModel.convertSchedulesToWorkRecords()
        self.workRecordTableView.reloadData()
        
        guard !self.isThisVcSeen, self.workRecords.count > 1,
                self.workRecords[self.workRecords.count - 1].schedules.count > 1 else {
            return
        }
        
        let bottomIndexPath = IndexPath(row: self.workRecords[self.workRecords.count - 1].schedules.count - 1, section: self.workRecords.count - 1)
        
        DispatchQueue.main.async {
            self.workRecordTableView.scrollToRow(at: bottomIndexPath, at: .bottom, animated: false)
        }
        
        self.isThisVcSeen = true
    }
}

// MARK: - Extension for selector methods
extension WorkRecordViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let menuCoverVC = MenuCoverViewController(.calendarOfScheduleRecord(companyModel: self.companyModel))
        
        self.present(menuCoverVC, animated: false)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension WorkRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.workRecords.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WorkRecordHeaderView") as! WorkRecordHeaderView
        headerView.setHeaderView(yearMonth: self.workRecords[section].yearMonth)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.workRecords[section].schedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkRecordCell", for: indexPath) as! WorkRecordCell
        cell.setCell(dateId: self.workRecords[indexPath.section].schedules[indexPath.row].dateId,
                     day: self.workRecords[indexPath.section].schedules[indexPath.row].day,
                     morning: self.workRecords[indexPath.section].schedules[indexPath.row].morning,
                     afternoon: self.workRecords[indexPath.section].schedules[indexPath.row].afternoon,
                     overtime: self.workRecords[indexPath.section].schedules[indexPath.row].overtime)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailySchedule = self.workRecords[indexPath.section].schedules[indexPath.row]
        
        let recordedSchedule = WorkScheduleRecordModel(dateId: dailySchedule.dateId, morning: dailySchedule.morning, afternoon: dailySchedule.afternoon, overtime: dailySchedule.overtime)
        
        let dayWorkRecordVC = DayWorkRecordViewController(recordedSchedule: recordedSchedule, companyModel: self.companyModel)
        
        self.navigationController?.pushViewController(dayWorkRecordVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            let date = SupportingMethods.shared.makeDateFormatter("yyyyMM").date(from: self.workRecords[indexPath.section].yearMonth)!
            let yearMonth = SupportingMethods.shared.makeDateFormatter("yyyy년 M월").string(from: date)
            let dateId = self.workRecords[indexPath.section].schedules[indexPath.row].dateId
            
            UIDevice.lightHaptic()
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "근무 내역 삭제", andMessage: "\(yearMonth) \(self.workRecords[indexPath.section].schedules[indexPath.row].day)일 근무 내역을 삭제할까요?", okAction: UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                
                self.companyModel.removeScheduleAtDateId(dateId)
                
                self.determineTableViewWithRecordedSchedules()
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
            
            completionHandler(true)
        }
        //action.backgroundColor = .blue
        //action.image = UIImage(named: "")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [action])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}
