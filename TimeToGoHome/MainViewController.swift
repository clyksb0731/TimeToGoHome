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
    
    lazy var buttonsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 75)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var recessTimeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 120, green: 223, blue: 238)
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addRecessTimeButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var recessTimeButtonViewLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "휴가"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var recessTimeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(recessTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var workTimeButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 125, green: 243, blue: 110)
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addWorkTimeButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var workTimeButtonViewLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "근무"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var workTimeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(workTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        pageControl.hidesForSinglePage = true
        pageControl.numberOfPages = 2
        pageControl.addTarget(self, action: #selector(pageControl(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    let workScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.3
    let overWorkScheduleViewHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.17
    let changeScheduleDescriptionLabelHeight = (UIScreen.main.bounds.height - (UIWindow().safeAreaInsets.top + 44 + 180 + 75 + 26 + UIWindow().safeAreaInsets.bottom)) * 0.049
    
    var scheduleTableViewHeightAnchor: NSLayoutConstraint!
    
    var schedule: WorkSchedule = WorkSchedule.today
    
    var isEditingMode: Bool = false {
        willSet {
            
        }
        
        didSet {
            self.scheduleTableView.reloadData()
            self.changeScheduleDescriptionLabel.isHidden = self.isEditingMode
        }
    }
    
    var previousPointX: CGFloat = 0
    var isHaptic: Bool = false

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
        print(":::::::::::: \(self.changeScheduleDescriptionLabelHeight)")
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menuBarButton"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingBarButton"), style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        // Table view height
        self.calculateTableViewHeight()
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
            self.buttonsScrollView,
            self.pageControl
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
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.buttonsScrollView)
        
        SupportingMethods.shared.addSubviews([
            self.recessTimeButtonView,
            self.workTimeButtonView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.addRecessTimeButtonImageView,
            self.recessTimeButtonViewLabel,
            self.recessTimeButton
        ], to: self.recessTimeButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.addWorkTimeButtonImageView,
            self.workTimeButtonViewLabel,
            self.workTimeButton
        ], to: self.workTimeButtonView)
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
        
        // Schedule table view layout
        self.scheduleTableViewHeightAnchor = self.scheduleTableView.heightAnchor.constraint(equalToConstant: 2 * self.workScheduleViewHeight + self.overWorkScheduleViewHeight)
        NSLayoutConstraint.activate([
            self.scheduleTableView.topAnchor.constraint(equalTo: self.mainTimeView.bottomAnchor, constant: 7),
            self.scheduleTableViewHeightAnchor,
            self.scheduleTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scheduleTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Change schedule description label layout
        NSLayoutConstraint.activate([
            self.changeScheduleDescriptionLabel.topAnchor.constraint(equalTo: self.scheduleTableView.bottomAnchor, constant: self.changeScheduleDescriptionLabelHeight),
            self.changeScheduleDescriptionLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.buttonsScrollView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor),
            self.buttonsScrollView.heightAnchor.constraint(equalToConstant: 75),
            self.buttonsScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.buttonsScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Page control layout
        NSLayoutConstraint.activate([
            self.pageControl.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.pageControl.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.buttonsScrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.buttonsScrollView.heightAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.buttonsScrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalToConstant: self.buttonsScrollView.contentSize.width)
        ])
        
        let pageWidth = UIScreen.main.bounds.width
        
        // Recess time button view layout
        NSLayoutConstraint.activate([
            self.recessTimeButtonView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.recessTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.recessTimeButtonView.centerXAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: pageWidth/2),
            self.recessTimeButtonView.widthAnchor.constraint(equalToConstant: pageWidth - 40)
        ])
        
        // Add recess time button image view layout
        NSLayoutConstraint.activate([
            self.addRecessTimeButtonImageView.centerYAnchor.constraint(equalTo: self.recessTimeButtonView.centerYAnchor),
            self.addRecessTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addRecessTimeButtonImageView.centerXAnchor.constraint(equalTo: self.recessTimeButtonView.centerXAnchor),
            self.addRecessTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Recess time button view label layout
        NSLayoutConstraint.activate([
            self.recessTimeButtonViewLabel.centerYAnchor.constraint(equalTo: self.recessTimeButtonView.centerYAnchor),
            self.recessTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            self.recessTimeButtonViewLabel.trailingAnchor.constraint(equalTo: self.recessTimeButtonView.trailingAnchor, constant: -34),
            self.recessTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Recess time button layout
        NSLayoutConstraint.activate([
            self.recessTimeButton.topAnchor.constraint(equalTo: self.recessTimeButtonView.topAnchor),
            self.recessTimeButton.bottomAnchor.constraint(equalTo: self.recessTimeButtonView.bottomAnchor),
            self.recessTimeButton.leadingAnchor.constraint(equalTo: self.recessTimeButtonView.leadingAnchor),
            self.recessTimeButton.trailingAnchor.constraint(equalTo: self.recessTimeButtonView.trailingAnchor)
        ])
        
        // Work time button view layout
        NSLayoutConstraint.activate([
            self.workTimeButtonView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.workTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.workTimeButtonView.centerXAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -(pageWidth/2)),
            self.workTimeButtonView.widthAnchor.constraint(equalToConstant: pageWidth - 40)
        ])
        
        // Add work time button image view layout
        NSLayoutConstraint.activate([
            self.addWorkTimeButtonImageView.centerYAnchor.constraint(equalTo: self.workTimeButtonView.centerYAnchor),
            self.addWorkTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addWorkTimeButtonImageView.centerXAnchor.constraint(equalTo: self.workTimeButtonView.centerXAnchor),
            self.addWorkTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Work time button view label layout
        NSLayoutConstraint.activate([
            self.workTimeButtonViewLabel.centerYAnchor.constraint(equalTo: self.workTimeButtonView.centerYAnchor),
            self.workTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            self.workTimeButtonViewLabel.trailingAnchor.constraint(equalTo: self.workTimeButtonView.trailingAnchor, constant: -34),
            self.workTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Work time button layout
        NSLayoutConstraint.activate([
            self.workTimeButton.topAnchor.constraint(equalTo: self.workTimeButtonView.topAnchor),
            self.workTimeButton.bottomAnchor.constraint(equalTo: self.workTimeButtonView.bottomAnchor),
            self.workTimeButton.leadingAnchor.constraint(equalTo: self.workTimeButtonView.leadingAnchor),
            self.workTimeButton.trailingAnchor.constraint(equalTo: self.workTimeButtonView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MainViewController {
    func calculateTableViewHeight() {
        if self.schedule.count == 0 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight
        }
        
        if self.schedule.count == 1 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
        }
        
        if self.schedule.count == 2 {
            if self.isEditingMode {
                self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2 + self.overWorkScheduleViewHeight
                
            } else {
                self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2
            }
        }
        
        if self.schedule.count == 3 {
            self.scheduleTableViewHeightAnchor.constant = self.workScheduleViewHeight * 2 + self.overWorkScheduleViewHeight
        }
    }
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
    
    @objc func recessTimeButton(_ sender: UIButton) {
        print("Recess Time Button touched")
    }
    
    @objc func workTimeButton(_ sender: UIButton) {
        print("Work Time Button touched")
    }
    
    @objc func pageControl(_ sender: UIPageControl) {
        self.previousPointX = buttonsScrollView.contentOffset.x
        
        if sender.currentPage == 0 {
            self.buttonsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        if sender.currentPage == 1 {
            self.buttonsScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
        }
        
//        if sender.currentPage == 2 {
//            self.buttonsScrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0), animated: true)
//        }
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
                return 3
                
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
                cell.setCell(scheduleType: self.schedule.morning!, isEditingMode: true)
                
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
                    cell.setCell(scheduleType: self.schedule.morning!, isEditingMode: false)
                    
                    return cell
                    
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(scheduleType: self.schedule.afternoon!, isEditingMode: true)
                    
                    return cell
                    
                } else { // row 2
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
                    cell.setCell(scheduleTypeText: "추가 일정", width: UIScreen.main.bounds.width - 10, height: self.overWorkScheduleViewHeight)
                    
                    return cell
                }
                
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(scheduleType: self.schedule.morning!, isEditingMode: false)
                    
                    return cell
                    
                } else { // row 1
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                    cell.setCell(scheduleType: self.schedule.afternoon!, isEditingMode: false)
                    
                    return cell
                }
            }
            
        } else if self.schedule.count == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(scheduleType: self.schedule.morning!, isEditingMode: false)
                
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(scheduleType: self.schedule.afternoon!, isEditingMode: false)
                
                return cell
                
            } else { // row 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTypeCell") as! ScheduleTypeCell
                cell.setCell(scheduleType: self.schedule.overtime!, isEditingMode: self.isEditingMode)
                
                return cell
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulingCell") as! SchedulingCell
            cell.setCell(scheduleTypeText: "오전 일정", width: UIScreen.main.bounds.width - 10, height: self.workScheduleViewHeight)
            
            return cell
        }
    }
}

// MARK: - Extension for UIScrollDelegate
extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll: \(scrollView.contentOffset.x)")
        
        let centerXPoint: CGFloat = scrollView.frame.width / 2
        print("CneterXPoint: \(centerXPoint)")
        
        if self.previousPointX >= 0 && self.previousPointX < centerXPoint {
            if scrollView.contentOffset.x >= centerXPoint {
                if !self.isHaptic {
                    UIDevice.softHaptic()
                    self.isHaptic = true
                }
                
                self.pageControl.currentPage = 1
                
            } else {
                self.isHaptic = false
                
                self.pageControl.currentPage = 0
            }
            
        } else {
            if scrollView.contentOffset.x < centerXPoint {
                if !self.isHaptic {
                    UIDevice.softHaptic()
                    self.isHaptic = true
                }
                
                self.pageControl.currentPage = 0
                
            } else {
                self.isHaptic = false
                
                self.pageControl.currentPage = 1
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating: \(scrollView.contentOffset.x)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating: \(scrollView.contentOffset.x)")
        
        self.isHaptic = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging: \(scrollView.contentOffset.x)")
        
        self.previousPointX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            print("scrollViewDidEndDragging willDecelerate: \(scrollView.contentOffset.x)")
            
        } else {
            print("scrollViewDidEndDragging willNotDecelerate: \(scrollView.contentOffset.x)")
        }
    }
}
