//
//  DayOffViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/04/04.
//

import UIKit
import RealmSwift

enum AnnualVacationType: String {
    case fiscalYear
    case joiningDay
}

class DayOffViewController: UIViewController {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.tag = 1
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 428 + 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate)))
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
        button.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
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
        let buttonView = VacationButtonView(title: "오전")
        buttonView.tag = 1
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.isEnable = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var afternoonVacationButtonView: VacationButtonView = {
        let buttonView = VacationButtonView(title: "오후")
        buttonView.tag = 2
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.isEnable = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var yearMonthButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "previousMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "previousMonthDisableButton"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(perviousMonthButton(_:)), for: .touchUpInside)
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).month)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)년 \(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month)월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nextMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "nextMonthDisableButton"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(nextMonthButton(_:)), for: .touchUpInside)
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).month)
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
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributedText = NSMutableAttributedString()
        let usedVacationText = NSAttributedString(string: "\(self.numberOfVacationsHold)일 |", attributes: [
            .font:UIFont.systemFont(ofSize: 16),
            .foregroundColor:UIColor.black,
            .paragraphStyle:paragraphStyle
        ])
        let totalOfVacationsText = NSAttributedString(string: " \(self.numberOfTotalVacations)일", attributes: [
            .font:UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor:UIColor.black,
            .paragraphStyle:paragraphStyle
        ])
        attributedText.append(usedVacationText)
        attributedText.append(totalOfVacationsText)
        
        let label = UILabel()
        label.attributedText = attributedText
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
        view.layer.useSketchShadow(color: .black, alpha: 1, x: 0, y: 1, blur: 4, spread: 0)
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
        button.isSelected = self.annualVactionType == .fiscalYear
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
        button.isSelected = self.annualVactionType == .joiningDay
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
    
    var targetYearMonthDate: Date = Date()
    
    var vacationScheduleDateRange: (startDate: Date, endDate: Date) = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        if SupportingMethods.shared.useAppSetting(for: .annualVacationType) as! String == AnnualVacationType.fiscalYear.rawValue {
            let firstDayOfYearDateComponents = DateComponents(year: todayDateComponents.year!, month: 1, day: 1)
            let lastDayOfYearDateComponents = DateComponents(year: todayDateComponents.year!, month: 12, day: 31)
            
            return (calendar.date(from: firstDayOfYearDateComponents)!, calendar.date(from: lastDayOfYearDateComponents)!)
            
        } else { // joiningDay
            var firstDayOfVacationDate = SupportingMethods.shared.useAppSetting(for: .joiningDate) as! Date
            let joiningDateComponents = calendar.dateComponents([.year, .month, .day], from: firstDayOfVacationDate)
            var endDayOfVacationDate: Date
            
            if joiningDateComponents.month! < todayDateComponents.month! {
                // First date of vacation
                let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                
                firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                
                // End date of vacation
                let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! + 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                
                endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                
            } else if joiningDateComponents.month! == todayDateComponents.month! {
                if joiningDateComponents.day! <= todayDateComponents.day! {
                    // First date of vacation
                    let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    
                    firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                    
                    // End date of vacation
                    let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! + 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                    
                    endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                    
                } else { // joiningDateComponents.day! > self.todayDateComponents.day!
                    // First date of vacation
                    let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! - 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    
                    firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                    
                    // End date of vacation
                    let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                    let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                    
                    endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
                }
                
            } else { // joiningDateComponents.month! > self.todayDateComponents.month!
                // First date of vacation
                let firstDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year! - 1, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                
                firstDayOfVacationDate = calendar.date(from: firstDayOfVacationDateDateComponents)!
                
                // End date of vacation
                let endDayAfterOneDayOfVacationDateDateComponents = DateComponents(year: todayDateComponents.year!, month: joiningDateComponents.month!, day: joiningDateComponents.day!)
                let endDayAfterOneDayOfVacationDate = calendar.date(from: endDayAfterOneDayOfVacationDateDateComponents)!
                
                endDayOfVacationDate = Date(timeIntervalSinceReferenceDate: endDayAfterOneDayOfVacationDate.timeIntervalSinceReferenceDate - 86400)
            }
            
            return (firstDayOfVacationDate, endDayOfVacationDate)
        }
    }()
    
    var calendarCollectionViewHeightAnchor: NSLayoutConstraint!
    var contentViewHeightAnchor: NSLayoutConstraint!
    var selectedIndexOfYearMonthAndDay: (year: Int, month: Int, day: Int)?
    
    var numberOfTotalVacations: Int = SupportingMethods.shared.useAppSetting(for: .numberOfTotalVacations) as! Int
    lazy var numberOfVacationsHold: Double = {
        // FIXME: from DB
        return 0
    }()
    
    var realmNotification: NotificationToken?
    
    lazy var results: Results<Vacation> = {
        let realm = try! Realm()
        let results = realm.objects(Vacation.self)
        
        return results
    }()
    
    var holidays: Set<Int> = [1,7]
    var annualVactionType: AnnualVacationType = {
        if let annualVacationType = SupportingMethods.shared.useAppSetting(for: .annualVacationType) as? String {
            if annualVacationType == AnnualVacationType.fiscalYear.rawValue {
                return .fiscalYear
                
            } else {
                return .joiningDay
            }
            
        } else {
            return .fiscalYear
        }
    }() {
        didSet {
            self.fiscalYearButton.isSelected = self.annualVactionType == .fiscalYear
            self.joiningDayButton.isSelected = self.annualVactionType == .joiningDay
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
    }
    
    override func viewDidLayoutSubviews() {
        self.startButtonView.layer.shadowOpacity = self.scrollView.contentSize.height - self.scrollView.frame.height > 0 ? 1 : 0
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
        self.realmNotification = self.results.observe({ [weak self] (changes: RealmCollectionChange) in
            guard let calendarCollectionView = self?.calendarCollectionView else { return }
            switch changes {
            case .initial(_):
                calendarCollectionView.reloadData()
                
            case .update(_, deletions: _, insertions: _, modifications: _):
                calendarCollectionView.reloadData()
                
//            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
//                calendarCollectionView.performBatchUpdates {
//                    if deletions.count > 0 {
//                        calendarCollectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
//                    }
//
//                    if insertions.count > 0 {
//                        calendarCollectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0)}))
//                    }
//
//                    if modifications.count > 0 {
//                        calendarCollectionView.reloadItems(at: modifications.map({IndexPath(row: $0, section: 0)}))
//                    }
//
//                } completion: { finished in
//                    // completion
//                }
                
            case .error(let error):
                fatalError("\(error.localizedDescription)")
            }
        })
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
            self.previousMonthButton,
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
        self.contentViewHeightAnchor = self.contentView.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height)
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentViewHeightAnchor,
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
        self.calendarCollectionViewHeightAnchor = self.calendarCollectionView.heightAnchor.constraint(equalToConstant: 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate)))
        NSLayoutConstraint.activate([
            self.calendarCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 32),
            self.calendarCollectionViewHeightAnchor,
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
            self.yearMonthButtonView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // perviousMonthButton layout
        NSLayoutConstraint.activate([
            self.previousMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
            self.previousMonthButton.heightAnchor.constraint(equalToConstant: 21),
            self.previousMonthButton.leadingAnchor.constraint(equalTo: self.yearMonthButtonView.leadingAnchor),
            self.previousMonthButton.widthAnchor.constraint(equalToConstant: 20)
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
            self.nextMonthButton.widthAnchor.constraint(equalToConstant: 20)
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
    
    func applyVacationsToLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributedText = NSMutableAttributedString()
        let usedVacationText = NSAttributedString(string: "\(self.numberOfVacationsHold)일 |", attributes: [
            .font:UIFont.systemFont(ofSize: 16),
            .foregroundColor:UIColor.black,
            .paragraphStyle:paragraphStyle
        ])
        let totalOfVacationsText = NSAttributedString(string: " \(self.numberOfTotalVacations)일", attributes: [
            .font:UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor:UIColor.black,
            .paragraphStyle:paragraphStyle
        ])
        attributedText.append(usedVacationText)
        attributedText.append(totalOfVacationsText)
        
        self.numberOfVacationLabel.attributedText = attributedText
    }
}

// MARK: - Extension for Selector methods
extension DayOffViewController {
    @objc func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if let buttonView = sender.superview as? VacationButtonView {
            buttonView.isSelected.toggle()
            
            let realm = try! Realm()
            var vacation: Vacation!
            
            if buttonView.tag == 1 {
                print("morning")
                
                if buttonView.isSelected {
                    if self.afternoonVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .fullDay)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .morning)
                    }
                    
                } else {
                    if self.afternoonVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .afternoon)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .none)
                    }
                }
                
            } else {
                print("afternoon")
                
                if buttonView.isSelected {
                    if self.morningVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .fullDay)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .afternoon)
                    }
                    
                } else {
                    if self.morningVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .morning)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .none)
                    }
                }
            }
            
            try! realm.write {
                realm.add(vacation, update: .modified)
            }
        }
    }
    
    @objc func perviousMonthButton(_ sender: UIButton) {
        var year = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year
        var month = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month
        
        month -= 1
        if month == 0 {
            year -= 1
            month = 12
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 428 + 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate)))
        self.contentViewHeightAnchor.constant = 428 + 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate))
        self.calendarCollectionViewHeightAnchor.constant = 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate))
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)년 \(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month)월"
        
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).month)
        
        UIDevice.lightHaptic()
    }
    
    @objc func nextMonthButton(_ sender: UIButton) {
        var year = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year
        var month = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month
        
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width,
                                        height: 428 + 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate)))
        self.contentViewHeightAnchor.constant = 428 + 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate))
        self.calendarCollectionViewHeightAnchor.constant = 21+45*CGFloat(SupportingMethods.shared.getWeeksOfMonthFor(self.targetYearMonthDate))
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)년 \(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month)월"
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).month)
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).month)
        
        UIDevice.lightHaptic()
    }
    
    @objc func numberOfVacationButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.numberOfTotalVacationsLabel.text = "\(self.numberOfTotalVacations)"
        
        self.coverView.isHidden = false
    }
    
    @objc func holidayButtons(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if let buttonView = sender.superview as? DayButtonView {
            buttonView.isSelected.toggle()
            
            switch buttonView.day {
            case .sunday:
                if buttonView.isSelected {
                    self.holidays.insert(1)
                    print("sunday on")
                    
                } else {
                    self.holidays.remove(1)
                    print("sunday off")
                }
                
            case .monday:
                if buttonView.isSelected {
                    self.holidays.insert(2)
                    print("monday on")
                    
                } else {
                    self.holidays.remove(2)
                    print("monday off")
                }
                
            case .tuesday:
                if buttonView.isSelected {
                    self.holidays.insert(3)
                    print("tuesday on")
                    
                } else {
                    self.holidays.remove(3)
                    print("tuesday off")
                }
                
            case .wednesday:
                if buttonView.isSelected {
                    self.holidays.insert(4)
                    print("wednesday on")
                    
                } else {
                    self.holidays.remove(4)
                    print("wednesday off")
                }
                
            case .thursday:
                if buttonView.isSelected {
                    self.holidays.insert(5)
                    print("thursday on")
                    
                } else {
                    self.holidays.remove(5)
                    print("thursday off")
                }
                
            case .friday:
                if buttonView.isSelected {
                    self.holidays.insert(6)
                    print("friday on")
                    
                } else {
                    self.holidays.remove(6)
                    print("friday off")
                }
                
            case .saturday:
                if buttonView.isSelected {
                    self.holidays.insert(7)
                    print("saturday on")
                    
                } else {
                    self.holidays.remove(7)
                    print("saturday off")
                }
            }
        }
    }
    
    @objc func startButton(_ sender: UIButton) {
        let mainVC = MainViewController()
        let mainNaviVC = CustomizedNavigationController(rootViewController: mainVC)
        mainNaviVC.modalPresentationStyle = .fullScreen
        
        self.present(mainNaviVC, animated: true)
    }
    
    @objc func fiscalYearButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.annualVactionType = .fiscalYear
    }
    
    @objc func joiningDayButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.annualVactionType = .joiningDay
    }
    
    @objc func minusButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.numberOfTotalVacations -= 1
        
        self.minusButton.isEnabled = Double(self.numberOfTotalVacations - 1) >= self.numberOfVacationsHold
        self.numberOfTotalVacationsLabel.text = "\(self.numberOfTotalVacations)"
    }
    
    @objc func plusButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.numberOfTotalVacations += 1
        
        self.minusButton.isEnabled = Double(self.numberOfTotalVacations - 1) >= self.numberOfVacationsHold
        self.numberOfTotalVacationsLabel.text = "\(self.numberOfTotalVacations)"
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        SupportingMethods.shared.setAppSetting(with: self.numberOfTotalVacations, for: .numberOfTotalVacations)
        
        self.applyVacationsToLabel()
        
        self.coverView.isHidden = true
    }
    
    @objc func declineButton(_ sender: UIButton) {
        self.numberOfTotalVacations = SupportingMethods.shared.useAppSetting(for: .numberOfTotalVacations) as! Int
        
        self.coverView.isHidden = true
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension DayOffViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // weekday of 1st - 1 + days of month -> full items
        return SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 1 + SupportingMethods.shared.getDaysOfMonthFor(self.targetYearMonthDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        
        if day >= 1 {
            let dateId: String = String(format: "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)%02d%02d", SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, day)
            
            let isToday: Bool = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == self.todayDateComponents.year! &&
            SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == self.todayDateComponents.month! &&
            day == self.todayDateComponents.day!
            
            var isSelected = false
            if let selectedIndexOfYearMonthAndDay = self.selectedIndexOfYearMonthAndDay {
            isSelected = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == selectedIndexOfYearMonthAndDay.year &&
                SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == selectedIndexOfYearMonthAndDay.month &&
                day == selectedIndexOfYearMonthAndDay.day
            }
            
            let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
            let isEnable = dateOfDay >= self.vacationScheduleDateRange.startDate && dateOfDay <= self.vacationScheduleDateRange.endDate
            
            let realm = try! Realm()
            let vaction: Vacation? = realm.object(ofType: Vacation.self, forPrimaryKey: dateId)
            
            item.setItem(dateId,
                         day: day,
                         isToday: isToday,
                         isSelected: isSelected,
                         isEnable: isEnable,
                         vacationType: vaction == nil ?
                         VacationType.none : VacationType(rawValue: vaction!.vacationType))
            
        } else {
            item.setItem(nil)
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderView", for: indexPath) as! CalendarHeaderView
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
        
        guard dateOfDay >= self.vacationScheduleDateRange.startDate && dateOfDay <= self.vacationScheduleDateRange.endDate else {
            return
        }
        
        UIDevice.lightHaptic()
        
        self.selectedIndexOfYearMonthAndDay = (SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year,
                                               SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month,
                                               day)
        
        self.morningVacationButtonView.isEnable = true
        self.afternoonVacationButtonView.isEnable = true
        
        // Determine vacation button state
        let dateId: String = String(format: "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)%02d%02d", SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, day)
        
        let realm = try! Realm()
        if let vaction = realm.object(ofType: Vacation.self, forPrimaryKey: dateId) {
            switch VacationType(rawValue: vaction.vacationType)! {
            case .none:
                self.morningVacationButtonView.isSelected = false
                self.afternoonVacationButtonView.isSelected = false
                
            case .morning:
                self.morningVacationButtonView.isSelected = true
                self.afternoonVacationButtonView.isSelected = false
                
            case .afternoon:
                self.morningVacationButtonView.isSelected = false
                self.afternoonVacationButtonView.isSelected = true
                
            case .fullDay:
                self.morningVacationButtonView.isSelected = true
                self.afternoonVacationButtonView.isSelected = true
            }
            
        } else {
            self.morningVacationButtonView.isSelected = false
            self.afternoonVacationButtonView.isSelected = false
        }
        
        collectionView.reloadData()
    }
}

// MARK: Extension for UIScrollViewDelegate
extension DayOffViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            self.startButtonView.layer.shadowOpacity = scrollView.contentSize.height - scrollView.frame.height > scrollView.contentOffset.y ? 1 : 0
        }
    }
}
