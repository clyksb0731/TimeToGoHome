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
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

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
    
}

// MARK: - Extension for selector methods
extension WorkRecordViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension WorkRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WorkRecordHeaderView") as! WorkRecordHeaderView
        if section == 0 {
            headerView.setHeaderView(yearMonth: "2019년 2월")
        }
        if section == 1 {
            headerView.setHeaderView(yearMonth: "2019년 3월")
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkRecordCell", for: indexPath) as! WorkRecordCell
        if indexPath.row == 0 {
            cell.setCell(dateId: 20190202, day: 2, morning: .work, afternoon: .work, overtime: 3000)
        }
        if indexPath.row == 1 {
            cell.setCell(dateId: 20190202, day: 3, morning: .vacation, afternoon: .work, overtime: 3700)
        }
        if indexPath.row == 2 {
            cell.setCell(dateId: 20190202, day: 25, morning: .holiday, afternoon: .work, overtime: 7300)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
