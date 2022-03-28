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
    
    lazy var editScheduleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.useRGB(red: 172, green: 172, blue: 172), for: .disabled)
        button.setTitle("추가 | 제거", for: .normal)
        button.addTarget(self, action: #selector(editScheduleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var startWorkingTimeMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 172, green: 172, blue: 172)
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startWorkingTimeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.useRGB(red: 172, green: 172, blue: 172), for: .disabled)
        button.setTitle("출근전", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.minimumScaleFactor = 0.5
        button.addTarget(self, action: #selector(startWorkingTimeButton(_:)), for: .touchUpInside)
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
        buttonView.isEnabled = true
        buttonView.addTarget(self, action: #selector(cancelChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var completeChangingScheduleButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.font = .systemFont(ofSize: 17)
        buttonView.title = "완료"
        buttonView.isEnabled = false
        buttonView.addTarget(self, action: #selector(completeChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(ScheduleTypeCell.self, forCellReuseIdentifier: "ScheduleTypeCell")
        tableView.register(SchedulingCell.self, forCellReuseIdentifier: "SchedulingCell")
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var changeScheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 220, green: 220, blue: 220)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.text = "길게 눌러서 일정 수정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var scheduleButtonView: ScheduleButtonView = {
        let buttonView = ScheduleButtonView(width: UIScreen.main.bounds.width, schedule: self.schedule)
        buttonView.delegate = self
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    weak var timer: Timer!
    
    let workScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.27
    let overWorkScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.17
    let changeScheduleDescriptionLabelHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.024
    
    var scheduleTableViewHeightAnchor: NSLayoutConstraint!
    
    var schedule: WorkSchedule = WorkSchedule.today
    var tempSchedule: WorkSchedule?
    var isFinishedScheduleToday: Bool = false
    
    var isEditingMode: Bool = false {
        willSet {
            
        }
        
        didSet {
            if self.isEditingMode != oldValue {
                self.schedule.isEditingMode = self.isEditingMode
                
                self.determineCompleteChangingScheduleButton(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
                self.determineStartingWorkTimeButton(for: self.schedule)
                
                self.changeScheduleDescriptionLabel.isHidden = self.isEditingMode
            }
        }
    }
    
    var previousPointX: CGFloat = 0
    var isHaptic: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: Temp
        self.makeTempAppSetting()

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
        self.determineWhetherPossibleToEditSchedule(self.schedule)
        self.determineWhetherPossibleToEditStartingWorkTime(for: self.schedule)
        self.determineScheduleButtonState(for: self.schedule)
        self.determineStartingWorkTimeButton(for: self.schedule)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.determineToday()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit {
            print("----------------------------------- MainViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension MainViewController {
    // Set view foundation
    func setViewFoundation() {
        // Backgroud color
        self.view.backgroundColor = .white
        
        // Navigation bar appearance
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuBarButton"), style: .plain, target: self, action: #selector(menuBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingBarButton"), style: .plain, target: self, action: #selector(settingBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        // Table view height
        self.calculateTableViewHeight(for: self.schedule)
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
            self.mainTimeView,
            self.scheduleTableView,
            self.changeScheduleDescriptionLabel,
            self.scheduleButtonView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.remainingTimeButtonView,
            self.progressTimeButtonView,
            self.progressRateButtonView,
            self.mainTimeViewValueLabel,
            self.editScheduleButton,
            self.startWorkingTimeMarkLabel,
            self.startWorkingTimeButton,
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
            self.editScheduleButton.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.editScheduleButton.heightAnchor.constraint(equalToConstant: 15),
            self.editScheduleButton.leadingAnchor.constraint(equalTo: self.mainTimeView.leadingAnchor, constant: 31),
            self.editScheduleButton.widthAnchor.constraint(equalToConstant: 55)
        ])
        
        // Start work time mark label layout
        NSLayoutConstraint.activate([
            self.startWorkingTimeMarkLabel.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.startWorkingTimeMarkLabel.heightAnchor.constraint(equalToConstant: 15),
            self.startWorkingTimeMarkLabel.trailingAnchor.constraint(equalTo: self.startWorkingTimeButton.leadingAnchor, constant: -8),
            self.startWorkingTimeMarkLabel.widthAnchor.constraint(equalToConstant: 46)
        ])
        
        // Start work time label layout
        NSLayoutConstraint.activate([
            self.startWorkingTimeButton.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.startWorkingTimeButton.heightAnchor.constraint(equalToConstant: 15),
            self.startWorkingTimeButton.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor, constant: -31),
            self.startWorkingTimeButton.widthAnchor.constraint(equalToConstant: 34)
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
        
        // Schedule table view layout
        self.scheduleTableViewHeightAnchor = self.scheduleTableView.heightAnchor.constraint(equalToConstant: 2 * self.workScheduleViewHeight + self.overWorkScheduleViewHeight)
        NSLayoutConstraint.activate([
            self.scheduleTableView.topAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: 10),
            self.scheduleTableViewHeightAnchor,
            self.scheduleTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scheduleTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Change schedule description label layout
        NSLayoutConstraint.activate([
            self.changeScheduleDescriptionLabel.topAnchor.constraint(equalTo: self.scheduleTableView.bottomAnchor, constant: self.changeScheduleDescriptionLabelHeight),
            self.changeScheduleDescriptionLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Schedule button view layout
        NSLayoutConstraint.activate([
            self.scheduleButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scheduleButtonView.heightAnchor.constraint(equalToConstant: 101),
            self.scheduleButtonView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scheduleButtonView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MainViewController {
    func determineToday() {
        if self.schedule.startingWorkTime == nil {
            let mainCoverVC = MainCoverViewController(.startingWorkTime(nil), delegate: self)
            self.present(mainCoverVC, animated: false)
            
        } else {
            if self.timer == nil {
                let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
                self.timer = timer
            }
        }
    }
    
    func calculateTableViewHeight(for schedule: WorkSchedule) {
        if schedule.count == 0 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight
        }
        
        if schedule.count == 1 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
        }
        
        if schedule.count == 2 {
            if self.isEditingMode {
                if case .afternoon(let workType) = schedule.afternoon {
                    switch workType {
                    case .holiday:
                        self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
                        
                    case .vacation:
                        self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
                        
                    case .work:
                        self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2 + self.overWorkScheduleViewHeight
                    }
                }
                
            } else {
                self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
            }
        }
        
        if schedule.count == 3 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2 + self.overWorkScheduleViewHeight
        }
    }
    
    func determineScheduleButtonState(for schedule: WorkSchedule) {
        if self.isEditingMode {
            if schedule.count > 2 { // 3
                self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                
            } else if schedule.count == 2 {
                if case .afternoon(let workType) = schedule.afternoon, case .work = workType {
                    self.scheduleButtonView.setScheduleButtonViewType(.addOvertime)
                    
                } else {
                    self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                }
                
            } else if schedule.count == 1 {
                if case .morning(let workType) = schedule.morning {
                    switch workType {
                    case .work:
                        self.scheduleButtonView.setScheduleButtonViewType(.threeSchedules(nil))
                        
                    case .vacation:
                        self.scheduleButtonView.setScheduleButtonViewType(.twoScheduleForVacation(nil))
                        
                    case .holiday:
                        self.scheduleButtonView.setScheduleButtonViewType(.twoScheduleForHoliday(nil))
                    }
                }
                
            } else { // 0
                self.scheduleButtonView.setScheduleButtonViewType(.threeSchedules(nil))
            }
            
        } else {
            if self.isFinishedScheduleToday {
                self.scheduleButtonView.setScheduleButtonViewType(.workFinished)
                
            } else {
                if schedule.count > 2 { // 3
                    if case .overtime(let overtime) = schedule.overtime {
                        if let regularWorkSeconds = self.schedule.whenIsRegularWorkFinish() {
                            if SupportingMethods.getCurrentTimeSeconds() <= regularWorkSeconds {
                                self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                                
                            } else if SupportingMethods.getCurrentTimeSeconds() > regularWorkSeconds &&
                                        SupportingMethods.getCurrentTimeSeconds() <= Int(overtime.timeIntervalSinceReferenceDate) { // in overtime
                                self.scheduleButtonView.setScheduleButtonViewType(.finishWorkWithOvertime(nil))
                                
                            } else { // after overtime
                                self.scheduleButtonView.setScheduleButtonViewType(.replaceOvertimeOrFinishWork(nil))
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                        }
                    }
                    
                } else { // 2
                    if case .morning(let workType) = schedule.morning, case .work = workType,
                       case .afternoon(let workType) = schedule.afternoon, case .work = workType {
                        if let regularWorkSeconds = self.schedule.whenIsRegularWorkFinish() {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonViewType(.addOvertime)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonViewType(.addOvertimeOrFinishWork(nil))
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonViewType(.addOvertime)
                        }
                        
                    } else if case .morning(let workType) = schedule.morning, case .work = workType {
                        if let regularWorkSeconds = self.schedule.whenIsRegularWorkFinish() {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonViewType(.finishWork)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                        }
                        
                    } else if case .afternoon(let workType) = schedule.afternoon, case .work = workType {
                        if let regularWorkSeconds = self.schedule.whenIsRegularWorkFinish() {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonViewType(.addOvertime)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonViewType(.addOvertimeOrFinishWork(nil))
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonViewType(.addOvertime)
                        }
                        
                    } else {
                        self.scheduleButtonView.setScheduleButtonViewType(.noButton)
                    }
                }
            }
        }
    }
    
    func determineWhetherPossibleToEditSchedule(_ schedule: WorkSchedule) {
        if schedule.startingWorkTime == nil {
            self.editScheduleButton.isEnabled = false
            
        } else {
            self.editScheduleButton.isEnabled = true
        }
    }
    
    func determineWhetherPossibleToEditStartingWorkTime(for schedule: WorkSchedule) {
        switch schedule.workType {
        case .staggered:
            self.startWorkingTimeButton.isEnabled = true
            
        case .normal:
            self.startWorkingTimeButton.isEnabled = false
        }
    }
    
    func determineCompleteChangingScheduleButton(for schedule: WorkSchedule) {
        if schedule.count < 2 {
            self.completeChangingScheduleButtonView.isEnabled = false
            
        } else {
            self.completeChangingScheduleButtonView.isEnabled = true
        }
    }
    
    func determineStartingWorkTimeButton(for schedule: WorkSchedule) {
        if let startingWorkingTime = self.schedule.startingWorkTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            dateFormatter.timeZone = .current
            dateFormatter.locale = Locale(identifier: "ko_KR")
            
            self.startWorkingTimeButton.setTitle(dateFormatter.string(from: startingWorkingTime), for: .normal)
        }
        
        self.startWorkingTimeMarkLabel.isHidden = !schedule.isAvailableToWork
        self.startWorkingTimeButton.isHidden = !schedule.isAvailableToWork
    }
}

// MARK: - Extension for Selector methods
extension MainViewController {
    @objc func menuBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func settingBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func timer(_ timer: Timer) {
        print("Timer at main vc")
    }
    
    @objc func remainingTimeButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = true
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewValueLabel.text = "88:88:88"
    }
    
    @objc func progressTimeButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = true
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewValueLabel.text = "88:88:88"
    }
    
    @objc func progressRateButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = true
        
        self.mainTimeViewValueLabel.text = "88%"
    }
    
    @objc func startWorkingTimeButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        let mainCoverVC = MainCoverViewController(.startingWorkTime(self.schedule.startingWorkTime), delegate: self)
        self.present(mainCoverVC, animated: false)
    }
    
    @objc func editScheduleButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.tempSchedule = self.schedule
        
        self.isEditingMode = true
        self.mainTimeCoverView.isHidden = false
    }
    
    @objc func cancelChangingScheduleButtonView(_ sender: UIButton) {
        if let schedule = self.tempSchedule {
            self.schedule = schedule
        }
        
        self.mainTimeCoverView.isHidden = true
        self.isEditingMode = false
    }
    
    @objc func completeChangingScheduleButtonView(_ sender: UIButton) {
        self.schedule.updateToday()
        
        self.isEditingMode = false
        self.mainTimeCoverView.isHidden = true
    }
    
    @objc func removeScheduleButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.schedule.removeSchedule(sender.tag)
        
        self.determineCompleteChangingScheduleButton(for: self.schedule)
        
        self.calculateTableViewHeight(for: self.schedule)
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
        self.determineStartingWorkTimeButton(for: self.schedule)
    }
    
    @objc func scheduleCellLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if let scheduleCell = gesture.view {
            if gesture.state == .began {
                UIDevice.heavyHaptic()
                
                if scheduleCell.tag == 1 {
                    print("Long Pressed for morning")
                    let mainCoverVC = MainCoverViewController(.normalSchedule(self.schedule.morning), delegate: self)
                    self.present(mainCoverVC, animated: false)
                    
                } else if scheduleCell.tag == 2 {
                    print("Long Pressed for afternoon")
                    if self.schedule.overtime == nil {
                        let mainCoverVC = MainCoverViewController(.normalSchedule(self.schedule.afternoon), delegate: self)
                        self.present(mainCoverVC, animated: false, completion: nil)
                        
                    } else {
                        let alertVC = UIAlertController(title: "변경 불가", message: "추가 근무가 있어서 변경할 수 없습니다.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true)
                    }
                    
                } else { // tag 3, overtime
                    print("Long Pressed for overtime")
                    if case .overtime(let overtime) = self.schedule.overtime {
                        let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.whenIsRegularWorkFinish()!)), overtime: overtime, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                        self.present(mainCoverVC, animated: false)
                    }
                }
            }
        }
    }
    
