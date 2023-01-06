//
//  SettingViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class SettingViewController: UIViewController {
    
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
    
    lazy var settingMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var topViewBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var settingTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(SettingSubCell.self, forCellReuseIdentifier: "SettingSubCell")
        tableView.register(SettingHeaderView.self, forHeaderFooterViewReuseIdentifier: "SettingHeaderView")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var settingArray: [(header: String, items:[(style: MenuSettingCellType, text: String)])] {
        [
            (header: "알림",
             items: SupportingMethods.shared.useAppSetting(for: .pushActivation) as? Bool == true ? [
                (style: .switch(true), text: "알림 설정"),
                (style: .switch(SupportingMethods.shared.useAppSetting(for: .alertSettingStartingWorkTime) as? Bool == true), text: "ㄴ 출근 시간 설정 알림"),
                (style: .switch(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as? Bool == true), text: "ㄴ 업무 종료 알림") // FIXME: Need to determine boolean value
             ] : [
                (style: .switch(false), text: "알림 설정")
             ]
            ),
            
            (header: "근무",
             items: [
                (style: .openVC, text: "근무 형태"),
                (style: .openVC, text: "근무지")
             ]
            ),
            
            (header: "휴무",
             items: [
                (style: .openVC, text: "연차"),
                (style: .openVC, text: "정기 휴일")
             ]
            ),
        ]
    }

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
        
        //self.menuTableView.reloadData()
    }
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- SettingViewController disposed -----------------------------------")
    }

}

// MARK: - Extension for methods added
extension SettingViewController {
    
}

// MARK: - Extension for selector methods
extension SettingViewController {
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: - Extension for essential methods
extension SettingViewController: EssentialViewMethods {
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
            self.settingTableView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.settingMarkLabel,
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
        
        // settingMarkLabel
        NSLayoutConstraint.activate([
            self.settingMarkLabel.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: -8),
            self.settingMarkLabel.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor, constant: 16)
        ])
        
        // topViewBottomLineView
        NSLayoutConstraint.activate([
            self.topViewBottomLineView.bottomAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.topViewBottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.topViewBottomLineView.leadingAnchor.constraint(equalTo: self.topView.leadingAnchor),
            self.topViewBottomLineView.trailingAnchor.constraint(equalTo: self.topView.trailingAnchor)
        ])
        
        // settingTableView
        NSLayoutConstraint.activate([
            self.settingTableView.topAnchor.constraint(equalTo: self.topView.bottomAnchor),
            self.settingTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.settingTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.settingTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingViewController {
    
}

// MARK: - Extension for selector methods
extension SettingViewController {
    @objc func controlPushSwitch(_ sender: YSBlueSwitch) {
        print("section:\(sender.indexPath.section ), row:\(sender.indexPath.row) switch is \(sender.isOn ? "On" : "Off")")
        if sender.indexPath.section == 0 {
            if sender.indexPath.row == 0 {
                if sender.isOn {
                    SupportingMethods.shared.setAppSetting(with: true, for: .pushActivation)
                    
                    self.settingTableView.reloadSections([0], with: .automatic)
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: false, for: .pushActivation)
                    SupportingMethods.shared.setAppSetting(with: false, for: .alertSettingStartingWorkTime)
                    SupportingMethods.shared.setAppSetting(with: false, for: .alertFinishingWorkTime)
                    
                    self.settingTableView.reloadSections([0], with: .automatic)
                }
            }
            
            if sender.indexPath.row == 1 {
                if sender.isOn {
                    SupportingMethods.shared.setAppSetting(with: true, for: .alertSettingStartingWorkTime)
                    
                    self.settingTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: false, for: .alertSettingStartingWorkTime)
                    
                    self.settingTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                }
            }
            
            if sender.indexPath.row == 2 {
                if sender.isOn {
                    SupportingMethods.shared.setAppSetting(with: true, for: .alertFinishingWorkTime)
                    
                    self.settingTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: false, for: .alertFinishingWorkTime)
                    
                    self.settingTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            }
        }
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingHeaderView") as! SettingHeaderView
        headerView.setHeaderView(categoryText: self.settingArray[section].header)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingArray[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2) {
            let settingSubCell = tableView.dequeueReusableCell(withIdentifier: "SettingSubCell", for: indexPath) as! SettingSubCell
            if case .switch(let onOff) = self.settingArray[indexPath.section].items[indexPath.row].style {
                settingSubCell.setCell(self.settingArray[indexPath.section].items[indexPath.row].style,
                                       itemText: self.settingArray[indexPath.section].items[indexPath.row].text,
                                       indexPath: indexPath,
                                       isEnable: onOff)
                
                settingSubCell.switchButton.addTarget(self, action: #selector(controlPushSwitch(_:)), for: .valueChanged)
            }
            
            cell = settingSubCell
            
        } else {
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            settingCell.setCell(self.settingArray[indexPath.section].items[indexPath.row].style,
                         itemText: self.settingArray[indexPath.section].items[indexPath.row].text, indexPath: indexPath, isEnable: true) // FIXME: Need to determine boolean value.
            settingCell.switchButton.addTarget(self, action: #selector(controlPushSwitch(_:)), for: .valueChanged)
            
            cell = settingCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
