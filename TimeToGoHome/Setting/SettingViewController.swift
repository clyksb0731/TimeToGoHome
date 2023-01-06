//
//  SettingViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class SettingViewController: UIViewController {
    
    enum SettingPopUpType {
        case startingWorkTime
        case finishingWorkTime
    }
    
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
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var popUpPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var popUpPanelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "출근 시간 설정 알림"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        //datePicker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    lazy var popUpPanelButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.useRGB(red: 151, green: 151, blue: 151), for: .normal)
        button.setTitle("정각", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 27, weight: .bold)
        button.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        button.layer.borderColor = UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.tag = 1
        button.isSelected = false
        button.addTarget(self, action: #selector(firstButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.useRGB(red: 151, green: 151, blue: 151), for: .normal)
        button.setTitle("5분전", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 27, weight: .bold)
        button.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        button.layer.borderColor = UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.tag = 2
        button.isSelected = false
        button.addTarget(self, action: #selector(secondButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.useRGB(red: 151, green: 151, blue: 151), for: .normal)
        button.setTitle("10분전", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 27, weight: .bold)
        button.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        button.layer.borderColor = UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.tag = 3
        button.isSelected = false
        button.addTarget(self, action: #selector(thirdButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var fourthButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.useRGB(red: 151, green: 151, blue: 151), for: .normal)
        button.setTitle("30분전", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 27, weight: .bold)
        button.backgroundColor = .useRGB(red: 216, green: 216, blue: 216)
        button.layer.borderColor = UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 25
        button.tag = 4
        button.isSelected = false
        button.addTarget(self, action: #selector(fourthButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var declineButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(declineButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(confirmButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var settingArray: [(header: String, items:[(style: MenuSettingCellType, text: String)])] {
        [
            (header: "알림",
             items: SupportingMethods.shared.useAppSetting(for: .pushActivation) as? Bool == true ? [
                (style: .switch(true), text: "알림 설정"),
                (style: .switch(SupportingMethods.shared.useAppSetting(for: .alertSettingStartingWorkTime) as? Date != nil), text: "ㄴ 출근 시간 설정 알림"),
                (style: .switch(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as? [Int] != nil && !(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as! [Int]).isEmpty), text: "ㄴ 업무 종료 알림")
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
    
    var popUpViewType: SettingPopUpType = .startingWorkTime {
        didSet {
            switch self.popUpViewType {
            case .startingWorkTime:
                self.datePicker.isHidden = false
                self.popUpPanelButtonsView.isHidden = true
                
            case .finishingWorkTime:
                self.datePicker.isHidden = true
                self.popUpPanelButtonsView.isHidden = false
            }
        }
    }
    var alertFinishingWorkTimes: Set<Int> = []

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
            self.settingTableView,
            self.coverView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.settingMarkLabel,
            self.topViewBottomLineView
        ], to: self.topView)
        
        SupportingMethods.shared.addSubviews([
            self.popUpPanelView
        ], to: self.coverView)
        
        SupportingMethods.shared.addSubviews([
            self.popUpPanelTitleLabel,
            self.datePicker,
            self.popUpPanelButtonsView,
            self.declineButton,
            self.confirmButton
        ], to: self.popUpPanelView)
        
        SupportingMethods.shared.addSubviews([
            self.firstButton,
            self.secondButton,
            self.thirdButton,
            self.fourthButton
        ], to: self.popUpPanelButtonsView)
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
        
        // coverView
        NSLayoutConstraint.activate([
            self.coverView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.coverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.coverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.coverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // popUpPanelView
        NSLayoutConstraint.activate([
            self.popUpPanelView.centerYAnchor.constraint(equalTo: self.coverView.centerYAnchor),
            self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
            self.popUpPanelView.leadingAnchor.constraint(equalTo: self.coverView.leadingAnchor, constant: 32),
            self.popUpPanelView.trailingAnchor.constraint(equalTo: self.coverView.trailingAnchor, constant: -32)
        ])
        
        // popUpPanelTitleLabel
        NSLayoutConstraint.activate([
            self.popUpPanelTitleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
            self.popUpPanelTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            self.popUpPanelTitleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
            self.popUpPanelTitleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
        ])
        
        // datePicker
        NSLayoutConstraint.activate([
            self.datePicker.topAnchor.constraint(equalTo: self.popUpPanelTitleLabel.bottomAnchor, constant: 10),
            self.datePicker.heightAnchor.constraint(equalToConstant: 195),
            self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
            self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
        ])
        
        // popUpPanelButtonsView
        NSLayoutConstraint.activate([
            self.popUpPanelButtonsView.topAnchor.constraint(equalTo: self.popUpPanelTitleLabel.bottomAnchor, constant: 40),
            self.popUpPanelButtonsView.bottomAnchor.constraint(equalTo: self.declineButton.topAnchor, constant: -40),
            self.popUpPanelButtonsView.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 28),
            self.popUpPanelButtonsView.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -28)
        ])
        
        // firstButton
        NSLayoutConstraint.activate([
            self.firstButton.topAnchor.constraint(equalTo: self.popUpPanelButtonsView.topAnchor),
            self.firstButton.heightAnchor.constraint(equalToConstant: 55),
            self.firstButton.leadingAnchor.constraint(equalTo: self.popUpPanelButtonsView.leadingAnchor),
            self.firstButton.widthAnchor.constraint(equalToConstant: 115)
        ])
        
        // secondButton
        NSLayoutConstraint.activate([
            self.secondButton.topAnchor.constraint(equalTo: self.popUpPanelButtonsView.topAnchor),
            self.secondButton.heightAnchor.constraint(equalToConstant: 55),
            self.secondButton.trailingAnchor.constraint(equalTo: self.popUpPanelButtonsView.trailingAnchor),
            self.secondButton.widthAnchor.constraint(equalToConstant: 115)
        ])
        
        // thirdButton
        NSLayoutConstraint.activate([
            self.thirdButton.bottomAnchor.constraint(equalTo: self.popUpPanelButtonsView.bottomAnchor),
            self.thirdButton.heightAnchor.constraint(equalToConstant: 55),
            self.thirdButton.leadingAnchor.constraint(equalTo: self.popUpPanelButtonsView.leadingAnchor),
            self.thirdButton.widthAnchor.constraint(equalToConstant: 115)
        ])
        
        // fourthButton
        NSLayoutConstraint.activate([
            self.fourthButton.bottomAnchor.constraint(equalTo: self.popUpPanelButtonsView.bottomAnchor),
            self.fourthButton.heightAnchor.constraint(equalToConstant: 55),
            self.fourthButton.trailingAnchor.constraint(equalTo: self.popUpPanelButtonsView.trailingAnchor),
            self.fourthButton.widthAnchor.constraint(equalToConstant: 115)
        ])
        
        // declineButton
        NSLayoutConstraint.activate([
            self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
            self.declineButton.heightAnchor.constraint(equalToConstant: 35),
            self.declineButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
            self.declineButton.widthAnchor.constraint(equalToConstant: 97)
        ])
        
        // confirmButton
        NSLayoutConstraint.activate([
            self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
            self.confirmButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
            self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingViewController {
    func determineFinishingWorkTimes() {
        if self.firstButton.isSelected {
            self.alertFinishingWorkTimes.insert(1)
            
        } else {
            self.alertFinishingWorkTimes.remove(1)
        }
        
        if self.secondButton.isSelected {
            self.alertFinishingWorkTimes.insert(2)
            
        } else {
            self.alertFinishingWorkTimes.remove(2)
        }
        
        if self.thirdButton.isSelected {
            self.alertFinishingWorkTimes.insert(3)
            
        } else {
            self.alertFinishingWorkTimes.remove(3)
        }
        
        if self.fourthButton.isSelected {
            self.alertFinishingWorkTimes.insert(4)
            
        } else {
            self.alertFinishingWorkTimes.remove(4)
        }
    }
    
    func determineFinishingButtonsState() {
        // firstButton
        self.firstButton.backgroundColor = self.alertFinishingWorkTimes.contains(1) ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        self.firstButton.layer.borderColor = self.alertFinishingWorkTimes.contains(1) ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        self.firstButton.setTitleColor(self.alertFinishingWorkTimes.contains(1) ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
        self.firstButton.isSelected = self.alertFinishingWorkTimes.contains(1)
        
        // secondButton
        self.secondButton.backgroundColor = self.alertFinishingWorkTimes.contains(2) ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        self.secondButton.layer.borderColor = self.alertFinishingWorkTimes.contains(2) ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        self.secondButton.setTitleColor(self.alertFinishingWorkTimes.contains(2) ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
        self.secondButton.isSelected = self.alertFinishingWorkTimes.contains(2)
        
        // thirdButton
        self.thirdButton.backgroundColor = self.alertFinishingWorkTimes.contains(3) ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        self.thirdButton.layer.borderColor = self.alertFinishingWorkTimes.contains(3) ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        self.thirdButton.setTitleColor(self.alertFinishingWorkTimes.contains(3) ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
        self.thirdButton.isSelected = self.alertFinishingWorkTimes.contains(3)
        
        // fourthButton
        self.fourthButton.backgroundColor = self.alertFinishingWorkTimes.contains(4) ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        self.fourthButton.layer.borderColor = self.alertFinishingWorkTimes.contains(4) ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        self.fourthButton.setTitleColor(self.alertFinishingWorkTimes.contains(4) ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
        self.fourthButton.isSelected = self.alertFinishingWorkTimes.contains(4)
    }
}

// MARK: - Extension for selector methods
extension SettingViewController {
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func controlPushSwitch(_ sender: YSBlueSwitch) {
        print("section:\(sender.indexPath.section ), row:\(sender.indexPath.row) switch is \(sender.isOn ? "On" : "Off")")
        if sender.indexPath.section == 0 {
            if sender.indexPath.row == 0 {
                if sender.isOn {
                    SupportingMethods.shared.setAppSetting(with: true, for: .pushActivation)
                    
                    self.settingTableView.reloadSections([0], with: .automatic)
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: false, for: .pushActivation)
                    SupportingMethods.shared.setAppSetting(with: nil, for: .alertSettingStartingWorkTime)
                    SupportingMethods.shared.setAppSetting(with: nil, for: .alertFinishingWorkTime)
                    self.alertFinishingWorkTimes = []
                    
                    self.settingTableView.reloadSections([0], with: .automatic)
                }
            }
            
            if sender.indexPath.row == 1 {
                if sender.isOn {
                    self.datePicker.setDate(Date(), animated: false)
                    self.popUpViewType = .startingWorkTime
                    self.coverView.isHidden = false
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .alertSettingStartingWorkTime)
                    let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! SettingSubCell
                    settingSubCell.itemTextLabel.alpha = 0.5
                }
            }
            
            if sender.indexPath.row == 2 {
                if sender.isOn {
                    self.determineFinishingButtonsState()
                    self.popUpViewType = .finishingWorkTime
                    self.coverView.isHidden = false
                    
                } else {
                    SupportingMethods.shared.setAppSetting(with: nil, for: .alertFinishingWorkTime)
                    self.alertFinishingWorkTimes = []
                    let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! SettingSubCell
                    settingSubCell.itemTextLabel.alpha = 0.5
                }
            }
        }
    }
    
    @objc func datePicker(_ datePicker: UIDatePicker) {
        
    }
    
    @objc func firstButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        sender.layer.borderColor = sender.isSelected ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        sender.setTitleColor(sender.isSelected ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
    }
    
    @objc func secondButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        sender.layer.borderColor = sender.isSelected ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        sender.setTitleColor(sender.isSelected ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
    }
    
    @objc func thirdButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        sender.layer.borderColor = sender.isSelected ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        sender.setTitleColor(sender.isSelected ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
    }
    
    @objc func fourthButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.backgroundColor = sender.isSelected ?
            .useRGB(red: 145, green: 218, blue: 255) : .useRGB(red: 216, green: 216, blue: 216)
        sender.layer.borderColor = sender.isSelected ?
        UIColor.useRGB(red: 25, green: 178, blue: 255).cgColor :
        UIColor.useRGB(red: 151, green: 151, blue: 151).cgColor
        sender.setTitleColor(sender.isSelected ?
            .white : .useRGB(red: 151, green: 151, blue: 151), for: .normal)
    }
    
    @objc func declineButton(_ sender: UIButton) {
        switch self.popUpViewType {
        case .startingWorkTime:
            if let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingSubCell {
                settingSubCell.switchButton.isOn = SupportingMethods.shared.useAppSetting(for: .alertSettingStartingWorkTime) as? Date != nil
            }
            
        case .finishingWorkTime:
            if let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SettingSubCell {
                settingSubCell.switchButton.isOn = SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as? [Int] != nil &&
                !(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as! [Int]).isEmpty
            }
        }
        
        self.coverView.isHidden = true
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        switch self.popUpViewType {
        case .startingWorkTime:
            SupportingMethods.shared.setAppSetting(with: self.datePicker.date, for: .alertSettingStartingWorkTime)
            
            if let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingSubCell {
                let isEnable = SupportingMethods.shared.useAppSetting(for: .alertSettingStartingWorkTime) as? Date != nil
                settingSubCell.switchButton.isOn = isEnable
                settingSubCell.itemTextLabel.alpha = isEnable ? 1.0 : 0.5
            }
            
        case .finishingWorkTime:
            self.determineFinishingWorkTimes()
            SupportingMethods.shared.setAppSetting(with: Array(self.alertFinishingWorkTimes), for: .alertFinishingWorkTime)
            
            if let settingSubCell = self.settingTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SettingSubCell {
                let isEnable = SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as? [Int] != nil &&
                !(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as! [Int]).isEmpty
                settingSubCell.switchButton.isOn = isEnable
                settingSubCell.itemTextLabel.alpha = isEnable ? 1.0 : 0.5
            }
        }
        
        self.coverView.isHidden = true
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
                settingCell.setCell(self.settingArray[indexPath.section].items[indexPath.row].style,
                             itemText: self.settingArray[indexPath.section].items[indexPath.row].text, indexPath: indexPath, isEnable: true)
                settingCell.selectionStyle = .none
                settingCell.switchButton.addTarget(self, action: #selector(controlPushSwitch(_:)), for: .valueChanged)
                
                cell = settingCell
                
            } else {
                let settingSubCell = tableView.dequeueReusableCell(withIdentifier: "SettingSubCell", for: indexPath) as! SettingSubCell
                if case .switch(let onOff) = self.settingArray[indexPath.section].items[indexPath.row].style {
                    settingSubCell.setCell(self.settingArray[indexPath.section].items[indexPath.row].style,
                                           itemText: self.settingArray[indexPath.section].items[indexPath.row].text,
                                           indexPath: indexPath,
                                           isEnable: onOff)
                    
                    settingSubCell.switchButton.addTarget(self, action: #selector(controlPushSwitch(_:)), for: .valueChanged)
                }
                
                cell = settingSubCell
            }
            
        } else {
            let settingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            settingCell.setCell(self.settingArray[indexPath.section].items[indexPath.row].style,
                         itemText: self.settingArray[indexPath.section].items[indexPath.row].text, indexPath: indexPath, isEnable: true)
            
            cell = settingCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            if case .switch(let onOff) = self.settingArray[indexPath.section].items[indexPath.row].style, !onOff {
                return
            }
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            self.datePicker.setDate(SupportingMethods.shared.useAppSetting(for: .alertSettingStartingWorkTime) as! Date, animated: false)
            self.popUpViewType = .startingWorkTime
            
            self.coverView.isHidden = false
            
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            self.alertFinishingWorkTimes = Set(SupportingMethods.shared.useAppSetting(for: .alertFinishingWorkTime) as! [Int])
            self.determineFinishingButtonsState()
            self.popUpViewType = .finishingWorkTime
            
            self.coverView.isHidden = false
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
        }
        
        if indexPath.section == 2 && indexPath.row == 0 {
            
        }
        
        if indexPath.section == 2 && indexPath.row == 1 {
            
        }
    }
}