//    @objc func pageControl(_ sender: UIPageControl) {
//        self.previousPointX = buttonsScrollView.contentOffset.x
//
//        print("Current Page: \(sender.currentPage)")
//
//        if sender.currentPage == 0 {
//            self.buttonsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
//        }
//
//        if sender.currentPage == 1 {
//            self.buttonsScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: false)
//        }
//
//        if sender.currentPage == 2 {
//            self.buttonsScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0), animated: false)
//        }
//    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.schedule.count == 1 {
            return 2 // because only editing mode possible
            
        } else if self.schedule.count == 2 {
            if self.isEditingMode {
                if case .afternoon(let workType) = self.schedule.afternoon {
                    switch workType {
                    case .holiday:
                        return 2
                        
                    case .vacation:
                        return 2
                        
                    case .work:
                        return 3
                    }
                }
                
                return 3 // not happen
                
            } else {
                return 2
            }
            
        } else if self.schedule.count == 3 {
            return 3
            
        } else {
            return 1 // because only editing mode possible
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.workScheduleViewHeight
            
        } else if indexPath.row == 1 {
            return self.workScheduleViewHeight
            
        } else { // 2
            return self.overWorkScheduleViewHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.schedule.count == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: true, tag:1)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                
                if let gestures = cell.gestureRecognizers {
                    for gesture in gestures {
                        cell.removeGestureRecognizer(gesture)
                    }
                }
                if !self.isEditingMode {
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                }
                
                return cell
                
            } else { // row 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                cell.setCell(scheduleTypeText: "오후 일정", width: UIScreen.main.bounds.width - 10, height: self.workScheduleViewHeight)
                
                return cell
            }
            
        } else if self.schedule.count == 2 {
            if self.isEditingMode {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 1)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    if let gestures = cell.gestureRecognizers {
                        for gesture in gestures {
                            cell.removeGestureRecognizer(gesture)
                        }
                    }
                    
                    return cell
                    
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: true, tag: 2)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    if let gestures = cell.gestureRecognizers {
                        for gesture in gestures {
                            cell.removeGestureRecognizer(gesture)
                        }
                    }
                    
                    return cell
                    
                } else { // row 2
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    cell.setCell(scheduleTypeText: "추가 일정", width: UIScreen.main.bounds.width - 10, height: self.overWorkScheduleViewHeight)
                    
                    return cell
                }
                
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 1)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    if let gestures = cell.gestureRecognizers {
                        for gesture in gestures {
                            cell.removeGestureRecognizer(gesture)
                        }
                    }
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                    
                    return cell
                    
                } else { // row 1
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    if let gestures = cell.gestureRecognizers {
                        for gesture in gestures {
                            cell.removeGestureRecognizer(gesture)
                        }
                    }
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                    
                    return cell
                }
            }
            
        } else if self.schedule.count == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 1)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                
                if let gestures = cell.gestureRecognizers {
                    for gesture in gestures {
                        cell.removeGestureRecognizer(gesture)
                    }
                }
                if !self.isEditingMode {
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                }
                
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                
                if let gestures = cell.gestureRecognizers {
                    for gesture in gestures {
                        cell.removeGestureRecognizer(gesture)
                    }
                }
                if !self.isEditingMode {
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                }
                
                return cell
                
            } else { // row 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: self.isEditingMode, tag: 3)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                
                if let gestures = cell.gestureRecognizers {
                    for gesture in gestures {
                        cell.removeGestureRecognizer(gesture)
                    }
                }
                if !self.isEditingMode {
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                }
                
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
            cell.setCell(scheduleTypeText: "오전 일정", width: UIScreen.main.bounds.width - 10, height: self.workScheduleViewHeight)
            
            return cell
        }
    }
}

