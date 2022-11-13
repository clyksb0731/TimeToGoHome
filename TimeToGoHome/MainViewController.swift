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
    
    weak var timer: Timer?
    
    let workScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.27
    let overWorkScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.17
    let changeScheduleDescriptionLabelHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.024
    
    var scheduleTableViewHeightAnchor: NSLayoutConstraint!
    
    var mainTimeViewButtonType: MainTimeViewButtonType = .remainingTime
    
    var schedule: WorkScheduleModel = WorkScheduleModel.today
    var tempSchedule: WorkScheduleModel?
    var todayRegularScheduleType: RegularScheduleType?
    var todayTimeValue: Int = 0
    var tomorrowTimeValue: Int = 0
    
    var isEditingMode: Bool = false {
        didSet {
            if self.isEditingMode != oldValue {
                self.schedule.isEditingMode = self.isEditingMode
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
                
                self.changeScheduleDescriptionLabel.isHidden = self.isEditingMode
            }
        }
    }

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
        
        // Navigation bar appearance
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
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "오늘의 일정"
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
        self.todayTimeValue = self.determineTodayTimeValue()
        self.tomorrowTimeValue = self.todayTimeValue + 86400
        
        if case .normal = self.schedule.workType {
            self.startWorkingTimeButton.isEnabled = false
        }
        
        self.todayRegularScheduleType = self.determineRegularSchedule(self.schedule)
        self.resetMainTimeViewValues(self.todayRegularScheduleType)
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
        
        self.determineScheduleButtonState(for: self.schedule)
        
        if self.schedule.startingWorkTime == nil {
            self.startWorkingTimeButton.setTitle("시간설정", for: .normal)

        } else {
            if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                
            } else {
                // No need to reset main time view values
            }
            
            if self.timer == nil {
                let timer = self.makeTimerForSchedule()
                self.timer = timer
                
            } else {
                self.timer?.invalidate()
                let timer = self.makeTimerForSchedule()
                self.timer = timer
            }
        }
    }
    
    func makeTimerForSchedule() -> Timer {
        return Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timer(_:)), userInfo: nil, repeats: true)
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
    
    func determineRemainingTimeOnMainTimeView() {
        guard let finishingRegularWorkTimeSeconds = self.schedule.finishingRegularWorkTimeSecondsSinceReferenceDate else {
            return
        }
        
        let isIgnoredLunchTimeForHalfVacation = ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeForHalfVacation.rawValue] as! Bool
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsLeft = atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime - currentTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var remainingTimeSeconds: Int = 0
        
        if case .morning(let workType) = self.schedule.morning, case .work = workType,
           case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
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
            
        } else if case .morning(let workType) = self.schedule.morning, case .work = workType {
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
                    if currentTimeSeconds < atLunchTimeSeconds {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds - lunchTimeSecondsLeft
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        remainingTimeSeconds = endingTimeSeconds - currentTimeSeconds
                    }
                }
            }
            
        } else if case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
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
        
        let isIgnoredLunchTimeForHalfVacation = ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeForHalfVacation.rawValue] as! Bool
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsPassed = currentTimeSeconds - atLunchTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var progressTimeSeconds: Int = 0
        var maximumProgressTimeSeconds: Int = 0
        
        if case .morning(let workType) = self.schedule.morning, case .work = workType,
           case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
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
            
        } else if case .morning(let workType) = self.schedule.morning, case .work = workType {
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
                    if currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        progressTimeSeconds = currentTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else if case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
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
        
        let isIgnoredLunchTimeForHalfVacation = ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeForHalfVacation.rawValue] as! Bool
        
        let currentTimeSeconds = SupportingMethods.getCurrentTimeSeconds()
        let startingWorkTimeSeconds = self.schedule.startingWorkTimeSecondsSinceReferenceDate!
        let atLunchTimeSeconds = self.schedule.lunchTimeSecondsSinceReferenceDate
        let lunchTimeSecondsPassed = currentTimeSeconds - atLunchTimeSeconds
        let endingTimeSeconds = self.schedule.overtimeSecondsSincReferenceDate > 0 ? self.schedule.overtimeSecondsSincReferenceDate : finishingRegularWorkTimeSeconds
        
        var progressTimeSeconds: Int = 0
        var maximumProgressTimeSeconds: Int = 0
        
        if case .morning(let workType) = self.schedule.morning, case .work = workType,
           case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
            if currentTimeSeconds < startingWorkTimeSeconds {
                progressTimeSeconds = 0
                
            } else if currentTimeSeconds >= startingWorkTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds {
                progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                
            } else if currentTimeSeconds >= atLunchTimeSeconds &&
                        currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - lunchTimeSecondsPassed
                
            } else if currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            }
            
            maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
            
        } else if case .morning(let workType) = self.schedule.morning, case .work = workType {
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
                    if currentTimeSeconds < atLunchTimeSeconds {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
                    } else { // currentTimeSeconds >= atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                    }
                    
                    maximumProgressTimeSeconds = endingTimeSeconds - startingWorkTimeSeconds - WorkScheduleModel.secondsOfLunchTime
                }
            }
            
        } else if case .afternoon(let workType) = self.schedule.afternoon, case .work = workType {
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
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds
                        
                    } else if currentTimeSeconds >= atLunchTimeSeconds &&
                                currentTimeSeconds < atLunchTimeSeconds + WorkScheduleModel.secondsOfLunchTime {
                        progressTimeSeconds = (currentTimeSeconds > endingTimeSeconds ? endingTimeSeconds : currentTimeSeconds) - startingWorkTimeSeconds - lunchTimeSecondsPassed
                        
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
        if self.isEditingMode {
            if schedule.count > 2 { // 3
                self.scheduleButtonView.setScheduleButtonView(.noButton)
                
            } else if schedule.count == 2 {
                if case .afternoon(let workType) = schedule.afternoon, case .work = workType {
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
                if case .morning(let workType) = schedule.morning {
                    switch workType {
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
            
        } else { // Not edit mode
            if schedule.isFinishedScheduleToday {
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
                    if case .morning(let workType) = schedule.morning, case .work = workType,
                       case .afternoon(let workType) = schedule.afternoon, case .work = workType {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonView(.addOvertimeOrFinishWork(nil), with: self.schedule)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.addOvertime)
                        }
                        
                    } else if case .morning(let workType) = schedule.morning, case .work = workType {
                        if let regularWorkSeconds = schedule.finishingRegularWorkTimeSecondsSinceReferenceDate {
                            if regularWorkSeconds >= SupportingMethods.getCurrentTimeSeconds() { // before overtime
                                self.scheduleButtonView.setScheduleButtonView(.noButton)
                                
                            } else {
                                self.scheduleButtonView.setScheduleButtonView(.finishWork)
                            }
                            
                        } else { // before starting work time
                            self.scheduleButtonView.setScheduleButtonView(.noButton)
                        }
                        
                    } else if case .afternoon(let workType) = schedule.afternoon, case .work = workType {
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
    
    enum RegularScheduleType {
        case fullWork
        case morningWork
        case afternoonWork
        case fullVacation
        case fullHoliday
    }
    
    func determineRegularSchedule(_ schedule: WorkScheduleModel) -> RegularScheduleType? {
        if case .morning(let workType) = schedule.morning {
            switch workType {
            case .work:
                if case .afternoon(let workType) = schedule.afternoon {
                    switch workType {
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
                if case .afternoon(let workType) = schedule.afternoon {
                    switch workType {
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
                if case .afternoon(let workType) = schedule.afternoon {
                    switch workType {
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
    
    func determineTodayRegularScheduleTypeAfterInsertingRegularSchedule(_ schedule: WorkScheduleModel, completion:((RegularScheduleType, WorkScheduleModel) -> ())? = nil) {
        var schedule = schedule
        
        guard let regularScheduleType = self.determineRegularSchedule(schedule) else {
            return
        }
        
        if regularScheduleType == self.todayRegularScheduleType {
            completion?(regularScheduleType, schedule)
            
        } else {
            switch regularScheduleType {
            case .fullWork: // MARK: .fullWork
                if case .morningWork = self.todayRegularScheduleType {
                    completion?(regularScheduleType, schedule)
                }
                
                if case .afternoonWork = self.todayRegularScheduleType {
                    if schedule.startingWorkTime != nil {
                        let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                            self.timer?.invalidate()
                            schedule.updateStartingWorkTime(nil)
                            
                            completion?(regularScheduleType, schedule)
                        }
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                            
                            completion?(self.todayRegularScheduleType!, self.schedule)
                        }
                        alertVC.addAction(okAction)
                        alertVC.addAction(cancelAction)
                        self.present(alertVC, animated: false)
                        
                    } else {
                        completion?(regularScheduleType, schedule)
                    }
                }
                
            case .morningWork: // MARK: .morningWork
                if case .fullWork = self.todayRegularScheduleType {
                    completion?(regularScheduleType, schedule)
                }
                
                if case .fullVacation = self.todayRegularScheduleType {
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
                    
                    completion?(regularScheduleType, schedule)
                }
                
                if case .fullHoliday = self.todayRegularScheduleType {
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
                    
                    completion?(regularScheduleType, schedule)
                }
                
            case .afternoonWork: // MARK: .afternoonWork
                if case .fullWork = self.todayRegularScheduleType {
                    if schedule.startingWorkTime != nil {
                        let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                            self.timer?.invalidate()
                            schedule.updateStartingWorkTime(nil)
                            
                            completion?(regularScheduleType, schedule)
                        }
                        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { action in
                            
                            completion?(self.todayRegularScheduleType!, self.schedule)
                        }
                        alertVC.addAction(okAction)
                        alertVC.addAction(cancelAction)
                        self.present(alertVC, animated: false)
                        
                    } else {
                        completion?(regularScheduleType, schedule)
                    }
                }
                
                if case .fullVacation = self.todayRegularScheduleType {
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
                    
                    completion?(regularScheduleType, schedule)
                }
                
                if case .fullHoliday = self.todayRegularScheduleType {
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
                    
                    completion?(regularScheduleType, schedule)
                }
                
            case .fullVacation: // MARK: .fullVacation
                if case .morningWork = self.todayRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    self.timer?.invalidate()
                    schedule.updateStartingWorkTime(nil)
                    
                    completion?(regularScheduleType, schedule)
                }
                
                if case .afternoonWork = self.todayRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    self.timer?.invalidate()
                    schedule.updateStartingWorkTime(nil)
                    
                    completion?(regularScheduleType, schedule)
                }
                
            case .fullHoliday: // MARK: .fullHoliday
                if case .morningWork = self.todayRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    self.timer?.invalidate()
                    schedule.updateStartingWorkTime(nil)
                    
                    completion?(regularScheduleType, schedule)
                }
                
                if case .afternoonWork = self.todayRegularScheduleType {
                    self.remainingTimeButtonView.isEnabled = false
                    self.progressTimeButtonView.isEnabled = false
                    self.progressRateButtonView.isEnabled = false
                    
                    self.startWorkingTimeMarkLabel.isHidden = true
                    self.startWorkingTimeButton.isHidden = true
                    
                    self.timer?.invalidate()
                    schedule.updateStartingWorkTime(nil)
                    
                    completion?(regularScheduleType, schedule)
                }
            }
        }
    }
    
    func determineTodayRegularScheduleTypeAfterAddingRegularSchedule(_ schedule: WorkScheduleModel, completion:((RegularScheduleType) -> ())? = nil) {
        
        guard let regularScheduleType = self.determineRegularSchedule(schedule) else {
            return
        }
        
        switch regularScheduleType {
        case .fullWork: // MARK: .fullWork
            if case .morningWork = self.todayRegularScheduleType {
                completion?(regularScheduleType)
                
            } else if case .afternoonWork = self.todayRegularScheduleType {
                if self.schedule.startingWorkTime != nil {
                    let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                        self.timer?.invalidate()
                        self.schedule.updateStartingWorkTime(nil)
                        
                        completion?(regularScheduleType)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: false)
                    
                } else {
                    completion?(regularScheduleType)
                }
                
            } else if case .fullVacation = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else if case .fullHoliday = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else { // .fullWork
                completion?(regularScheduleType)
            }
            
        case .morningWork: // MARK: .morningWork
            if case .fullWork = self.todayRegularScheduleType {
                completion?(regularScheduleType)
                
            } else if case .afternoonWork = self.todayRegularScheduleType {
                if self.schedule.startingWorkTime != nil {
                    let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                        self.timer?.invalidate()
                        self.schedule.updateStartingWorkTime(nil)
                        
                        completion?(regularScheduleType)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: false)
                    
                } else {
                    completion?(regularScheduleType)
                }
                
            } else if case .fullVacation = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else if case .fullHoliday = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else { // .morningWork
                completion?(regularScheduleType)
            }
            
        case .afternoonWork: // MARK: .afternoonWork
            if case .fullWork = self.todayRegularScheduleType {
                if self.schedule.startingWorkTime != nil {
                    let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                        self.timer?.invalidate()
                        self.schedule.updateStartingWorkTime(nil)
                        
                        completion?(regularScheduleType)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: false)
                    
                } else {
                    completion?(regularScheduleType)
                }
                
            } else if case .morningWork = self.todayRegularScheduleType {
                if self.schedule.startingWorkTime != nil {
                    let alertVC = UIAlertController(title: "알림", message: "일정이 변경되면 출근시간의 재설정이 필요합니다. 그래도 변경하시겠습니까?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .destructive) { action in
                        self.timer?.invalidate()
                        self.schedule.updateStartingWorkTime(nil)
                        
                        completion?(regularScheduleType)
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    alertVC.addAction(okAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: false)
                    
                } else {
                    completion?(regularScheduleType)
                }
                
            } else if case .fullVacation = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else if case .fullHoliday = self.todayRegularScheduleType {
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
                
                completion?(regularScheduleType)
                
            } else { // .afternoonWork
                completion?(regularScheduleType)
            }
            
        case .fullVacation: // MARK: .fullVacation
            if case .fullWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .morningWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .afternoonWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .fullHoliday = self.todayRegularScheduleType {
                completion?(regularScheduleType)
                
            } else { // .fullVacation
                completion?(regularScheduleType)
            }
            
        case .fullHoliday: // MARK: .fullHoliday
            if case .fullWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .morningWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .afternoonWork = self.todayRegularScheduleType {
                self.remainingTimeButtonView.isEnabled = false
                self.progressTimeButtonView.isEnabled = false
                self.progressRateButtonView.isEnabled = false
                
                self.startWorkingTimeMarkLabel.isHidden = true
                self.startWorkingTimeButton.isHidden = true
                
                self.timer?.invalidate()
                self.schedule.updateStartingWorkTime(nil)
                
                completion?(regularScheduleType)
                
            } else if case .fullVacation = self.todayRegularScheduleType {
                completion?(regularScheduleType)
                
            } else { // .fullHoliday
                completion?(regularScheduleType)
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
}

// MARK: - Extension for Selector methods
extension MainViewController {
    @objc func menuBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func settingBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func timer(_ timer: Timer) {
        guard let startingWorkTimeSecondsSinceReferenceDate = self.schedule.startingWorkTimeSecondsSinceReferenceDate else {
            return
        }
        
        let now = SupportingMethods.getCurrentTimeSeconds()
        
        if (now >= self.tomorrowTimeValue) {
            self.timer?.invalidate()
            
            if self.isEditingMode {
                self.mainTimeCoverView.isHidden = true
                self.isEditingMode = false
                
                SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "날이 바뀌어 스케쥴 변경이 중단되었습니다.")
            }
            
            self.schedule = WorkScheduleModel.today
            
            self.determineToday()
            
        } else {
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
        
        self.tempSchedule = self.schedule
        
        self.mainTimeCoverView.isHidden = false
        self.isEditingMode = true
    }
    
    @objc func cancelChangingScheduleButtonView(_ sender: UIButton) {
        if let schedule = self.tempSchedule {
            self.schedule = schedule
        }
        
        self.mainTimeCoverView.isHidden = true
        self.isEditingMode = false
    }
    
    @objc func completeChangingScheduleButtonView(_ sender: UIButton) {
        self.determineTodayRegularScheduleTypeAfterAddingRegularSchedule(self.schedule) {regularScheduleType in
            if self.schedule.startingWorkTime == nil {
                self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
                self.resetMainTimeViewValues(regularScheduleType)

            } else {
                if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                    self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                    self.resetMainTimeViewValues(regularScheduleType)
                    
                } else {
                    // No need to reset main time view values
                }
            }
            
            self.schedule.updateTodayIntoDB()
            
            self.mainTimeCoverView.isHidden = true
            self.isEditingMode = false
            
            self.todayRegularScheduleType = regularScheduleType
        }
    }
    
    @objc func removeScheduleButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.schedule.removeSchedule(sender.tag)
        
        self.determineCompleteChangingScheduleButtonState(for: self.schedule)
        
        self.calculateTableViewHeight(for: self.schedule)
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
    }
    
    @objc func scheduleCellLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if let scheduleCell = gesture.view {
            if gesture.state == .began {
                UIDevice.heavyHaptic()
                
                if scheduleCell.tag == 1 {
                    print("Long Pressed for morning")
                    if self.schedule.overtime == nil {
                        var buttonType: NormalButtonType = .allButton
                        if case .afternoon(let workType) = self.schedule.afternoon {
                            switch workType {
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
                        if case .morning(let workType) = self.schedule.morning {
                            switch workType {
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
                    if self.mainTimeCoverView.isHidden { // 추가|제거 deactivated
                        cell.setCell(schedule: self.schedule, isEditingMode: false, tag: 2)
                        
                    } else { // 추가|제거 activated
                        cell.setCell(schedule: self.schedule, isEditingMode: true, tag: 2)
                    }
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
            
        } else { // row 0
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
        case .threeSchedules(let workType): // MARK: threeSchedules
            if let workType = workType {
                switch workType {
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
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
            }
            
        case .twoScheduleForVacation(let workType): // MARK: twoScheduleForVacation
            if let workType = workType {
                switch workType {
                case .work:
                    print("twoScheduleForVacation work")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.work))
                    
                case .vacation:
                    print("twoScheduleForVacation vacation")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.vacation))
                }
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
            }
            
        case .twoScheduleForHoliday(let workType): // MARK: twoScheduleForHoliday
            if let workType = workType {
                switch workType {
                case .work:
                    print("twoScheduleForHoliday work")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.work))
                    
                case .holiday:
                    print("twoScheduleForHoliday holiday")
                    self.schedule.addSchedule(WorkScheduleModel.makeNewScheduleBasedOnCountOfSchedule(self.schedule, with:WorkTimeType.holiday))
                }
                
                self.determineCompleteChangingScheduleButtonState(for: self.schedule)
                
                self.calculateTableViewHeight(for: self.schedule)
                self.scheduleTableView.reloadData()
                
                self.determineScheduleButtonState(for: self.schedule)
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
                }
            }
            
        case .finishWorkWithOvertime(let date): // MARK: finishWorkWithOvertime
            if let date = date {
                print("finishWorkWithOvertime at \(date)")
            }
            
        case .finishWork: // MARK: finishWork
            print("finishWork")
            
        case .workFinished, .noButton: // MARK: workFinished, noButton
            print("Nothing happen")
        }
    }
}

// MARK: - Extension for MainCoverDelegate
extension MainViewController: MainCoverDelegate {
    func mainCoverDidDetermineNormalSchedule(_ schedule: ScheduleType) {
        self.tempSchedule = self.schedule
        self.tempSchedule!.insertSchedule(schedule)
        
        self.determineTodayRegularScheduleTypeAfterInsertingRegularSchedule(self.tempSchedule!) {regularScheduleType, schedule in
            self.schedule = schedule
            self.schedule.updateTodayIntoDB()
            
            if self.schedule.startingWorkTime == nil {
                self.startWorkingTimeButton.setTitle("시간설정", for: .normal)
                self.resetMainTimeViewValues(regularScheduleType)

            } else {
                if self.schedule.startingWorkTimeSecondsSinceReferenceDate! >= SupportingMethods.getCurrentTimeSeconds() {
                    self.startWorkingTimeButton.setTitle("출근전", for: .normal)
                    self.resetMainTimeViewValues(regularScheduleType)
                    
                } else {
                    // No need to reset main time view values
                }
            }
            
            self.scheduleTableView.reloadData()
            
            self.determineScheduleButtonState(for: self.schedule)
            
            self.todayRegularScheduleType = regularScheduleType
        }
    }
    
    func mainCoverDidDetermineOvertimeSchedule(_ schedule: ScheduleType, isEditingModeBeforPresenting: Bool!) {
        if self.isEditingMode {
            self.isEditingMode = isEditingModeBeforPresenting
            
            self.schedule.addSchedule(schedule)
            
            self.calculateTableViewHeight(for: self.schedule)
            
        } else {
            self.schedule.insertSchedule(schedule)
            self.schedule.updateTodayIntoDB()
        }
        
        self.scheduleTableView.reloadData()
        
        self.determineScheduleButtonState(for: self.schedule)
    }
    
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date) {
        self.schedule.updateStartingWorkTime(startingWorkTime)
        
        self.determineScheduleButtonState(for: self.schedule)
        
        if self.timer == nil {
            let timer = self.makeTimerForSchedule()
            self.timer = timer
            
        } else {
            self.timer?.invalidate()
            let timer = self.makeTimerForSchedule()
            self.timer = timer
        }
    }
}
