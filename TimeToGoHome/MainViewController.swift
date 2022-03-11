//
//  MainViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class MainViewController: UIViewController {
    lazy var mainTimeView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var remainingTimeButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.title = "남은 시간"
        buttonView.isSelected = true
        buttonView.addTarget(self, action: #selector(remainingTimeButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var progressTimeButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.title = "진행 시간"
        buttonView.isSelected = false
        buttonView.addTarget(self, action: #selector(progressTimeButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var progressRateButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.title = "진행률"
        buttonView.isSelected = false
        buttonView.addTarget(self, action: #selector(progressRateButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var mainTimeViewValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "88:88:88"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var changeScheduleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("추가 | 제거", for: .normal)
        button.addTarget(self, action: #selector(changeScheduleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var startWorkTimeMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 172, green: 172, blue: 172)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startWorkTimeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("출근전", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.minimumScaleFactor = 0.5
        button.addTarget(self, action: #selector(startWorkTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var mainTimeCoverView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false;
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 16
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    lazy var cancelChangingScheduleButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.font = .systemFont(ofSize: 17)
        buttonView.title = "취소"
        buttonView.isEnadble = true
        buttonView.addTarget(self, action: #selector(cancelChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var completeChangingScheduleButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.font = .systemFont(ofSize: 17)
        buttonView.title = "완료"
        buttonView.isEnadble = false
        buttonView.addTarget(self, action: #selector(completeChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(ScheduleTypeCell.self, forCellReuseIdentifier: "ScheduleTypeCell")
        tableView.register(SchedulingCell.self, forCellReuseIdentifier: "SchedulingCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var changeScheduleDescription: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 220, green: 220, blue: 220)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "길게 눌러서 일정 수정"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var schedule: WorkSchedule = WorkSchedule.today
    var isEditingMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setViewFoundation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    deinit {
            print("----------------------------------- MainViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for override methods
extension MainViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Extension for essential methods
extension MainViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        
        self.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        self.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationItem.compactAppearance = navigationBarAppearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Work Schedule"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuBarButton"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingBarButton"), style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.mainTimeView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.remainingTimeButtonView,
            self.progressTimeButtonView,
            self.progressRateButtonView,
            self.mainTimeViewValueLabel,
            self.changeScheduleButton,
            self.startWorkTimeMarkLabel,
            self.startWorkTimeButton,
            self.mainTimeCoverView
        ], to: self.mainTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.cancelChangingScheduleButtonView,
            self.completeChangingScheduleButtonView
        ], to: self.mainTimeCoverView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Main time view layout
        NSLayoutConstraint.activate([
            self.mainTimeView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mainTimeView.heightAnchor.constraint(equalToConstant: 180),
            self.mainTimeView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            self.mainTimeView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
        
        // Left time button view layout
        NSLayoutConstraint.activate([
            self.remainingTimeButtonView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 18),
            self.remainingTimeButtonView.heightAnchor.constraint(equalToConstant: 28),
            self.remainingTimeButtonView.trailingAnchor.constraint(equalTo: self.progressTimeButtonView.leadingAnchor, constant: -5),
            self.remainingTimeButtonView.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Progress time button view layout
        NSLayoutConstraint.activate([
            self.progressTimeButtonView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 18),
            self.progressTimeButtonView.heightAnchor.constraint(equalToConstant: 28),
            self.progressTimeButtonView.trailingAnchor.constraint(equalTo: self.progressRateButtonView.leadingAnchor, constant: -5),
            self.progressTimeButtonView.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Progress rate button view layout
        NSLayoutConstraint.activate([
            self.progressRateButtonView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 18),
            self.progressRateButtonView.heightAnchor.constraint(equalToConstant: 28),
            self.progressRateButtonView.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor, constant: -31),
            self.progressRateButtonView.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Main time view value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewValueLabel.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 77),
            self.mainTimeViewValueLabel.heightAnchor.constraint(equalToConstant: 52),
            self.mainTimeViewValueLabel.centerXAnchor.constraint(equalTo: self.mainTimeView.centerXAnchor),
            self.mainTimeViewValueLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // Change schedule button layout
        NSLayoutConstraint.activate([
            self.changeScheduleButton.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.changeScheduleButton.heightAnchor.constraint(equalToConstant: 15),
            self.changeScheduleButton.leadingAnchor.constraint(equalTo: self.mainTimeView.leadingAnchor, constant: 31),
            self.changeScheduleButton.widthAnchor.constraint(equalToConstant: 55)
        ])
        
        // Start work time mark label layout
        NSLayoutConstraint.activate([
            self.startWorkTimeMarkLabel.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.startWorkTimeMarkLabel.heightAnchor.constraint(equalToConstant: 15),
            self.startWorkTimeMarkLabel.trailingAnchor.constraint(equalTo: self.startWorkTimeButton.leadingAnchor, constant: -8),
            self.startWorkTimeMarkLabel.widthAnchor.constraint(equalToConstant: 46)
        ])
        
        // Start work time label layout
        NSLayoutConstraint.activate([
            self.startWorkTimeButton.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.startWorkTimeButton.heightAnchor.constraint(equalToConstant: 15),
            self.startWorkTimeButton.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor, constant: -31),
            self.startWorkTimeButton.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Main time cover view layout
        NSLayoutConstraint.activate([
            self.mainTimeCoverView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor),
            self.mainTimeCoverView.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor),
            self.mainTimeCoverView.leadingAnchor.constraint(equalTo: self.mainTimeView.leadingAnchor),
            self.mainTimeCoverView.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor)
        ])
        
        // Cancel changing schedule button view layout
        NSLayoutConstraint.activate([
            self.cancelChangingScheduleButtonView.centerYAnchor.constraint(equalTo: self.mainTimeCoverView.centerYAnchor),
            self.cancelChangingScheduleButtonView.heightAnchor.constraint(equalToConstant: 25),
            self.cancelChangingScheduleButtonView.trailingAnchor.constraint(equalTo: self.mainTimeCoverView.centerXAnchor, constant: -15),
            self.cancelChangingScheduleButtonView.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // Complete changing schedule button view layout
        NSLayoutConstraint.activate([
            self.completeChangingScheduleButtonView.centerYAnchor.constraint(equalTo: self.mainTimeCoverView.centerYAnchor),
            self.completeChangingScheduleButtonView.heightAnchor.constraint(equalToConstant: 25),
            self.completeChangingScheduleButtonView.leadingAnchor.constraint(equalTo: self.mainTimeCoverView.centerXAnchor, constant: 15),
            self.completeChangingScheduleButtonView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
}

// MARK: - Extension for methods added
extension MainViewController {
    
}

// MARK: - Extension for Selector methods
extension MainViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        // left bar button
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        // right bar button
    }
    
    @objc func remainingTimeButtonView(_ sender: UIButton) {
        self.remainingTimeButtonView.isSelected = true
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewValueLabel.text = "88:88:88"
    }
    
    @objc func progressTimeButtonView(_ sender: UIButton) {
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = true
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewValueLabel.text = "88:88:88"
    }
    
    @objc func progressRateButtonView(_ sender: UIButton) {
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = true
        
        self.mainTimeViewValueLabel.text = "88%"
    }
    
    @objc func startWorkTimeButton(_ sender: UIButton) {
        
    }
    
    @objc func changeScheduleButton(_ sender: UIButton) {
        self.mainTimeCoverView.isHidden = false
        
        self.isEditingMode = true
    }
    
    @objc func cancelChangingScheduleButtonView(_ sender: UIButton) {
        self.mainTimeCoverView.isHidden = true
        
        self.isEditingMode = false
    }
    
    @objc func completeChangingScheduleButtonView(_ sender: UIButton) {
        self.mainTimeCoverView.isHidden = true
        
        self.isEditingMode = false
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.schedule.count > 0 {
            if self.isEditingMode {
                return self.schedule.count + 1
                
            } else {
                return self.schedule.count
            }
            
        } else {
            if self.isEditingMode {
                return 1
                
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if self.isEditingMode {
            if indexPath.row == 0 {
                if self.schedule.count > 0 {
                    let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    scheduleTypeCell.setCell(scheduleType: self.schedule.morning!, isEditingMode: true)
                    
                    cell = scheduleTypeCell
                    
                } else {
                    let schedulingCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    schedulingCell.setCell(scheduleTypeText: "오전 일정")
                    
                    cell = schedulingCell
                }
            }
            
            if indexPath.row == 1 {
                if self.schedule.count > 1 {
                    let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    scheduleTypeCell.setCell(scheduleType: self.schedule.afternoon!, isEditingMode: true)
                    
                    cell = scheduleTypeCell
                    
                } else {
                    let schedulingCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    schedulingCell.setCell(scheduleTypeText: "오후 일정")
                    
                    cell = schedulingCell
                }
            }
            
            if indexPath.row == 2 {
                if self.schedule.count > 2 {
                    let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    scheduleTypeCell.setCell(scheduleType: self.schedule.overtime!, isEditingMode: true)
                    
                    cell = scheduleTypeCell
                    
                } else {
                    let schedulingCell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    schedulingCell.setCell(scheduleTypeText: "추가 일정")
                    
                    cell = schedulingCell
                }
            }
            
        } else {
            if indexPath.row == 0 {
                let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                scheduleTypeCell.setCell(scheduleType: self.schedule.morning!, isEditingMode: false)
                
                cell = scheduleTypeCell
            }
            
            if indexPath.row == 1 {
                let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                scheduleTypeCell.setCell(scheduleType: self.schedule.afternoon!, isEditingMode: false)
                
                cell = scheduleTypeCell
            }
            
            if indexPath.row == 2 {
                let scheduleTypeCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                scheduleTypeCell.setCell(scheduleType: self.schedule.overtime!, isEditingMode: false)
                
                cell = scheduleTypeCell
            }
        }
        
        return cell
    }
    
    
}