// MARK: - Extension for ScheduleButtonViewDelegate
extension MainViewController: ScheduleButtonViewDelegate {
    func scheduleButtonView(_ scheduleButtonView: ScheduleButtonView, of type: ScheduleButtonViewType) {
        switch type {
        case .threeSchedules(let workType):
            if let workType = workType {
                switch workType {
                case .work:
                    print("threeSchedules work")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.work))
                    
                case .vacation:
                    print("threeSchedules vacation")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.vacation))
                    
                case .holiday:
                    print("threeSchedules holiday")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.holiday))
                }
                
                self.determineCompleteChangingScheduleButton(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
            }
            
        case .twoScheduleForVacation(let workType):
            if let workType = workType {
                switch workType {
                case .work:
                    print("twoScheduleForVacation work")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.work))
                    
                case .vacation:
                    print("twoScheduleForVacation vacation")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.vacation))
                }
                
                self.determineCompleteChangingScheduleButton(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
            }
            
        case .twoScheduleForHoliday(let workType):
            if let workType = workType {
                switch workType {
                case .work:
                    print("twoScheduleForHoliday work")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.work))
                    
                case .holiday:
                    print("twoScheduleForHoliday holiday")
                    self.schedule.addSchedule(self.schedule.makeNewScheduleBasedOnTodayScheduleCount(WorkTimeType.holiday))
                }
                
                self.determineCompleteChangingScheduleButton(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
            }
            
        case .addOvertime:
            print("addOvertime")
            if self.schedule.startingWorkTime == nil {
                print("Not possible to add overtime")
                
            } else {
                let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.whenIsRegularWorkFinish()!)), overtime: nil, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                
                self.present(mainCoverVC, animated: false) {
                    self.isEditingMode = true
                }
            }
            
        case .addOvertimeOrFinishWork(let overtimeOrFinish):
            if let overtimeOrFinish = overtimeOrFinish {
                switch overtimeOrFinish {
                case .overtime(let date):
                    print("addOvertimeOrFinishWork overtime")
                    let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.whenIsRegularWorkFinish()!)), overtime: date, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                    
                    self.present(mainCoverVC, animated: false) {
                        self.isEditingMode = true
                    }
                    
                case .finishWork:
                    print("addOvertimeOrFinishWork finishWork")
                }
            }
            
        case .replaceOvertimeOrFinishWork(let overtimeOrFinish):
            if let overtimeOrFinish = overtimeOrFinish {
                switch overtimeOrFinish {
                case .overtime(let date):
                    print("replaceOvertimeOrFinishWork overtime")
                    let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.whenIsRegularWorkFinish()!)), overtime: date, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                    
                    self.present(mainCoverVC, animated: false)
                    
                case .finishWork:
                    print("replaceOvertimeOrFinishWork finishWork")
                }
            }
            
        case .finishWorkWithOvertime(let date):
            if let date = date {
                print("finishWorkWithOvertime at \(date)")
            }
            
        case .finishWork:
            print("finishWork")
            
        case .workFinished, .noButton:
            print("Nothing happen")
        }
    }
}

