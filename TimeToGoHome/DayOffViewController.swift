//
//  DayOffViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/04/04.
//

import UIKit

class DayOffViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 674)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "휴무 설정"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var calendarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 45, height: 45)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: 315, height: 21)
        flowLayout.footerReferenceSize = .zero
        
        //let collectionView = UICollectionView()
        //collectionView.collectionViewLayout = flowLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        collectionView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var vacationSettingButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningVacationButtonView: VacationButtonView = {
        let buttonView = VacationButtonView(title: "오전", isSelected: false)
        buttonView.tag = 1
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var afternoonVacationButtonView: VacationButtonView = {
        let buttonView = VacationButtonView(title: "오후", isSelected: false)
        buttonView.tag = 2
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var yearMonthButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var perviousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "previousMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "previousMonthDisableButton"), for: .disabled)
        button.addTarget(self, action: #selector(perviousMonthButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "\(self.todayDateComponents.year!)년 \(self.todayDateComponents.month!)월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nextMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "nextMonthDisableButton"), for: .disabled)
        button.addTarget(self, action: #selector(nextMonthButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var numberOfVacationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var numberOfVacationMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 197, green: 199, blue: 201)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.text = "휴가"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var numberOfVacationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16)
        let numberOfTotalVacations = SupportingMethods.shared.useAppSetting(for: .numberOfTotalVacations) as! Int
        label.text = "\(self.getVacationsHold())일 | \(numberOfTotalVacations)일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var numberOfVacationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(numberOfVacationButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var holidaysLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.text = "정기 휴일 설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dayButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var sundayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .sunday)
        buttonView.tag = 1
        buttonView.isSelected = true
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var mondayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .monday)
        buttonView.tag = 2
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var tuesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .tuesday)
        buttonView.tag = 3
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var wednesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .wednesday)
        buttonView.tag = 4
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var thursdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .thursday)
        buttonView.tag = 5
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var fridayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .friday)
        buttonView.tag = 6
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var saturdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .saturday)
        buttonView.tag = 7
        buttonView.isSelected = true
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 146, green: 243, blue: 205)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 255, green: 255, blue: 255)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "시작"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(startButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var settingVacationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var settingTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.text = "휴가 기준"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var settingVacationButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var fiscalYearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingVacationNormalButton"), for: .normal)
        button.setImage(UIImage(named: "settingVacationSelectedButton"), for: .selected)
        button.addTarget(self, action: #selector(fiscalYearButton(_:)), for: .touchUpInside)
        button.isSelected = {
            let vacationType = SupportingMethods.shared.useAppSetting(for: .vacationType) as! String
            return vacationType == "fiscalYear"
        }()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var fiscalYearMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "회계연도"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningDayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingVacationNormalButton"), for: .normal)
        button.setImage(UIImage(named: "settingVacationSelectedButton"), for: .selected)
        button.addTarget(self, action: #selector(joiningDayButton(_:)), for: .touchUpInside)
        button.isSelected = {
            let vacationType = SupportingMethods.shared.useAppSetting(for: .vacationType) as! String
            return vacationType == "joiningDay"
        }()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var joiningDayMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "입사날짜"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var settingNumberOfTotalVacationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "minusNormalButton"), for: .normal)
        button.setImage(UIImage(named: "minusDisableButton"), for: .disabled)
        button.addTarget(self, action: #selector(minusButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var numberOfTotalVacationsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.text = "15" // FIXME: need to be edited
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plusButton"), for: .normal)
        button.addTarget(self, action: #selector(plusButton(_:)), for: .touchUpInside)
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
    
    lazy var declineButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .semibold)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(declineButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    var todayDateComponents: DateComponents = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        return dateComponents
    }()
    
    var weeksOfMonth: Int = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let weeksOfMonth = calendar.range(of: .weekOfMonth, in: .month, for: Date())
        
        return (weeksOfMonth?.count)!
    }()
    
    var daysOfMonth: Int = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let daysOfMonth = calendar.range(of: .day, in: .month, for: Date())
        
        return (daysOfMonth?.count)!
    }()
    
    var firstWeekDay: Int = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        var firstDayDateComponents = DateComponents(year: todayDateComponents.year!, month: todayDateComponents.month!, day: 1)
        let firstDate = calendar.date(from: firstDayDateComponents)!
        firstDayDateComponents = calendar.dateComponents([.weekday], from: firstDate)
        
        return firstDayDateComponents.weekday!
    }()

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
            print("----------------------------------- DayOffViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension DayOffViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
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
            self.scrollView,
            self.startButtonView,
            self.coverView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.titleLabel,
            self.calendarCollectionView,
            self.vacationSettingButtonView,
            self.separatorLineView,
            self.numberOfVacationView,
            self.holidaysLabel,
            self.dayButtonsView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.morningVacationButtonView,
            self.afternoonVacationButtonView,
            self.yearMonthButtonView
        ], to: self.vacationSettingButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.perviousMonthButton,
            self.yearMonthLabel,
            self.nextMonthButton
        ], to: self.yearMonthButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.numberOfVacationMarkLabel,
            self.numberOfVacationLabel,
            self.numberOfVacationButton
        ], to: self.numberOfVacationView)
        
        SupportingMethods.shared.addSubviews([
            self.sundayButtonView,
            self.mondayButtonView,
            self.tuesdayButtonView,
            self.wednesdayButtonView,
            self.thursdayButtonView,
            self.fridayButtonView,
            self.saturdayButtonView
        ], to: self.dayButtonsView)
        
        SupportingMethods.shared.addSubviews([
            self.startButtonLabel,
            self.startButton
        ], to: self.startButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.settingVacationView
        ], to: self.coverView)
        
        SupportingMethods.shared.addSubviews([
            self.settingTitleLabel,
            self.settingVacationButtonsView,
            self.settingNumberOfTotalVacationView,
            self.confirmButton,
            self.declineButton
        ], to: self.settingVacationView)
        
        SupportingMethods.shared.addSubviews([
            self.fiscalYearButton,
            self.fiscalYearMarkLabel,
            self.joiningDayButton,
            self.joiningDayMarkLabel
        ], to: self.settingVacationButtonsView)
        
        SupportingMethods.shared.addSubviews([
            self.minusButton,
            self.numberOfTotalVacationsLabel,
            self.plusButton
        ], to: self.settingNumberOfTotalVacationView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // scrollView layout
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.startButtonView.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // contentView layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        // dismissButton layout
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // titleLabel layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 55),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
        ])
        
        // calendarCollectionView layout
        NSLayoutConstraint.activate([
            self.calendarCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 32),
            self.calendarCollectionView.heightAnchor.constraint(equalToConstant: 21+45*CGFloat(self.weeksOfMonth)),
            self.calendarCollectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.calendarCollectionView.widthAnchor.constraint(equalToConstant: 7*45)
        ])
        
        // vacationSettingButtonView layout
        NSLayoutConstraint.activate([
            self.vacationSettingButtonView.topAnchor.constraint(equalTo: self.calendarCollectionView.bottomAnchor, constant: 32),
            self.vacationSettingButtonView.heightAnchor.constraint(equalToConstant: 28),
            self.vacationSettingButtonView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.vacationSettingButtonView.widthAnchor.constraint(equalToConstant: 295)
        ])
        
        // morningVacationButtonView layout
        NSLayoutConstraint.activate([
            self.morningVacationButtonView.topAnchor.constraint(equalTo: self.vacationSettingButtonView.topAnchor),
            self.morningVacationButtonView.bottomAnchor.constraint(equalTo: self.vacationSettingButtonView.bottomAnchor),
            self.morningVacationButtonView.leadingAnchor.constraint(equalTo: self.vacationSettingButtonView.leadingAnchor),
            self.morningVacationButtonView.widthAnchor.constraint(equalToConstant: 52)
        ])
        
        // afternoonVacationButtonView layout
        NSLayoutConstraint.activate([
            self.afternoonVacationButtonView.topAnchor.constraint(equalTo: self.vacationSettingButtonView.topAnchor),
            self.afternoonVacationButtonView.bottomAnchor.constraint(equalTo: self.vacationSettingButtonView.bottomAnchor),
            self.afternoonVacationButtonView.leadingAnchor.constraint(equalTo: self.morningVacationButtonView.trailingAnchor, constant: 5),
            self.afternoonVacationButtonView.widthAnchor.constraint(equalToConstant: 52)
        ])
        
        // yearMonthButtonView layout
        NSLayoutConstraint.activate([
            self.yearMonthButtonView.centerYAnchor.constraint(equalTo: self.vacationSettingButtonView.centerYAnchor),
            self.yearMonthLabel.heightAnchor.constraint(equalToConstant: 21),
            self.yearMonthButtonView.trailingAnchor.constraint(equalTo: self.vacationSettingButtonView.trailingAnchor),
            self.yearMonthButtonView.widthAnchor.constraint(equalToConstant: 134)
        ])
        
        // perviousMonthButton layout
        NSLayoutConstraint.activate([
            self.perviousMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
            self.perviousMonthButton.heightAnchor.constraint(equalToConstant: 21),
            self.perviousMonthButton.leadingAnchor.constraint(equalTo: self.yearMonthButtonView.leadingAnchor),
            self.perviousMonthButton.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        // yearMonthLabel layout
        NSLayoutConstraint.activate([
            self.yearMonthLabel.topAnchor.constraint(equalTo: self.yearMonthButtonView.topAnchor),
            self.yearMonthLabel.bottomAnchor.constraint(equalTo: self.yearMonthButtonView.bottomAnchor),
            self.yearMonthLabel.leadingAnchor.constraint(equalTo: self.yearMonthButtonView.leadingAnchor),
            self.yearMonthLabel.trailingAnchor.constraint(equalTo: self.yearMonthButtonView.trailingAnchor)
        ])
        
        // nextMonthButton layout
        NSLayoutConstraint.activate([
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
            self.nextMonthButton.heightAnchor.constraint(equalToConstant: 21),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.yearMonthButtonView.trailingAnchor),
            self.nextMonthButton.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        // separatorLineView layout
        NSLayoutConstraint.activate([
            self.separatorLineView.topAnchor.constraint(equalTo: self.vacationSettingButtonView.bottomAnchor, constant: 16),
            self.separatorLineView.heightAnchor.constraint(equalToConstant: 1),
            self.separatorLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.separatorLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // numberOfVacationView layout
        NSLayoutConstraint.activate([
            self.numberOfVacationView.topAnchor.constraint(equalTo: self.separatorLineView.bottomAnchor, constant: 16),
            self.numberOfVacationView.heightAnchor.constraint(equalToConstant: 24),
            self.numberOfVacationView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.numberOfVacationView.widthAnchor.constraint(equalToConstant: 311)
        ])
        
        // numberOfVacationMarkLabel layout
        NSLayoutConstraint.activate([
            self.numberOfVacationMarkLabel.topAnchor.constraint(equalTo: self.numberOfVacationView.topAnchor),
            self.numberOfVacationMarkLabel.bottomAnchor.constraint(equalTo: self.numberOfVacationView.bottomAnchor),
            self.numberOfVacationMarkLabel.leadingAnchor.constraint(equalTo: self.numberOfVacationView.leadingAnchor),
        ])
        
        // numberOfVacationLabel layout
        NSLayoutConstraint.activate([
            self.numberOfVacationLabel.topAnchor.constraint(equalTo: self.numberOfVacationView.topAnchor),
            self.numberOfVacationLabel.bottomAnchor.constraint(equalTo: self.numberOfVacationView.bottomAnchor),
            self.numberOfVacationLabel.trailingAnchor.constraint(equalTo: self.numberOfVacationView.trailingAnchor)
        ])
//        self.numberOfVacationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        self.numberOfVacationLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // numberOfVacationButton layout
        NSLayoutConstraint.activate([
            self.numberOfVacationButton.topAnchor.constraint(equalTo: self.numberOfVacationLabel.topAnchor),
            self.numberOfVacationButton.bottomAnchor.constraint(equalTo: self.numberOfVacationLabel.bottomAnchor),
            self.numberOfVacationButton.leadingAnchor.constraint(equalTo: self.numberOfVacationLabel.leadingAnchor),
            self.numberOfVacationButton.trailingAnchor.constraint(equalTo: self.numberOfVacationLabel.trailingAnchor)
        ])
//        self.numberOfVacationButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        self.numberOfVacationButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // holidaysLabel layout
        NSLayoutConstraint.activate([
            self.holidaysLabel.topAnchor.constraint(equalTo: self.numberOfVacationView.bottomAnchor, constant: 32),
            self.holidaysLabel.heightAnchor.constraint(equalToConstant: 24),
            self.holidaysLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 43)
        ])
        
        // Day buttons view layout
        NSLayoutConstraint.activate([
            self.dayButtonsView.topAnchor.constraint(equalTo: self.holidaysLabel.bottomAnchor, constant: 32),
            self.dayButtonsView.heightAnchor.constraint(equalToConstant: 36),
            self.dayButtonsView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.dayButtonsView.widthAnchor.constraint(equalToConstant: 302)
        ])
        
        // Sunday button view layout
        NSLayoutConstraint.activate([
            self.sundayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.sundayButtonView.leadingAnchor.constraint(equalTo: self.dayButtonsView.leadingAnchor)
        ])
        
        // Moday button view layout
        NSLayoutConstraint.activate([
            self.mondayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.mondayButtonView.leadingAnchor.constraint(equalTo: self.sundayButtonView.trailingAnchor, constant: 20)
        ])
        
        // Tuesday button view layout
        NSLayoutConstraint.activate([
            self.tuesdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.tuesdayButtonView.leadingAnchor.constraint(equalTo: self.mondayButtonView.trailingAnchor, constant: 20)
        ])
        
        // Wednesday button view layout
        NSLayoutConstraint.activate([
            self.wednesdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.wednesdayButtonView.leadingAnchor.constraint(equalTo: self.tuesdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // Tursday button view layout
        NSLayoutConstraint.activate([
            self.thursdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.thursdayButtonView.leadingAnchor.constraint(equalTo: self.wednesdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // Friday button view layout
        NSLayoutConstraint.activate([
            self.fridayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.fridayButtonView.leadingAnchor.constraint(equalTo: self.thursdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // Saturday button view layout
        NSLayoutConstraint.activate([
            self.saturdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.saturdayButtonView.leadingAnchor.constraint(equalTo: self.fridayButtonView.trailingAnchor, constant: 20)
        ])
        
        // startButtonView layout
        NSLayoutConstraint.activate([
            self.startButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.startButtonView.heightAnchor.constraint(equalToConstant: UIWindow().safeAreaInsets.bottom + 60),
            self.startButtonView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.startButtonView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // startButtonLabel layout
        NSLayoutConstraint.activate([
            self.startButtonLabel.topAnchor.constraint(equalTo: self.startButtonView.topAnchor, constant: 17),
            self.startButtonLabel.heightAnchor.constraint(equalToConstant: 26),
            self.startButtonLabel.centerXAnchor.constraint(equalTo: self.startButtonView.centerXAnchor),
            self.startButtonLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        // startButton layout
        NSLayoutConstraint.activate([
            self.startButton.topAnchor.constraint(equalTo: self.startButtonView.topAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.startButtonView.bottomAnchor),
            self.startButton.leadingAnchor.constraint(equalTo: self.startButtonView.leadingAnchor),
            self.startButton.trailingAnchor.constraint(equalTo: self.startButtonView.trailingAnchor)
        ])
        
        // coverView layout
        NSLayoutConstraint.activate([
            self.coverView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.coverView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.coverView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.coverView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // settingVacationView layout
        NSLayoutConstraint.activate([
            self.settingVacationView.centerYAnchor.constraint(equalTo: self.coverView.centerYAnchor),
            self.settingVacationView.heightAnchor.constraint(equalToConstant: 300),
            self.settingVacationView.centerXAnchor.constraint(equalTo: self.coverView.centerXAnchor),
            self.settingVacationView.widthAnchor.constraint(equalToConstant: 311)
        ])
        
        // settingTitleLabel layout
        NSLayoutConstraint.activate([
            self.settingTitleLabel.topAnchor.constraint(equalTo: self.settingVacationView.topAnchor, constant: 22),
            self.settingTitleLabel.heightAnchor.constraint(equalToConstant: 22),
            self.settingTitleLabel.centerXAnchor.constraint(equalTo: self.settingVacationView.centerXAnchor),
            self.settingTitleLabel.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        // settingVacationButtonsView layout
        NSLayoutConstraint.activate([
            self.settingVacationButtonsView.topAnchor.constraint(equalTo: self.settingTitleLabel.bottomAnchor, constant: 32),
            self.settingVacationButtonsView.heightAnchor.constraint(equalToConstant: 28),
            self.settingVacationButtonsView.centerXAnchor.constraint(equalTo: self.settingVacationView.centerXAnchor),
            self.settingVacationButtonsView.widthAnchor.constraint(equalToConstant: 229)
        ])
        
        // fiscalYearButton layout
        NSLayoutConstraint.activate([
            self.fiscalYearButton.centerYAnchor.constraint(equalTo: self.settingVacationButtonsView.centerYAnchor),
            self.fiscalYearButton.heightAnchor.constraint(equalToConstant: 28),
            self.fiscalYearButton.leadingAnchor.constraint(equalTo: self.settingVacationButtonsView.leadingAnchor),
            self.fiscalYearButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // fiscalYearMarkLabel layout
        NSLayoutConstraint.activate([
            self.fiscalYearMarkLabel.topAnchor.constraint(equalTo: self.settingVacationButtonsView.topAnchor),
            self.fiscalYearMarkLabel.bottomAnchor.constraint(equalTo: self.settingVacationButtonsView.bottomAnchor),
            self.fiscalYearMarkLabel.leadingAnchor.constraint(equalTo: self.fiscalYearButton.trailingAnchor, constant: 5),
            self.fiscalYearMarkLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        // joiningDayButton layout
        NSLayoutConstraint.activate([
            self.joiningDayButton.centerYAnchor.constraint(equalTo: self.settingVacationButtonsView.centerYAnchor),
            self.joiningDayButton.heightAnchor.constraint(equalToConstant: 28),
            self.joiningDayButton.trailingAnchor.constraint(equalTo: self.joiningDayMarkLabel.leadingAnchor, constant: -5),
            self.joiningDayButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // joiningDayMarkLabel layout
        NSLayoutConstraint.activate([
            self.joiningDayMarkLabel.topAnchor.constraint(equalTo: self.settingVacationButtonsView.topAnchor),
            self.joiningDayMarkLabel.bottomAnchor.constraint(equalTo: self.settingVacationButtonsView.bottomAnchor),
            self.joiningDayMarkLabel.trailingAnchor.constraint(equalTo: self.settingVacationButtonsView.trailingAnchor),
            self.joiningDayMarkLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        // settingNumberOfTotalVacationView layout
        NSLayoutConstraint.activate([
            self.settingNumberOfTotalVacationView.topAnchor.constraint(equalTo: self.settingVacationButtonsView.bottomAnchor, constant: 48),
            self.settingNumberOfTotalVacationView.heightAnchor.constraint(equalToConstant: 48),
            self.settingNumberOfTotalVacationView.centerXAnchor.constraint(equalTo: self.settingVacationView.centerXAnchor),
            self.settingNumberOfTotalVacationView.widthAnchor.constraint(equalToConstant: 152)
        ])
        
        // minusButton layout
        NSLayoutConstraint.activate([
            self.minusButton.centerYAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.centerYAnchor),
            self.minusButton.heightAnchor.constraint(equalToConstant: 30),
            self.minusButton.leadingAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.leadingAnchor),
            self.minusButton.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        // numberOfTotalVacationsLabel layout
        NSLayoutConstraint.activate([
            self.numberOfTotalVacationsLabel.topAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.topAnchor),
            self.numberOfTotalVacationsLabel.bottomAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.bottomAnchor),
            self.numberOfTotalVacationsLabel.leadingAnchor.constraint(equalTo: self.minusButton.trailingAnchor),
            self.numberOfTotalVacationsLabel.trailingAnchor.constraint(equalTo: self.plusButton.leadingAnchor)
        ])
        
        // plusButton layout
        NSLayoutConstraint.activate([
            self.plusButton.centerYAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.centerYAnchor),
            self.plusButton.heightAnchor.constraint(equalToConstant: 30),
            self.plusButton.trailingAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.trailingAnchor),
            self.plusButton.widthAnchor.constraint(equalToConstant: 36)
        ])
        
        // Starting work time confirm button layout
        NSLayoutConstraint.activate([
            self.confirmButton.topAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.bottomAnchor, constant: 59),
            self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
            self.confirmButton.trailingAnchor.constraint(equalTo: self.settingVacationView.centerXAnchor, constant: -5),
            self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
        ])
        
        // Starting work time decline button layout layout
        NSLayoutConstraint.activate([
            self.declineButton.topAnchor.constraint(equalTo: self.settingNumberOfTotalVacationView.bottomAnchor, constant: 59),
            self.declineButton.heightAnchor.constraint(equalToConstant: 35),
            self.declineButton.leadingAnchor.constraint(equalTo: self.settingVacationView.centerXAnchor, constant: 5),
            self.declineButton.widthAnchor.constraint(equalToConstant: 97)
        ])
    }
}

// MARK: - Extension for methods added
extension DayOffViewController {
    func getVacationsHold() -> Double {
        // FIXME: from DB
        
        return 5.5
    }
}

// MARK: - Extension for Selector methods
extension DayOffViewController {
    @objc func vacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if let buttonView = sender.superview as? DayButtonView {
            buttonView.isSelected.toggle()
            
            if sender.tag == 1 {
                print("morning")
            }
            
            if sender.tag == 2{
                print("morning")
            }
        }
    }
    
    @objc func perviousMonthButton(_ sender: UIButton) {
        
    }
    
    @objc func nextMonthButton(_ sender: UIButton) {
        
    }
    
    @objc func numberOfVacationButton(_ sender: UIButton) {
        self.coverView.isHidden = false
    }
    
    @objc func holidayButtons(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if let buttonView = sender.superview as? DayButtonView {
            buttonView.isSelected.toggle()
            
            switch buttonView.day {
            case .sunday:
                print("sunday")
                
            case .monday:
                print("monday")
                
            case .tuesday:
                print("tuesday")
                
            case .wednesday:
                print("wednesday")
                
            case .thursday:
                print("thursday")
                
            case .friday:
                print("friday")
                
            case .saturday:
                print("saturday")
            }
        }
    }
    
    @objc func startButton(_ sender: UIButton) {
        
    }
    
    @objc func fiscalYearButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.joiningDayButton.isSelected = false
    }
    
    @objc func joiningDayButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.fiscalYearButton.isSelected = false
    }
    
    @objc func minusButton(_ sender: UIButton) {
        
    }
    
    @objc func plusButton(_ sender: UIButton) {
        
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        self.coverView.isHidden = true
    }
    
    @objc func declineButton(_ sender: UIButton) {
        self.coverView.isHidden = true
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension DayOffViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.firstWeekDay - 1 + self.daysOfMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        // FIXME: need to be edited
        if indexPath.item - (self.firstWeekDay - 2) >= 1 {
            item.dayLabel.isHidden = false
            
            if indexPath.item - (self.firstWeekDay - 2) == 27 {
                item.setItem(day: indexPath.item - (self.firstWeekDay - 2),
                             isToday: true,
                             isSelected: false,
                             .fullDayVacation)
                
            } else if indexPath.item - (self.firstWeekDay - 2) == 28 {
                item.setItem(day: indexPath.item - (self.firstWeekDay - 2),
                             isToday: false,
                             isSelected: true,
                             .morningVacation)
                
            } else if indexPath.item - (self.firstWeekDay - 2) == 29 {
                item.setItem(day: indexPath.item - (self.firstWeekDay - 2),
                             isToday: false,
                             isSelected: false,
                             .afternoonVacation)
                
            } else if indexPath.item - (self.firstWeekDay - 2) == 30 {
                item.setItem(day: indexPath.item - (self.firstWeekDay - 2),
                             isToday: true,
                             isSelected: true,
                             .fullDayVacation)
                
            } else {
                item.setItem(day: indexPath.item - (self.firstWeekDay - 2),
                             isToday: false,
                             isSelected: false)
            }
            
        } else {
            item.dayLabel.isHidden = true
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as! CalendarHeaderView
        
        return headerView
    }
}
