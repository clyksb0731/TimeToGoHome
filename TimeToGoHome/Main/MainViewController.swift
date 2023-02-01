//
//  MainViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class MainViewController: UIViewController {
    enum MainTimeViewButtonType {
        case remainingTime
        case progressTime
        case progressRate
    }
    
    enum RegularScheduleType {
        case fullWork
        case morningWork
        case afternoonWork
        case fullVacation
        case fullHoliday
    }
    
    lazy var topTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "menuBarButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(menuButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "오늘의 일정"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingBarButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
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
    
    lazy var mainTimeViewRemainingTimeValueView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainTimeViewRemainingHourValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewRemainingFirstSeparatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = ":"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewRemainingMinuteValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewRemainingSecondSeparatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = ":"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewRemainingSecondValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressTimeValueView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainTimeViewProgressHourValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressFirstSeparatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = ":"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressMinuteValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressSecondSeparatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = ":"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressSecondValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .center
        label.text = "00"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressRateValueView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var mainTimeViewProgressRateIntegerValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 43)
        label.textAlignment = .right
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressRatePointSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressRateFloatValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mainTimeViewProgressRatePercentSymbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = "%"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var editScheduleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.useRGB(red: 172, green: 172, blue: 172), for: .disabled)
        button.setTitle(self.schedule.dateOfFinishedSchedule == nil ? "추가 | 제거" : "업무 재개", for: .normal)
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
        button.setTitle("시간설정", for: .normal)
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
        buttonView.isSelected = true
        buttonView.isEnabled = true
        buttonView.addTarget(self, action: #selector(cancelChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var completeChangingScheduleButtonView: WhiteButtonView = {
        let buttonView = WhiteButtonView()
        buttonView.font = .systemFont(ofSize: 17)
        buttonView.title = "완료"
        buttonView.isSelected = true
        buttonView.isEnabled = false
        buttonView.addTarget(self, action: #selector(completeChangingScheduleButtonView(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var ignoreLunchBaseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var ignoreLunchDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .useRGB(red: 221, green: 221, blue: 221)
        label.text = "점심시간 무시 (오늘)"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var ignoreLunchSwitch: YSBlueSwitch = {
        let switchButton = YSBlueSwitch()
        switchButton.addTarget(self, action: #selector(ignoreLunchSwitch(_:)), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
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
        let buttonView = ScheduleButtonView(width: ReferenceValues.keyWindow.screen.bounds.width, schedule: self.schedule)
        buttonView.delegate = self
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var leavingDateCoverView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton()
        button.backgroundColor = .Buttons.initializeNewCompany
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        button.setTitle("신규 회사 설정", for: .normal)
        button.addTarget(self, action: #selector(initializeNewCompanyButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView()
        view.addSubview(blurEffectView)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            // blurEffectView
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // button
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -31),
            button.heightAnchor.constraint(equalToConstant: 70),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.isHidden = true
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date {
            let todayDateId = Int(dateFormatter.string(from: Date()))!
            let leavingDateId = Int(dateFormatter.string(from: leavingDate))!
            
            view.isHidden = todayDateId <= leavingDateId
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var numberOfAnnualPaidHolidays: Double {
        return Double(ReferenceValues.initialSetting[InitialSetting.annualPaidHolidays.rawValue] as! Int)
    }
    var numberOfVacationsHold: Double {
        return VacationModel.numberOfVacationsHold
    }
    
    weak var timer: Timer?
    
    /*
    let workScheduleViewHeight = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.27
    let overWorkScheduleViewHeight = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.17
    let changeScheduleDescriptionLabelHeight = (ReferenceValues.keyWindow.screen.bounds.height - (ReferenceValues.keyWindow.safeAreaInsets.top + 44 + 180 + 75 + 26 + ReferenceValues.keyWindow.safeAreaInsets.bottom)) * 0.024
     */
    
    var scheduleTableViewTopAnchor: NSLayoutConstraint!
    var scheduleTableViewHeightAnchor: NSLayoutConstraint!
    
    var mainTimeViewButtonType: MainTimeViewButtonType = .remainingTime
    
    var schedule: WorkScheduleModel = .today
    var tempSchedule: WorkScheduleModel?
    
    var todayRegularScheduleType: RegularScheduleType?
    
    var todayTimeValue: Int = 0
    var tomorrowTimeValue: Int = 0
    
    var isEditingMode: Bool = false {
        didSet {
            if self.isEditingMode != oldValue {
                self.schedule.isEditingMode = self.isEditingMode
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.determineTableAndButtonTypeOfSchedule()
                
                self.changeScheduleDescriptionLabel.isHidden = self.isEditingMode
                
                DispatchQueue.main.async {
                    if self.isEditingMode {
                        self.foldHalfDayMode()
                        
                    } else {
                        self.determineIfHalfDay()
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // essential
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
        
        self.determineToday()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        /*
        // Navigation item appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        
        self.navigationItem.scrollEdgeAppearance = navigationBarAppearance
        self.navigationItem.standardAppearance = navigationBarAppearance
        self.navigationItem.compactAppearance = navigationBarAppearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "오늘의 일정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuBarButton"), style: .plain, target: self, action: #selector(menuBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingBarButton"), style: .plain, target: self, action: #selector(settingBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
         */
    }
    
    // Initialize views
    func initializeViews() {
        self.activateTimer()
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
            self.topTitleView,
            self.mainTimeView,
            self.ignoreLunchBaseView,
            self.scheduleTableView,
            self.changeScheduleDescriptionLabel,
            self.scheduleButtonView,
            self.leavingDateCoverView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.menuButton,
            self.titleLabel,
            self.settingButton
        ], to: self.topTitleView)
        
        SupportingMethods.shared.addSubviews([
            self.remainingTimeButtonView,
            self.progressTimeButtonView,
            self.progressRateButtonView,
            self.mainTimeViewRemainingTimeValueView,
            self.mainTimeViewProgressTimeValueView,
            self.mainTimeViewProgressRateValueView,
            self.editScheduleButton,
            self.startWorkingTimeMarkLabel,
            self.startWorkingTimeButton,
            self.mainTimeCoverView
        ], to: self.mainTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.mainTimeViewRemainingHourValueLabel,
            self.mainTimeViewRemainingFirstSeparatorLabel,
            self.mainTimeViewRemainingMinuteValueLabel,
            self.mainTimeViewRemainingSecondSeparatorLabel,
            self.mainTimeViewRemainingSecondValueLabel
        ], to: self.mainTimeViewRemainingTimeValueView)
        
        SupportingMethods.shared.addSubviews([
            self.mainTimeViewProgressHourValueLabel,
            self.mainTimeViewProgressFirstSeparatorLabel,
            self.mainTimeViewProgressMinuteValueLabel,
            self.mainTimeViewProgressSecondSeparatorLabel,
            self.mainTimeViewProgressSecondValueLabel
        ], to: self.mainTimeViewProgressTimeValueView)
        
        SupportingMethods.shared.addSubviews([
            self.mainTimeViewProgressRateIntegerValueLabel,
            self.mainTimeViewProgressRatePointSymbolLabel,
            self.mainTimeViewProgressRateFloatValueLabel,
            self.mainTimeViewProgressRatePercentSymbolLabel
        ], to: self.mainTimeViewProgressRateValueView)
        
        SupportingMethods.shared.addSubviews([
            self.cancelChangingScheduleButtonView,
            self.completeChangingScheduleButtonView
        ], to: self.mainTimeCoverView)
        
        SupportingMethods.shared.addSubviews([
            self.ignoreLunchDescriptionLabel,
            self.ignoreLunchSwitch
        ], to: self.ignoreLunchBaseView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // topTitleView
        NSLayoutConstraint.activate([
            self.topTitleView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.topTitleView.heightAnchor.constraint(equalToConstant: 52),
            self.topTitleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.topTitleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        ])
        
        // menuButton
        NSLayoutConstraint.activate([
            self.menuButton.centerYAnchor.constraint(equalTo: self.topTitleView.centerYAnchor),
            self.menuButton.heightAnchor.constraint(equalToConstant: 44),
            self.menuButton.leadingAnchor.constraint(equalTo: self.topTitleView.leadingAnchor),
            self.menuButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.topTitleView.centerYAnchor),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.topTitleView.centerXAnchor)
        ])
        
        // settingButton
        NSLayoutConstraint.activate([
            self.settingButton.centerYAnchor.constraint(equalTo: self.topTitleView.centerYAnchor),
            self.settingButton.heightAnchor.constraint(equalToConstant: 44),
            self.settingButton.trailingAnchor.constraint(equalTo: self.topTitleView.trailingAnchor),
            self.settingButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // Main time view layout
        NSLayoutConstraint.activate([
            self.mainTimeView.topAnchor.constraint(equalTo: self.topTitleView.bottomAnchor),
            self.mainTimeView.heightAnchor.constraint(equalToConstant: 180),
            self.mainTimeView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            self.mainTimeView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
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
            self.progressRateButtonView.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor, constant: -26),
            self.progressRateButtonView.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Main time view remaining time value view layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingTimeValueView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 77),
            self.mainTimeViewRemainingTimeValueView.heightAnchor.constraint(equalToConstant: 52),
            self.mainTimeViewRemainingTimeValueView.centerXAnchor.constraint(equalTo: self.mainTimeView.centerXAnchor),
            self.mainTimeViewRemainingTimeValueView.widthAnchor.constraint(equalToConstant: 182)
        ])
        
        // Main time view remaining hour value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingHourValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.topAnchor),
            self.mainTimeViewRemainingHourValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.bottomAnchor),
            self.mainTimeViewRemainingHourValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.leadingAnchor),
            self.mainTimeViewRemainingHourValueLabel.widthAnchor.constraint(equalTo: self.mainTimeViewRemainingMinuteValueLabel.widthAnchor)
        ])
        
        // Main time view remaining first separator label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingFirstSeparatorLabel.topAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.topAnchor),
            self.mainTimeViewRemainingFirstSeparatorLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.bottomAnchor),
            self.mainTimeViewRemainingFirstSeparatorLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewRemainingHourValueLabel.trailingAnchor),
            self.mainTimeViewRemainingFirstSeparatorLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        // Main time view remaining minute value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingMinuteValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.topAnchor),
            self.mainTimeViewRemainingMinuteValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.bottomAnchor),
            self.mainTimeViewRemainingMinuteValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewRemainingFirstSeparatorLabel.trailingAnchor),
            self.mainTimeViewRemainingHourValueLabel.widthAnchor.constraint(equalTo: self.mainTimeViewRemainingSecondValueLabel.widthAnchor)
        ])
        
        // Main time view remaining second separator label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingSecondSeparatorLabel.topAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.topAnchor),
            self.mainTimeViewRemainingSecondSeparatorLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.bottomAnchor),
            self.mainTimeViewRemainingSecondSeparatorLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewRemainingMinuteValueLabel.trailingAnchor),
            self.mainTimeViewRemainingSecondSeparatorLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        // Main time view remaining second value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewRemainingSecondValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.topAnchor),
            self.mainTimeViewRemainingSecondValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewRemainingTimeValueView.bottomAnchor),
            self.mainTimeViewRemainingSecondValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewRemainingSecondSeparatorLabel.trailingAnchor),
            self.mainTimeViewRemainingSecondValueLabel.trailingAnchor.constraint(equalTo: mainTimeViewRemainingTimeValueView.trailingAnchor)
        ])
        
        // Main time view progress time value view layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressTimeValueView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 77),
            self.mainTimeViewProgressTimeValueView.heightAnchor.constraint(equalToConstant: 52),
            self.mainTimeViewProgressTimeValueView.centerXAnchor.constraint(equalTo: self.mainTimeView.centerXAnchor),
            self.mainTimeViewProgressTimeValueView.widthAnchor.constraint(equalToConstant: 182)
        ])
        
        // Main time view progress hour value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressHourValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.topAnchor),
            self.mainTimeViewProgressHourValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.bottomAnchor),
            self.mainTimeViewProgressHourValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.leadingAnchor),
            self.mainTimeViewProgressHourValueLabel.widthAnchor.constraint(equalTo: self.mainTimeViewProgressMinuteValueLabel.widthAnchor)
        ])
        
        // Main time view progress first separator label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressFirstSeparatorLabel.topAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.topAnchor),
            self.mainTimeViewProgressFirstSeparatorLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.bottomAnchor),
            self.mainTimeViewProgressFirstSeparatorLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewProgressHourValueLabel.trailingAnchor),
            self.mainTimeViewProgressFirstSeparatorLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        // Main time view progress minute value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressMinuteValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.topAnchor),
            self.mainTimeViewProgressMinuteValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.bottomAnchor),
            self.mainTimeViewProgressMinuteValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewProgressFirstSeparatorLabel.trailingAnchor),
            self.mainTimeViewProgressHourValueLabel.widthAnchor.constraint(equalTo: self.mainTimeViewProgressSecondValueLabel.widthAnchor)
        ])
        
        // Main time view progress second separator label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressSecondSeparatorLabel.topAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.topAnchor),
            self.mainTimeViewProgressSecondSeparatorLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.bottomAnchor),
            self.mainTimeViewProgressSecondSeparatorLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewProgressMinuteValueLabel.trailingAnchor),
            self.mainTimeViewProgressSecondSeparatorLabel.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        // Main time view progress second value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressSecondValueLabel.topAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.topAnchor),
            self.mainTimeViewProgressSecondValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressTimeValueView.bottomAnchor),
            self.mainTimeViewProgressSecondValueLabel.leadingAnchor.constraint(equalTo: self.mainTimeViewProgressSecondSeparatorLabel.trailingAnchor),
            self.mainTimeViewProgressSecondValueLabel.trailingAnchor.constraint(equalTo: mainTimeViewProgressTimeValueView.trailingAnchor)
        ])
        
        // Main time view rate value view layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressRateValueView.topAnchor.constraint(equalTo: self.mainTimeView.topAnchor, constant: 77),
            self.mainTimeViewProgressRateValueView.heightAnchor.constraint(equalToConstant: 52),
            self.mainTimeViewProgressRateValueView.centerXAnchor.constraint(equalTo: self.mainTimeView.centerXAnchor),
            self.mainTimeViewProgressRateValueView.widthAnchor.constraint(equalToConstant: 75+43)
        ])
        
        // Main time view rate integer value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressRateIntegerValueLabel.bottomAnchor.constraint(equalTo: self.mainTimeViewProgressRateValueView.bottomAnchor),
            self.mainTimeViewProgressRateIntegerValueLabel.leadingAnchor.constraint(equalTo: mainTimeViewProgressRateValueView.leadingAnchor),
            self.mainTimeViewProgressRateIntegerValueLabel.trailingAnchor.constraint(equalTo: self.mainTimeViewProgressRatePointSymbolLabel.leadingAnchor)
        ])
        
        // Main time view rate point symbol label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressRatePointSymbolLabel.lastBaselineAnchor.constraint(equalTo: self.mainTimeViewProgressRateIntegerValueLabel.lastBaselineAnchor),
            self.mainTimeViewProgressRatePointSymbolLabel.trailingAnchor.constraint(equalTo: mainTimeViewProgressRateFloatValueLabel.leadingAnchor),
            self.mainTimeViewProgressRatePointSymbolLabel.widthAnchor.constraint(equalToConstant: 7)
        ])
        
        // Main time view rate float value label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressRateFloatValueLabel.lastBaselineAnchor.constraint(equalTo: self.mainTimeViewProgressRateIntegerValueLabel.lastBaselineAnchor),
            self.mainTimeViewProgressRateFloatValueLabel.trailingAnchor.constraint(equalTo: self.mainTimeViewProgressRatePercentSymbolLabel.leadingAnchor),
            self.mainTimeViewProgressRateFloatValueLabel.widthAnchor.constraint(equalToConstant: 15)
        ])
        
        // Main time view rate percent symbol label layout
        NSLayoutConstraint.activate([
            self.mainTimeViewProgressRatePercentSymbolLabel.lastBaselineAnchor.constraint(equalTo: self.mainTimeViewProgressRateIntegerValueLabel.lastBaselineAnchor),
            self.mainTimeViewProgressRatePercentSymbolLabel.trailingAnchor.constraint(equalTo: self.mainTimeViewProgressRateValueView.trailingAnchor),
            self.mainTimeViewProgressRatePercentSymbolLabel.widthAnchor.constraint(equalToConstant: 21)
        ])
        
        // Change schedule button layout
        NSLayoutConstraint.activate([
            self.editScheduleButton.bottomAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: -17),
            self.editScheduleButton.heightAnchor.constraint(equalToConstant: 15),
            self.editScheduleButton.leadingAnchor.constraint(equalTo: self.mainTimeView.leadingAnchor, constant: 26),
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
            self.startWorkingTimeButton.trailingAnchor.constraint(equalTo: self.mainTimeView.trailingAnchor, constant: -26),
            self.startWorkingTimeButton.widthAnchor.constraint(equalToConstant: 42)
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
        
        // ignoreLunchBaseView
        NSLayoutConstraint.activate([
            self.ignoreLunchBaseView.topAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor),
            self.ignoreLunchBaseView.heightAnchor.constraint(equalToConstant: 40),
            self.ignoreLunchBaseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.ignoreLunchBaseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // ignoreLunchDescriptionLabel
        NSLayoutConstraint.activate([
            self.ignoreLunchDescriptionLabel.centerYAnchor.constraint(equalTo: self.ignoreLunchSwitch.centerYAnchor),
            self.ignoreLunchDescriptionLabel.trailingAnchor.constraint(equalTo: self.ignoreLunchSwitch.leadingAnchor, constant: -16)
        ])
        
        // ignoreLunchSwitch
        NSLayoutConstraint.activate([
            self.ignoreLunchSwitch.centerYAnchor.constraint(equalTo: self.ignoreLunchBaseView.centerYAnchor),
            self.ignoreLunchSwitch.trailingAnchor.constraint(equalTo: self.ignoreLunchBaseView.trailingAnchor, constant: -16),
        ])
        
        // Schedule table view layout
        self.scheduleTableViewTopAnchor = self.scheduleTableView.topAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: 10)
        self.scheduleTableViewHeightAnchor = self.scheduleTableView.heightAnchor.constraint(equalToConstant: 2 * ReferenceValues.Size.Schedule.normalScheduleHeight + ReferenceValues.Size.Schedule.overtimeScheduleHeight)
        NSLayoutConstraint.activate([
            self.scheduleTableViewTopAnchor,
            self.scheduleTableViewHeightAnchor,
            self.scheduleTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scheduleTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Change schedule description label layout
        NSLayoutConstraint.activate([
            self.changeScheduleDescriptionLabel.topAnchor.constraint(equalTo: self.scheduleTableView.bottomAnchor, constant: ReferenceValues.Size.Schedule.changeScheduleDescriptionLabelHeight),
            self.changeScheduleDescriptionLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Schedule button view layout
        NSLayoutConstraint.activate([
            self.scheduleButtonView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.scheduleButtonView.heightAnchor.constraint(equalToConstant: 101),
            self.scheduleButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scheduleButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // leavingDateCoverView
        NSLayoutConstraint.activate([
            self.leavingDateCoverView.topAnchor.constraint(equalTo: self.topTitleView.bottomAnchor),
            self.leavingDateCoverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.leavingDateCoverView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.leavingDateCoverView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MainViewController {
    func determineToday() {
        SupportingMethods.shared.determineTodayFinishingWorkTimePush(self.schedule)
        
        self.todayTimeValue = self.determineTodayTimeValue()
        self.tomorrowTimeValue = self.todayTimeValue + 86400
        
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let todayDateId = Int(dateFormatter.string(from: Date()))!
        if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date,
            let leavingDateId = Int(dateFormatter.string(from: leavingDate)),
           todayDateId > leavingDateId {
            self.stopTimer() // This(self) view shouldn't work because new timer on new main view would work for new company.
            
            self.leavingDateCoverView.isHidden = false
            
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            SupportingMethods.shared.turnOffAndRemoveLocalPush()
            SupportingMethods.shared.setAppSetting(with: nil, for: .isIgnoredLunchTimeToday)
            
        } else {
            self.leavingDateCoverView.isHidden = true
        }
        
        if case .normal = self.schedule.workType {
            self.startWorkingTimeButton.isEnabled = false
            
        } else {
            self.startWorkingTimeButton.isEnabled = true
        }
        
        self.todayRegularScheduleType = self.determineRegularSchedule(self.schedule)
        switch self.todayRegularScheduleType! {
        case .fullWork, .morningWork, .afternoonWork:
            self.remainingTimeButtonView.isEnabled = true
            self.progressTimeButtonView.isEnabled = true
            self.progressRateButtonView.isEnabled = true
            
            self.startWorkingTimeMarkLabel.isHidden = false
            self.startWorkingTimeButton.isHidden = false
            
        case .fullVacation, .fullHoliday:
            self.remainingTimeButtonView.isEnabled = false
            self.progressTimeButtonView.isEnabled = false
            self.progressRateButtonView.isEnabled = false
            
            self.startWorkingTimeMarkLabel.isHidden = true
            self.startWorkingTimeButton.isHidden = true
        }
        
        self.determineTableAndButtonTypeOfSchedule()
        
        DispatchQueue.main.async {
            self.determineIgnoreComponents()
        }
        
        if self.schedule.startingWorkTime == nil {
            self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
            self.resetMainTimeViewValues(self.todayRegularScheduleType)

        } else {
            if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                self.resetMainTimeViewValues(self.todayRegularScheduleType) // FIXME: Need to check at willAppear
                
            } else {
                // No need to reset main time view values
            }
        }
    }
    
    func determineTableAndButtonTypeOfSchedule() {
        self.calculateTableViewHeight(for: self.schedule)
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
    }
    
    func determineTodayTimeValue() -> Int {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let todayDayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let todaySecondComponents = DateComponents(year: todayDayComponents.year!, month: todayDayComponents.month!, day: todayDayComponents.day!, hour: 0, minute: 0, second: 0)
        
        return Int(calendar.date(from: todaySecondComponents)!.timeIntervalSinceReferenceDate)
    }
    
    func calculateTableViewHeight(for schedule: WorkScheduleModel) {
        if schedule.count == 0 {
            self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight
        }
        
        if schedule.count == 1 {
            self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2
        }
        
        if schedule.count == 2 {
            if self.isEditingMode {
                if case .afternoon(let workTimeType) = schedule.afternoon {
                    switch workTimeType {
                    case .holiday:
                        self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2
                        
                    case .vacation:
                        self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2
                        
                    case .work:
                        self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2 + ReferenceValues.Size.Schedule.overtimeScheduleHeight
                    }
                }
                
            } else {
                self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2
            }
        }
        
        if schedule.count == 3 {
            self.scheduleTableViewHeightAnchor.constant = ReferenceValues.Size.Schedule.normalScheduleHeight * 2 + ReferenceValues.Size.Schedule.overtimeScheduleHeight
        }
    }
    
    func determineRemainingTimeOnMainTimeView() {
        guard let finishingRegularWorkTimeSeconds = self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate else {
            return
        }
        
        let isIgnoredLunchTimeForHalfVacation = self.schedule.isIgnoringLunchTime
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsLeft = atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime - currentTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var remainingTimeSeconds: Int = 0
        
        if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType,
           case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if currentTimeSeconds < startingWorkTimeSeconds {
                remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                
            } else if currentTimeSeconds >= startingWorkTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds {
                remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                
            } else if currentTimeSeconds >= atLunchTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - lunchTimeSecondsLeft
                
            } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
            }
            
        } else if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else {
                    remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                }
                
            } else {
                if atLunchTimeSeconds >= startingWorkTimeSeconds + WorkScheduleModel.secondsOfWorkTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                        
                    } else {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                
                } else { // self.lunchTimeSecondsSinceReferenceDate < startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                        
                    } else if currentTimeSeconds >= startingWorkTimeSeconds && currentTimeSeconds < atLunchTimeSeconds {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds && currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - lunchTimeSecondsLeft //endingTimeSeconds - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                    
//                    if currentTimeSeconds < atLunchTimeSeconds {
//                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - WorkScheduleModel.secondsOfLunchTime
//
//                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
//                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
//                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - lunchTimeSecondsLeft
//
//                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
//                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
//                    }
                }
            }
            
        } else if case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else {
                    remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                }
                
            } else {
                if startingWorkTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                        
                    } else {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                    
                } else if startingWorkTimeSeconds >= atLunchTimeSeconds &&
                            startingWorkTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = self.lunchTimeSecondsSinceReferenceDate + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime  {
                        //remainingTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                        remainingTimeSeconds = endingTimeSeconds - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                        
                    } else {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                    
                } else { // startingWorkTimeSeconds < self.lunchTimeSecondsSinceReferenceDate
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - lunchTimeSecondsLeft
                        
                    } else {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                }
            }
            
        } else {
            // FIXME: For totally vacation or holiday
        }
        
        self.mainTimeViewRemainingHourValueLabel.text = remainingTimeSeconds > 0 ? String(format: "%02d", remainingTimeSeconds/3600) : "00"
        self.mainTimeViewRemainingMinuteValueLabel.text = remainingTimeSeconds > 0 ? String(format: "%02d", (remainingTimeSeconds%3600)/60) : "00"
        self.mainTimeViewRemainingSecondValueLabel.text = remainingTimeSeconds > 0 ? String(format: "%02d", remainingTimeSeconds%60) : "00"
    }
    
    func determineProgressTimeOnMainTimeView() {
        guard let finishingRegularWorkTimeSeconds = self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate else {
            return
        }
        
        let isIgnoredLunchTimeForHalfVacation = self.schedule.isIgnoringLunchTime
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsPassed = currentTimeSeconds - atLunchTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var progressTimeSeconds: Int = 0
        var maximumProgressTimeSeconds: Int = 0
        
        if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType,
           case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if currentTimeSeconds < startingWorkTimeSeconds {
                progressTimeSeconds = 0
                
            } else if currentTimeSeconds >= startingWorkTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds {
                progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                
            } else if currentTimeSeconds >= atLunchTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                
            } else if currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            }
            
            maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            
        } else if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    progressTimeSeconds = 0
                    
                } else {
                    progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                }
                
                maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                
            } else {
                if atLunchTimeSeconds >= startingWorkTimeSeconds + WorkScheduleModel.secondsOfWorkTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else { // self.lunchTimeSecondsSinceReferenceDate < startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        progressTimeSeconds = 0
                        
                    } else if currentTimeSeconds >= startingWorkTimeSeconds && currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds && currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    
//                    if currentTimeSeconds < atLunchTimeSeconds {
//                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
//
//                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
//                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
//                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
//
//                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
//                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
//                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else if case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    progressTimeSeconds = 0
                    
                } else {
                    progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                }
                
                maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                
            } else {
                if startingWorkTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else if startingWorkTimeSeconds >= atLunchTimeSeconds &&
                            startingWorkTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = self.lunchTimeSecondsSinceReferenceDate + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime  {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = currentTimeSeconds - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                    
                } else { // startingWorkTimeSeconds < self.lunchTimeSecondsSinceReferenceDate
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else {
            // FIXME: For totally vacation or holiday
        }
        
        self.mainTimeViewProgressHourValueLabel.text = currentTimeSeconds <= endingTimeSeconds ? String(format: "%02d", progressTimeSeconds/3600) : String(format: "%02d", maximumProgressTimeSeconds/3600)
        self.mainTimeViewProgressMinuteValueLabel.text = currentTimeSeconds <= endingTimeSeconds ? String(format: "%02d", (progressTimeSeconds%3600)/60) : String(format: "%02d", (maximumProgressTimeSeconds%3600)/60)
        self.mainTimeViewProgressSecondValueLabel.text = currentTimeSeconds <= endingTimeSeconds ? String(format: "%02d", progressTimeSeconds%60) : String(format: "%02d", maximumProgressTimeSeconds%60)
    }
    
    func determineProgressRateOnMainTimeView() {
        guard let finishingRegularWorkTimeSeconds = self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate else {
            return
        }
        
        let isIgnoredLunchTimeForHalfVacation = self.schedule.isIgnoringLunchTime
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsPassed = currentTimeSeconds - atLunchTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var progressTimeSeconds: Int = 0
        var maximumProgressTimeSeconds: Int = 0
        
        if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType,
           case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if currentTimeSeconds < startingWorkTimeSeconds {
                progressTimeSeconds = 0
                
            } else if currentTimeSeconds >= startingWorkTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds {
                progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                
            } else if currentTimeSeconds >= atLunchTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                
            } else if currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            }
            
            maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            
        } else if case .morning(let workTimeType) = self.schedule.morning, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    progressTimeSeconds = 0
                    
                } else {
                    progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                }
                
                maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                
            } else {
                if atLunchTimeSeconds >= startingWorkTimeSeconds + WorkScheduleModel.secondsOfWorkTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else { // self.lunchTimeSecondsSinceReferenceDate < startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < startingWorkTimeSeconds {
                        progressTimeSeconds = 0
                        
                    } else if currentTimeSeconds >= startingWorkTimeSeconds && currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds && currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    
//                    if currentTimeSeconds < atLunchTimeSeconds {
//                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
//
//                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
//                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
//                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - lunchTimeSecondsPassed
//
//                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
//                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
//                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else if case .afternoon(let workTimeType) = self.schedule.afternoon, case .work = workTimeType {
            if isIgnoredLunchTimeForHalfVacation {
                //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                if currentTimeSeconds < startingWorkTimeSeconds {
                    progressTimeSeconds = 0
                    
                } else {
                    progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                }
                
                maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                
            } else {
                if startingWorkTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds
                    
                } else if startingWorkTimeSeconds >= atLunchTimeSeconds &&
                            startingWorkTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = self.lunchTimeSecondsSinceReferenceDate + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime  {
                        progressTimeSeconds = 0
                        
                    } else {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - (atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime)
                    
                } else { // startingWorkTimeSeconds < self.lunchTimeSecondsSinceReferenceDate
                    //self.finishingRegularWorkTimeSecondsSinceReferenceDate = startingWorkTimeSeconds + type(of: self).secondsOfLunchTime + type(of: self).secondsOfWorkTime
                    if currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else {
            // FIXME: For totally vacation or holiday
        }
        
        
        
        let rate = Double(progressTimeSeconds) / Double(maximumProgressTimeSeconds)
//        let rate = Double(progressTimeSeconds) / Double(maximumPrgressTimeSeconds) < 1.0 ? Double(progressTimeSeconds) / Double(maximumPrgressTimeSeconds) : 1.0
        
        self.mainTimeViewProgressRateIntegerValueLabel.text = "\(Int(rate * 100))"
        self.mainTimeViewProgressRateFloatValueLabel.text = "\(Int(rate * 1000) % 10)"
    }
    
    func determineScheduleButtonState(for schedule: WorkScheduleModel) {
        if self.isEditingMode { // MARK: Editing Mode
            if schedule.count > 2 { // 3
                self.scheduleButtonView.setScheduleButtonView(.noButton)
                
            } else if schedule.count == 2 {
                if case .afternoon(let workTimeType) = schedule.afternoon, case .work = workTimeType {
                    if self.mainTimeCoverView.isHidden { // 추가|제거 deactivated, after touching a kind of enable overtime
                        if schedule.finishingRegularWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                            self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                            
                        } else {
                            self.scheduleButtonView.setScheduleButtonView(.addOvertimeOrFinishWork(nil), with: self.schedule)
                        }
                        
                    } else { // 추가|제거 activated
                        self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                    }
                    
                } else {
                    self.scheduleButtonView.setScheduleButtonView(.noButton)
                }
                
            } else if schedule.count == 1 {
                if case .morning(let workTimeType) = schedule.morning {
                    switch workTimeType {
                    case .work:
                        self.scheduleButtonView.setScheduleButtonView(.threeSchedules(nil))
                        
                    case .vacation:
                        self.scheduleButtonView.setScheduleButtonView(.twoScheduleForVacation(nil))
                        
                    case .holiday:
                        self.scheduleButtonView.setScheduleButtonView(.twoScheduleForHoliday(nil))
                    }
                }
                
            } else { // 0
                self.scheduleButtonView.setScheduleButtonView(.threeSchedules(nil))
            }
            
        } else { // MARK: Not Editing Mode
            if schedule.dateOfFinishedSchedule != nil {
                self.scheduleButtonView.setScheduleButtonView(.workFinished)
                
            } else {
                if schedule.count > 2 { // 3
                    if case .overtime(let overtime) = schedule.overtime {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if SupportingMethods.getCurrentTimeSeconds() <= regularWorkSeconds {
                                self.scheduleButtonView.setScheduleButtonView(.noButton)
                                
                            } else if SupportingMethods.getCurrentTimeSeconds() > regularWorkSeconds &&
                                        SupportingMethods.getCurrentTimeSeconds() <= Int(overtime.timeIntervalSinceReferenceDate) { // in overtime
                                self.scheduleButtonView.setScheduleButtonView(.finishWorkWithOvertime(nil), with: self.schedule)
                                
                            } else { // after overtime
                                self.scheduleButtonView.setScheduleButtonView(.replaceOvertimeOrFinishWork(nil), with: self.schedule)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.noButton)
                        }
                    }
                    
                } else { // 2
                    if case .morning(let workTimeType) = schedule.morning, case .work = workTimeType,
                       case .afternoon(let workTimeType) = schedule.afternoon, case .work = workTimeType {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonView(.addOvertimeOrFinishWork(nil), with: self.schedule)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                        }
                        
                    } else if case .morning(let workTimeType) = schedule.morning, case .work = workTimeType {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonView(.noButton)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonView(.finishWork)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.noButton)
                        }
                        
                    } else if case .afternoon(let workTimeType) = schedule.afternoon, case .work = workTimeType {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonView(.addOvertimeOrFinishWork(nil), with: self.schedule)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                        }
                        
                    } else {
                        self.scheduleButtonView.setScheduleButtonView(.noButton)
                    }
                }
            }
        }
    }
    
    func determineCompleteChangingScheduleButtonState(for schedule: WorkScheduleModel) {
        if schedule.count < 2 {
            self.completeChangingScheduleButtonView.isEnabled = false
            
        } else {
            self.completeChangingScheduleButtonView.isEnabled = true
        }
    }
    
    func determineStartingWorkTimeButtonTitleWithSchedule(_ schedule: WorkScheduleModel, orTitle title: String? = nil) {
        if let title = title {
            self.startWorkingTimeButton.setTitle(title, for: .normal)
            
        } else {
            if let startingWorkingTime = schedule.startingWorkTime {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = .current
                dateFormatter.locale = Locale(identifier: "ko_KR")
                
                self.startWorkingTimeButton.setTitle(dateFormatter.string(from: startingWorkingTime), for: .normal)
            }
        }
    }
    
    func determineRegularSchedule(_ schedule: WorkScheduleModel) -> RegularScheduleType? {
        if case .morning(let workTimeType) = schedule.morning {
            switch workTimeType {
            case .work:
                if case .afternoon(let workTimeType) = schedule.afternoon {
                    switch workTimeType {
                    case .work:
                        return .fullWork
                        
                    case .vacation:
                        return .morningWork
                        
                    case .holiday:
                        return .morningWork
                    }
                    
                } else {
                    return nil
                }
                
            case .vacation:
                if case .afternoon(let workTimeType) = schedule.afternoon {
                    switch workTimeType {
                    case .work:
                        return .afternoonWork
                        
                    case .vacation:
                        return .fullVacation
                        
                    case .holiday:
                        return nil
                    }
                    
                } else {
                    return nil
                }
                
            case .holiday:
                if case .afternoon(let workTimeType) = schedule.afternoon {
                    switch workTimeType {
                    case .work:
                        return .afternoonWork
                        
                    case .vacation:
                        return nil
                        
                    case .holiday:
                        return .fullHoliday
                    }
                    
                } else {
                    return nil
                }
            }
            
        } else {
            return nil
        }
    }
    
    func determineTodayScheduleAfterInsertingRegularScheduleTo(_ scheduleInserting: WorkScheduleModel, against currentRegularScheduleType: RegularScheduleType?, completion:((_ isChanged: Bool, _ forSchedule: (RegularScheduleType?, WorkScheduleModel)?) -> ())?) {
        var scheduleInserting = scheduleInserting
        
        guard let regularScheduleTypeUpdating = self.determineRegularSchedule(scheduleInserting) else {
            return
        }
        
        if regularScheduleTypeUpdating == currentRegularScheduleType {
            completion?(false, nil)
            
        } else {
            switch regularScheduleTypeUpdating {
            case .fullWork: // MARK: .fullWork
                if case .morningWork = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .afternoonWork = currentRegularScheduleType {
                    if scheduleInserting.workType == .staggered {
                        if scheduleInserting.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleInserting.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                                
                                completion?(false, nil) // Recovery schedule with original one.
                            }
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                        }
                        
                    } else { // normal workType
                        // scheduleInserting.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                    }
                }
                
            case .morningWork: // MARK: .morningWork
                if case .fullWork = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .fullVacation = currentRegularScheduleType {
                    if scheduleInserting.workType == .normal {
                        // scheduleInserting.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .fullHoliday = currentRegularScheduleType {
                    if scheduleInserting.workType == .normal {
                        // scheduleInserting.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
            case .afternoonWork: // MARK: .afternoonWork
                if case .fullWork = currentRegularScheduleType {
                    if scheduleInserting.workType == .staggered {
                        if scheduleInserting.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleInserting.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                                
                                completion?(false, nil) // Recovery schedule with original one.
                            }
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                        }
                        
                    } else { // normal workType
                        // scheduleInserting.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                    }
                }
                
                if case .fullVacation = currentRegularScheduleType {
                    if scheduleInserting.workType == .normal {
                        // scheduleInserting.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .fullHoliday = currentRegularScheduleType {
                    if scheduleInserting.workType == .normal {
                        // scheduleInserting.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
            case .fullVacation: // MARK: .fullVacation
                if case .morningWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleInserting.workType == .staggered {
                        scheduleInserting.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .afternoonWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleInserting.workType == .staggered {
                        scheduleInserting.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
            case .fullHoliday: // MARK: .fullHoliday
                if case .morningWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleInserting.workType == .staggered {
                        scheduleInserting.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
                
                if case .afternoonWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleInserting.workType == .staggered {
                        scheduleInserting.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleInserting))
                }
            }
        }
    }
    
    func determineTodayScheduleAfterModifyingRegularScheduleTo(_ scheduleModifying: WorkScheduleModel, against currentRegularScheduleType: RegularScheduleType?, completion:((_ isChanged: Bool, _ forSchedule: (RegularScheduleType?, WorkScheduleModel)?) -> ())?) {
        var scheduleModifying = scheduleModifying
        
        guard let regularScheduleTypeUpdating = self.determineRegularSchedule(scheduleModifying) else {
            return
        }
        
        if regularScheduleTypeUpdating == currentRegularScheduleType {
            completion?(false, nil)
            
        } else {
            switch regularScheduleTypeUpdating {
            case .fullWork: // MARK: .fullWork
                if case .morningWork = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .afternoonWork = currentRegularScheduleType {
                    if scheduleModifying.workType == .staggered {
                        if scheduleModifying.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleModifying.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                        }
                        
                    } else { // normal workType
                        // scheduleModifying.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    }
                    
                } else if case .fullVacation = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .fullHoliday = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else { // .fullWork
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                }
                
            case .morningWork: // MARK: .morningWork
                if case .fullWork = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .afternoonWork = currentRegularScheduleType {
                    if scheduleModifying.workType == .staggered {
                        if scheduleModifying.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleModifying.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                        }
                        
                    } else { // normal workType
                        // scheduleModifying.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    }
                    
                } else if case .fullVacation = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .fullHoliday = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else { // .morningWork
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                }
                
            case .afternoonWork: // MARK: .afternoonWork
                if case .fullWork = currentRegularScheduleType {
                    if scheduleModifying.workType == .staggered {
                        if scheduleModifying.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleModifying.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                        }
                        
                    } else { // normal workType
                        // scheduleModifying.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    }
                    
                } else if case .morningWork = currentRegularScheduleType {
                    if scheduleModifying.workType == .staggered {
                        if scheduleModifying.startingWorkTime != nil {
                            let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                                scheduleModifying.updateStartingWorkTime(nil)
                                
                                completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                            }
                            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                            alertVC.addAction(okAction)
                            alertVC.addAction(cancelAction)
                            self.present(alertVC, animated: false)
                            
                        } else {
                            completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                        }
                        
                    } else { // noraml workType
                        // scheduleModifying.updateStartingWorkTime()
                        
                        completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    }
                    
                } else if case .fullVacation = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .fullHoliday = currentRegularScheduleType {
                    if scheduleModifying.workType == .normal {
                        // scheduleModifying.updateStartingWorkTime()
                        
                        //self.activateTimer()
                    }
                    
                    self.remainingTimeButtonView.isEnabled = true
                    self.progressTimeButtonView.isEnabled = true
                    self.progressRateButtonView.isEnabled = true
                    
                    switch self.mainTimeViewButtonType {
                    case .remainingTime:
                        self.remainingTimeButtonView.isSelected = true
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressTime:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = true
                        self.progressRateButtonView.isSelected = false
                        
                    case .progressRate:
                        self.remainingTimeButtonView.isSelected = false
                        self.progressTimeButtonView.isSelected = false
                        self.progressRateButtonView.isSelected = true
                    }
                    
                    self.startWorkingTimeMarkLabel.isHidden = false
                    self.startWorkingTimeButton.isHidden = false
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else { // .afternoonWork
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                }
                
            case .fullVacation: // MARK: .fullVacation
                if case .fullWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .morningWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .afternoonWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .fullHoliday = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else { // .fullVacation
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                }
                
            case .fullHoliday: // MARK: .fullHoliday
                if case .fullWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .morningWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .afternoonWork = currentRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    if scheduleModifying.workType == .staggered {
                        scheduleModifying.updateStartingWorkTime(nil)
                    }
                    
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else if case .fullVacation = currentRegularScheduleType {
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                    
                } else { // .fullHoliday
                    completion?(true, (regularScheduleTypeUpdating, scheduleModifying))
                }
            }
        }
    }
    
    func resetMainTimeViewValues(_ regularScheduleType: RegularScheduleType?) {
        if let regularScheduleType = regularScheduleType {
            switch regularScheduleType {
            case .fullWork:
                self.mainTimeViewRemainingHourValueLabel.text = "08"
                self.mainTimeViewRemainingMinuteValueLabel.text = "00"
                self.mainTimeViewRemainingSecondValueLabel.text = "00"
                
            case .morningWork:
                self.mainTimeViewRemainingHourValueLabel.text = "04"
                self.mainTimeViewRemainingMinuteValueLabel.text = "00"
                self.mainTimeViewRemainingSecondValueLabel.text = "00"
                
            case .afternoonWork:
                self.mainTimeViewRemainingHourValueLabel.text = "04"
                self.mainTimeViewRemainingMinuteValueLabel.text = "00"
                self.mainTimeViewRemainingSecondValueLabel.text = "00"
                
            case .fullVacation:
                self.mainTimeViewRemainingHourValueLabel.text = "00"
                self.mainTimeViewRemainingMinuteValueLabel.text = "00"
                self.mainTimeViewRemainingSecondValueLabel.text = "00"
                
            case .fullHoliday:
                self.mainTimeViewRemainingHourValueLabel.text = "00"
                self.mainTimeViewRemainingMinuteValueLabel.text = "00"
                self.mainTimeViewRemainingSecondValueLabel.text = "00"
            }
            
        } else {
            self.mainTimeViewRemainingHourValueLabel.text = "00"
            self.mainTimeViewRemainingMinuteValueLabel.text = "00"
            self.mainTimeViewRemainingSecondValueLabel.text = "00"
        }
        
        self.mainTimeViewProgressHourValueLabel.text = "00"
        self.mainTimeViewProgressMinuteValueLabel.text = "00"
        self.mainTimeViewProgressSecondValueLabel.text = "00"
        
        self.mainTimeViewProgressRateIntegerValueLabel.text = "0"
        self.mainTimeViewProgressRateFloatValueLabel.text = "0"
    }
    
    func activateTimer() {
        if self.timer == nil {
            let timer = self.makeTimerForSchedule()
            self.timer = timer
            
        } else {
            self.timer?.invalidate()
            let timer = self.makeTimerForSchedule()
            self.timer = timer
        }
    }
    
    func makeTimerForSchedule() -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func checkIfVacationIsOverTheNumberOfAnnualPaidHolidays(schedule: WorkScheduleModel, tempSchedule: WorkScheduleModel) -> Bool {
        if case .morning(let scheduleWorkType) = schedule.morning, scheduleWorkType == .vacation,
           case .afternoon(let scheduleWorkType) = schedule.afternoon, scheduleWorkType == .vacation {
            if case .morning(let scheduleWorkType) = tempSchedule.morning, scheduleWorkType != .vacation,
               case .afternoon(let scheduleWorkType) = tempSchedule.afternoon, scheduleWorkType != .vacation {
                if self.numberOfVacationsHold + 1.0 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
            
            if case .morning(let scheduleWorkType) = tempSchedule.morning, scheduleWorkType == .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
            
            if case .afternoon(let scheduleWorkType) = tempSchedule.afternoon, scheduleWorkType == .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
        }
        
        if case .morning(let scheduleWorkType) = schedule.morning, scheduleWorkType == .vacation {
            if case .morning(let scheduleWorkType) = tempSchedule.morning, scheduleWorkType != .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
        }
        
        if case .afternoon(let scheduleWorkType) = schedule.afternoon, scheduleWorkType == .vacation {
            if case .afternoon(let scheduleWorkType) = tempSchedule.afternoon, scheduleWorkType != .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkIfVacationIsOverTheNumberOfAnnualPaidHolidays(insertNormalSchedule: ScheduleType, schedule: WorkScheduleModel) -> Bool {
        if case .morning(let workTimeType) = insertNormalSchedule, workTimeType == .vacation {
            if case .morning(let workTimeType) = schedule.morning, workTimeType != .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
        }
        if case .afternoon(let workTimeType) = insertNormalSchedule, workTimeType == .vacation {
            if case .afternoon(let workTimeType) = schedule.afternoon, workTimeType != .vacation {
                if self.numberOfVacationsHold + 0.5 > self.numberOfAnnualPaidHolidays {
                    return true
                }
            }
        }
        
        return false
    }
    
    func determineIgnoreComponents() {
        self.ignoreLunchDescriptionLabel.textColor = self.schedule.isIgnoringLunchTime ? .black : .useRGB(red: 221, green: 221, blue: 221)
        self.ignoreLunchSwitch.setOn(self.schedule.isIgnoringLunchTime, animated: false)
        self.determineIfHalfDay()
    }
    
    func determineIfHalfDay() {
        var isHalfDay = false
        if case .morning(let morningWorkTimeType) = self.schedule.morning,
           case .afternoon(let afternoonWorkTimeType) = self.schedule.afternoon {
            if (morningWorkTimeType == .work && afternoonWorkTimeType != .work) ||
                (morningWorkTimeType != .work && afternoonWorkTimeType == .work) {
                isHalfDay = true
            }
        }
        
        self.makeHalfDayModeOn(isHalfDay)
    }
    
    func foldHalfDayMode(withAnimation animationMode: Bool = true) {
        self.makeHalfDayModeOn(false, withAnimation: animationMode)
    }
    
    func makeHalfDayModeOn(_ isOn: Bool, withAnimation animationMode: Bool = true) {
        self.scheduleTableViewTopAnchor.constant = isOn ? 40 : 10
        
        if animationMode {
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
                
            } completion: { isFinished in
                
            }
        }
        
        self.ignoreLunchBaseView.isHidden = !isOn
    }
}

// MARK: - Extension for Selector methods
extension MainViewController {
    @objc func menuButton(_ sender: UIButton) {
        let menuVC = MenuViewController()
        menuVC.mainVC = self
        let menuNaviVC = CustomizedNavigationController(rootViewController: menuVC)
        
        self.present(menuNaviVC, animated: true, completion: nil)
    }
    
    @objc func settingButton(_ sender: UIButton) {
        let settingVC = SettingViewController()
        settingVC.mainVC = self
        let settingNaviVC = CustomizedNavigationController(rootViewController: settingVC)
        
        self.present(settingNaviVC, animated: true, completion: nil)
    }
    
    @objc func menuBarButtonItem(_ sender: UIBarButtonItem) {
        let menuVC = MenuViewController()
        menuVC.mainVC = self
        let menuNaviVC = CustomizedNavigationController(rootViewController: menuVC)
        
        self.present(menuNaviVC, animated: true, completion: nil)
    }
    
    @objc func settingBarButtonItem(_ sender: UIBarButtonItem) {
        let settingVC = SettingViewController()
        settingVC.mainVC = self
        let settingNaviVC = CustomizedNavigationController(rootViewController: settingVC)
        
        self.present(settingNaviVC, animated: true, completion: nil)
    }
    
    @objc func timer(_ timer: Timer) {
        let now = SupportingMethods.getCurrentTimeSeconds()
        
        if (now >= self.tomorrowTimeValue) {
            if let presentedVC = self.presentedViewController {
                if self.isEditingMode {
                    if let schedule = self.tempSchedule {
                        self.schedule = schedule
                    }
                    
                    self.mainTimeCoverView.isHidden = true
                    self.isEditingMode = false
                }
                
                self.dismiss(animated: !(presentedVC is MainCoverViewController)) {
                    SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "날이 바뀌어 메인화면으로 돌아왔습니다.")
                }
                
            } else {
                if self.isEditingMode {
                    if let schedule = self.tempSchedule {
                        self.schedule = schedule
                    }
                    
                    self.mainTimeCoverView.isHidden = true
                    self.isEditingMode = false
                    
                    SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "날이 바뀌어 스케쥴 변경이 중단되었습니다.")
                }
            }
            
            self.schedule = .today
            self.determineToday()
            
        } else {
            guard let startingWorkTimeSecondsSinceReferenceDate = self.schedule.startingWorkTimeSecondsSinceReferenceDate else {
                self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
                
                return
            }
            
            if startingWorkTimeSecondsSinceReferenceDate >= now {
                self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                
            } else {
                self.determineStartingWorkTimeButtonTitleWithSchedule(self.schedule)
            }
            
            switch self.mainTimeViewButtonType {
            case .remainingTime:
                self.determineRemainingTimeOnMainTimeView()
                
            case .progressTime:
                self.determineProgressTimeOnMainTimeView()
                
            case .progressRate:
                self.determineProgressRateOnMainTimeView()
            }
            
            self.determineScheduleButtonState(for: self.schedule)
        }
    }
    
    @objc func remainingTimeButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = true
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewButtonType = .remainingTime
        self.mainTimeViewRemainingTimeValueView.isHidden = false
        self.mainTimeViewProgressTimeValueView.isHidden = true
        self.mainTimeViewProgressRateValueView.isHidden = true
    }
    
    @objc func progressTimeButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = true
        self.progressRateButtonView.isSelected = false
        
        self.mainTimeViewButtonType = .progressTime
        self.mainTimeViewRemainingTimeValueView.isHidden = true
        self.mainTimeViewProgressTimeValueView.isHidden = false
        self.mainTimeViewProgressRateValueView.isHidden = true
    }
    
    @objc func progressRateButtonView(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.remainingTimeButtonView.isSelected = false
        self.progressTimeButtonView.isSelected = false
        self.progressRateButtonView.isSelected = true
        
        self.mainTimeViewButtonType = .progressRate
        self.mainTimeViewRemainingTimeValueView.isHidden = true
        self.mainTimeViewProgressTimeValueView.isHidden = true
        self.mainTimeViewProgressRateValueView.isHidden = false
    }
    
    @objc func startWorkingTimeButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        if self.schedule.overtime == nil {
            let mainCoverVC = MainCoverViewController(.startingWorkTime(self.schedule), delegate: self)
            self.present(mainCoverVC, animated: false)
            
        } else {
            let alertVC = UIAlertController(title: "변경 불가", message: "추가근무 제거 후 변경해 주세요.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alertVC.addAction(action)
            self.present(alertVC, animated: true)
        }
    }
    
    @objc func editScheduleButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        if self.schedule.dateOfFinishedSchedule != nil {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "업무 재개", andMessage: "업무를 이미 종료했습니다.\n업무를 다시 재개하겠습니까?", okAction: UIAlertAction(title: "업무 재개", style: .default, handler: { _ in
                self.schedule.dateOfFinishedSchedule = nil

                self.editScheduleButton.setTitle("추가 | 제거", for: .normal)
                
                if self.schedule.workType == .staggered {
                    self.startWorkingTimeButton.isEnabled = true
                    
                } else {
                    self.startWorkingTimeButton.isEnabled = false
                }
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)

        } else {
            self.tempSchedule = self.schedule

            self.mainTimeCoverView.isHidden = false
            
            self.isEditingMode = true
        }
    }
    
    @objc func cancelChangingScheduleButtonView(_ sender: UIButton) {
        self.schedule = self.tempSchedule!
        
        self.mainTimeCoverView.isHidden = true
        self.isEditingMode = false
    }
    
    @objc func completeChangingScheduleButtonView(_ sender: UIButton) {
        // Calculate annualPaidHolidays and vacation hold before changing schedule.
        if self.checkIfVacationIsOverTheNumberOfAnnualPaidHolidays(schedule: self.schedule, tempSchedule: self.tempSchedule!) {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "연차 개수를 넘는 휴가 설정은 불가합니다. 휴가 일정 조정이 필요합니다.")
            
            return
        }
        
        // After calculateing, changing schedule.
        self.determineTodayScheduleAfterModifyingRegularScheduleTo(self.schedule, against: self.todayRegularScheduleType) { (isChanged: Bool, scheduleDetermined: (scheduleType: RegularScheduleType?, schedule: WorkScheduleModel)?) in
            if isChanged {
                self.schedule = scheduleDetermined!.schedule
                self.schedule.updateTodayIntoDB(self.schedule.workType == .staggered)
                
                if self.schedule.workType == .normal {
                    self.schedule.updateStartingWorkTime()
                }
                
                self.todayRegularScheduleType = scheduleDetermined!.scheduleType
                
                if self.schedule.startingWorkTime == nil {
                    self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
                    self.resetMainTimeViewValues(scheduleDetermined!.scheduleType)

                } else {
                    if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                        self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                        self.resetMainTimeViewValues(scheduleDetermined!.scheduleType)
                        
                    } else {
                        // No need to reset main time view values
                    }
                }
                
            } else {
                self.schedule = self.tempSchedule!
            }
            
            self.mainTimeCoverView.isHidden = true
            self.isEditingMode = false
        }
    }
    
    @objc func ignoreLunchSwitch(_ sender: YSBlueSwitch) {
        self.schedule.isIgnoringLunchTime = sender.isOn
        self.ignoreLunchDescriptionLabel.textColor = sender.isOn ? .black : .useRGB(red: 221, green: 221, blue: 221)
    }
    
    @objc func removeScheduleButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.schedule.removeSchedule(sender.tag)
        
        self.determineCompleteChangingScheduleButtonState(for: self.schedule)
        
        self.determineTableAndButtonTypeOfSchedule()
    }
    
    @objc func scheduleCellLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard !self.isEditingMode && self.schedule.dateOfFinishedSchedule == nil else {
            return
        }
        
        if let scheduleCell = gesture.view {
            if gesture.state == .began {
                UIDevice.heavyHaptic()
                
                if scheduleCell.tag == 1 {
                    print("Long Pressed for morning")
                    if self.schedule.overtime == nil {
                        var buttonType: NormalButtonType = .allButton
                        if case .afternoon(let workTimeType) = self.schedule.afternoon {
                            switch workTimeType {
                            case .work:
                                buttonType = .allButton
                                
                            case .vacation:
                                buttonType = .vacation
                                
                            case .holiday:
                                buttonType = .holiday
                            }
                        }
                        let mainCoverVC = MainCoverViewController(.normalSchedule(self.schedule.morning, buttonType), delegate: self)
                        self.present(mainCoverVC, animated: false)
                        
                    } else {
                        let alertVC = UIAlertController(title: "변경 불가", message: "추가근무 제거 후 변경해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true)
                    }
                    
                } else if scheduleCell.tag == 2 {
                    print("Long Pressed for afternoon")
                    if self.schedule.overtime == nil {
                        var buttonType: NormalButtonType = .allButton
                        if case .morning(let workTimeType) = self.schedule.morning {
                            switch workTimeType {
                            case .work:
                                buttonType = .allButton
                                
                            case .vacation:
                                buttonType = .vacation
                                
                            case .holiday:
                                buttonType = .holiday
                            }
                        }
                        let mainCoverVC = MainCoverViewController(.normalSchedule(self.schedule.afternoon, buttonType), delegate: self)
                        self.present(mainCoverVC, animated: false, completion: nil)
                        
                    } else {
                        let alertVC = UIAlertController(title: "변경 불가", message: "추가근무 제거 후 변경해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true)
                    }
                    
                } else { // tag 3, overtime
                    print("Long Pressed for overtime")
                    if case .overtime(let overtime) = self.schedule.overtime {
                        let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: overtime, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                        self.present(mainCoverVC, animated: false)
                    }
                }
            }
        }
    }
    
    @objc func initializeNewCompanyButton(_ sender: UIButton) {
        let initialVC = InitialViewController()
        initialVC.tempInitialSetting = ReferenceValues.initialSetting
        initialVC.modalPresentationStyle = .fullScreen
        
        self.present(initialVC, animated: true) {
            ReferenceValues.initialSetting = [:]
            
            VacationModel.removeAllVacations()
        }
    }
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
                if case .afternoon(let workTimeType) = self.schedule.afternoon {
                    switch workTimeType {
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
            return ReferenceValues.Size.Schedule.normalScheduleHeight
            
        } else if indexPath.row == 1 {
            return ReferenceValues.Size.Schedule.normalScheduleHeight
            
        } else { // 2
            return ReferenceValues.Size.Schedule.overtimeScheduleHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.schedule.count == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: true, tag:1)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
                
            } else { // row 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                cell.setCell(scheduleTypeText: "오후 일정", width: ReferenceValues.keyWindow.screen.bounds.width - 20, height: ReferenceValues.Size.Schedule.normalScheduleHeight)
                
                return cell
            }
            
        } else if self.schedule.count == 2 {
            if self.isEditingMode {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 1)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    return cell
                    
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    if self.mainTimeCoverView.isHidden { // 추가|제거 deactivated
                        cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                        
                    } else { // 추가|제거 activated
                        cell.setCell(schedule: self.schedule, isEditingMode: true, tag: 2)
                    }
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    return cell
                    
                } else { // row 2
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    cell.setCell(scheduleTypeText: "추가 일정", width: ReferenceValues.keyWindow.screen.bounds.width - 20, height: ReferenceValues.Size.Schedule.overtimeScheduleHeight)
                    
                    return cell
                }
                
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 1)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                    
                    return cell
                    
                } else { // row 1
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
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
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
                
            } else { // row 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(schedule: self.schedule, isEditingMode: self.isEditingMode, tag: 3)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(scheduleCellLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
            }
            
        } else { // row 0
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
            cell.setCell(scheduleTypeText: "오전 일정", width: ReferenceValues.keyWindow.screen.bounds.width - 20, height: ReferenceValues.Size.Schedule.normalScheduleHeight)
            
            return cell
        }
    }
}