// MARK: - Extension for MainCoverDelegate
extension MainViewController: MainCoverDelegate {
    func mainCoverDidDetermineNormalSchedule(_ scheduleType: ScheduleType) {
        self.schedule.insertSchedule(scheduleType)
        
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
        self.determineStartingWorkTimeButton(for: self.schedule)
    }
    
    func mainCoverDidDetermineOvertimeSchedule(_ scheduleType: ScheduleType, isEditingModeBeforPresenting: Bool!) {
        if self.isEditingMode {
            self.isEditingMode = isEditingModeBeforPresenting
            
            self.schedule.addSchedule(scheduleType)
            
            self.calculateTableViewHeight(for: self.schedule)
            
        } else {
            self.schedule.insertSchedule(scheduleType)
        }
        
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
        self.determineStartingWorkTimeButton(for: self.schedule)
    }
    
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date) {
        self.schedule.updateStartingWorkTime(startingWorkTime)
        
        self.determineStartingWorkTimeButton(for: self.schedule)
        
        if self.timer == nil {
            let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
            self.timer = timer
        }
    }
}

// FIXME: - Temp Extension
extension MainViewController {
    func makeTempAppSetting() {
        //SupportingMethods.shared.setAppSetting(with: ["name":"staggeredType", "earlierTime":8.0, "laterTime":11.0], for: .startingWorkTimeSetting)
        SupportingMethods.shared.setAppSetting(with: ["name":"normalType", "startingWorkTime":9.5], for: .startingWorkTimeSetting)
    }
}