// MARK: - Extension for ScheduleButtonViewDelegate
extension MainViewController: ScheduleButtonViewDelegate {
    func scheduleButtonView(_ scheduleButtonView: ScheduleButtonView, of type: ScheduleButtonViewType) {
        switch type {
        case .threeSchedules(let threeScheduleType): // MARK: threeSchedules
            if let threeScheduleType = threeScheduleType {
                switch threeScheduleType {
                case .work:
                    print("threeSchedules work")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with: WorkTimeType.work))
                    
                case .vacation:
                    print("threeSchedules vacation")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.vacation))
                    
                case .holiday:
                    print("threeSchedules holiday")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.holiday))
                }
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.determineTableAndButtonTypeOfSchedule()
            }
            
        case .twoScheduleForVacation(let twoScheduleForVacationType): // MARK: twoScheduleForVacation
            if let twoScheduleForVacationType = twoScheduleForVacationType {
                switch twoScheduleForVacationType {
                case .work:
                    print("twoScheduleForVacation work")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.work))
                    
                case .vacation:
                    print("twoScheduleForVacation vacation")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.vacation))
                }
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.determineTableAndButtonTypeOfSchedule()
            }
            
        case .twoScheduleForHoliday(let twoScheduleForHolidayType): // MARK: twoScheduleForHoliday
            if let twoScheduleForHolidayType = twoScheduleForHolidayType {
                switch twoScheduleForHolidayType {
                case .work:
                    print("twoScheduleForHoliday work")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.work))
                    
                case .holiday:
                    print("twoScheduleForHoliday holiday")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.holiday))
                }
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.determineTableAndButtonTypeOfSchedule()
            }
            
        case .addOvertime: // MARK: addOvertime
            print("addOvertime")
            
            if self.schedule.startingWorkTime == nil {
                print("Not possible to add overtime")
                let alertVC = UIAlertController(title: "알림", message: "출근시간을 설정해 주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alertVC.addAction(action)
                
                self.present(alertVC, animated: false)
                
            } else {
                if case .fullWork = self.todayRegularScheduleType {
                    if case .afternoonWork = self.determineRegularSchedule(self.schedule) {
                        let alertVC = UIAlertController(title: "알림", message: "출근시간을 오후로 변경한 후 추가해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        
                        self.present(alertVC, animated: false)
                        
                    } else {
                        let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: nil, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                        
                        self.present(mainCoverVC, animated: false) {
                            self.isEditingMode = true
                        }
                    }
                }
                
                if case .morningWork = self.todayRegularScheduleType {
                    if case .afternoonWork = self.determineRegularSchedule(self.schedule) {
                        let alertVC = UIAlertController(title: "알림", message: "출근시간을 오전으로 변경한 후 추가해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        
                        self.present(alertVC, animated: false)
                        
                    } else {
                        let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: nil, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                        
                        self.present(mainCoverVC, animated: false) {
                            self.isEditingMode = true
                        }
                    }
                }
                
                if case .afternoonWork = self.todayRegularScheduleType {
                    if case .afternoonWork = self.determineRegularSchedule(self.schedule) {
                        let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: nil, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                        
                        self.present(mainCoverVC, animated: false) {
                            self.isEditingMode = true
                        }
                        
                    } else {
                        let alertVC = UIAlertController(title: "알림", message: "출근시간을 오전으로 변경한 후 추가해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        
                        self.present(alertVC, animated: false)
                    }
                }
            }
            
        case .addOvertimeOrFinishWork(let overtimeOrFinish): // MARK: addOvertimeOrFinishWork
            if let overtimeOrFinish = overtimeOrFinish {
                switch overtimeOrFinish {
                case .overtime(let date):
                    print("addOvertimeOrFinishWork overtime")
                    let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: date, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                    
                    self.present(mainCoverVC, animated: false) {
                        self.isEditingMode = true
                    }
                    
                case .finishWork:
                    print("addOvertimeOrFinishWork finishWork")
                    self.schedule.dateOfFinishedSchedule = Date()
                    self.editScheduleButton.setTitle("업무 재개", for: .normal)
                    self.startWorkingTimeButton.isEnabled = false
                }
            }
            
        case .replaceOvertimeOrFinishWork(let overtimeOrFinish): // MARK: replaceOvertimeOrFinishWork
            if let overtimeOrFinish = overtimeOrFinish {
                switch overtimeOrFinish {
                case .overtime(let date):
                    print("replaceOvertimeOrFinishWork overtime")
                    let mainCoverVC = MainCoverViewController(.overtimeSchedule(finishingRegularTime: Date(timeIntervalSinceReferenceDate: Double(self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!)), overtime: date, isEditingModeBeforPresented: self.isEditingMode), delegate: self)
                    
                    self.present(mainCoverVC, animated: false)
                    
                case .finishWork:
                    print("replaceOvertimeOrFinishWork finishWork")
                    self.schedule.dateOfFinishedSchedule = Date()
                    self.editScheduleButton.setTitle("업무 재개", for: .normal)
                    self.startWorkingTimeButton.isEnabled = false
                }
            }
            
        case .finishWorkWithOvertime(let date): // MARK: finishWorkWithOvertime
            if let date = date {
                print("finishWorkWithOvertime at \(SupportingMethods.shared.makeDateFormatter("yyyy.MM.dd HH:mm:ss").string(from: date))")
                
                SupportingMethods.shared.makeAlert(on: self, withTitle: "업무 종료", andMessage: "\(SupportingMethods.shared.makeDateFormatter("H시 m분").string(from: date))에 업무를 종료합니다.", okAction: UIAlertAction(title: "업무 종료", style: .destructive, handler: { _ in
                    self.schedule.dateOfFinishedSchedule = date
                    self.editScheduleButton.setTitle("업무 재개", for: .normal)
                    self.startWorkingTimeButton.isEnabled = false
                    
                    self.schedule.insertSchedule(.overtime(date))
                    
                    self.determineTableAndButtonTypeOfSchedule()
                    
                    self.schedule.updateTodayIntoDB(true)
                }), cancelAction: UIAlertAction(title: "취소", style: .cancel, handler: nil), completion: nil)
            }
            
        case .finishWork: // MARK: finishWork
            print("finishWork")
            self.schedule.dateOfFinishedSchedule = Date()
            self.editScheduleButton.setTitle("업무 재개", for: .normal)
            self.startWorkingTimeButton.isEnabled = false
            
        case .workFinished, .noButton: // MARK: workFinished, noButton
            print("Nothing happen")
        }
    }
}

// MARK: - Extension for MainCoverDelegate
extension MainViewController: MainCoverDelegate {
    func mainCoverDidDetermineNormalSchedule(_ schedule: ScheduleType) {
        // Calculate annualPaidHolidays and vacation hold before inserting schedule.
        if self.checkIfVacationIsOverTheNumberOfAnnualPaidHolidays(insertNormalSchedule: schedule, schedule: self.schedule) {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "연차 개수를 넘는 휴가 설정은 불가합니다. 휴가 일정 조정이 필요합니다.")
            
            return
        }
        
        // After calculateing, inserting schedule.
        self.tempSchedule = self.schedule
        self.tempSchedule!.insertSchedule(schedule)
        
        self.determineTodayScheduleAfterInsertingRegularScheduleTo(self.tempSchedule!, against: self.todayRegularScheduleType) {(isChanged: Bool, scheduleDetermined: (scheduleType: RegularScheduleType?, schedule: WorkScheduleModel)?) in
            if isChanged {
                self.schedule = scheduleDetermined!.schedule
                self.schedule.updateTodayIntoDB(self.schedule.workType == .staggered)
                
                if self.schedule.workType == .normal {
                    self.schedule.updateStartingWorkTime()
                }
                
                self.todayRegularScheduleType = scheduleDetermined!.scheduleType
                
                if self.schedule.startingWorkTime == nil {
                    self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
                    self.resetMainTimeViewValues(scheduleDetermined!.scheduleType)

                } else {
                    if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                        self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                        self.resetMainTimeViewValues(scheduleDetermined!.scheduleType)
                        
                    } else {
                        // No need to reset main time view values
                    }
                }
                
                self.scheduleTableView.reloadData()
                self.determineScheduleButtonState(for: self.schedule)
                
                DispatchQueue.main.async {
                    self.determineIfHalfDay()
                }
            }
        }
    }
    
    func mainCoverDidDetermineOvertimeSchedule(_ schedule: ScheduleType, isEditingModeBeforPresenting: Bool!) {
        if self.isEditingMode {
            self.isEditingMode = isEditingModeBeforPresenting
            
            self.schedule.addSchedule(schedule)
            
        } else {
            self.schedule.insertSchedule(schedule)
        }
        
        if !self.isEditingMode {
            self.schedule.updateTodayIntoDB(true)
        }
        
        self.determineTableAndButtonTypeOfSchedule()
    }
    
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date) {
        self.schedule.updateStartingWorkTime(startingWorkTime)
        
        self.determineScheduleButtonState(for: self.schedule)
        
        //self.activateTimer()
    }
}
