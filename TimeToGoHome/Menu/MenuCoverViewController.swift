//
//  MenuCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/19.
//

import UIKit

enum MenuCoverRegularWorkType {
    case fullWork
    case halfWork
}

enum MenuCoverType {
    case lastDateAtWork
    case addNormalSchedule(NormalButtonType)
    case insertNormalSchedule(ScheduleType, NormalButtonType)
    case overtime(regularWork: MenuCoverRegularWorkType, overtime: Int?)
    case annualPaidHolidays(numberOfAnnualPaidHolidays: Int)
    case careerManagement
    case calendarOfScheduleRecord(company: Company)
}

protocol MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date)
    func menuCoverDidDetermineAddNormalSchedule(_ workTimeType: WorkTimeType)
    func menuCoverDidDetermineInsertNormalSchedule(_ scheduleType: ScheduleType)
    func menuCoverDidDetermineOvertimeSeconds(_ overtimeSeconds: Int)
    func menuCoverDidDetermineAnnualPaidHolidays(_ holidays: Int)
    func menuCoverDidDetermineCompany(_ company:String, joiningDate: Date, leavingDate: Date)
    func menuCoverDidDetermineSelectedDate(_ date: Date)
}

// Extension for Optional function effect
extension MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date) {}
    func menuCoverDidDetermineAddNormalSchedule(_ workTimeType: WorkTimeType) {}
    func menuCoverDidDetermineInsertNormalSchedule(_ scheduleType: ScheduleType) {}
    func menuCoverDidDetermineOvertimeSeconds(_ overtimeSeconds: Int) {}
    func menuCoverDidDetermineAnnualPaidHolidays(_ holidays: Int) {}
    func menuCoverDidDetermineCompany(_ company:String, joiningDate: Date, leavingDate: Date) {}
    func menuCoverDidDetermineSelectedDate(_ date: Date) {}
}

class MenuCoverViewController: UIViewController {
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: Date picker
    lazy var popUpPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        if case .lastDateAtWork = self.menuCoverType {
            label.text = "근무 마지막 날"
        }
        if case .addNormalSchedule = self.menuCoverType {
            label.text = "일정 추가"
        }
        if case .insertNormalSchedule = self.menuCoverType {
            label.text = "일정 변경"
        }
        if case .overtime = self.menuCoverType {
            label.text = "추가 근무 시간"
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        if case .lastDateAtWork = self.menuCoverType {
            datePicker.datePickerMode = .date
        }
        if case .careerManagement = self.menuCoverType {
            datePicker.datePickerMode = .date
        }
        if case .overtime(_, let overtime) = self.menuCoverType {
            datePicker.datePickerMode = .countDownTimer
        }
        datePicker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
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
    
    // MARK: Schedule buttons
    lazy var normalScheduleListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var workButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .useRGB(red: 125, green: 243, blue: 110)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("근무", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(workButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var vacationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .useRGB(red: 120, green: 223, blue: 238)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.useRGB(red: 200, green: 200, blue: 200), for: .disabled)
        button.setTitle("휴가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var holidayButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .useRGB(red: 252, green: 247, blue: 143)
        button.setTitleColor(.useRGB(red: 130, green: 130, blue: 130), for: .normal)
        button.setTitleColor(.useRGB(red: 200, green: 200, blue: 200), for: .disabled)
        button.setTitle("휴일", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(holidayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var closeNormalScheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeNormalSchedulePopUpPanelButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(closeNormalScheduleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: Annual paid holidays
    var annualPaidHolidaysView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20 // FIXME: Need to check cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var annualPaidHolidaysMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.text = "연차 개수"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var annualPaidHolidaysPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var dayMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var cancelApplyingAnnualPaidHolidaysButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.addTarget(self, action: #selector(cancelApplyingAnnualPaidHolidaysButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var applyAnnualPaidHolidaysButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.addTarget(self, action: #selector(applyAnnualPaidHolidaysButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var annualPaidHolidays: [Int] = Array(1...25)
    
    var numberOfAnnualPaidHolidays: Int?
    
    // MARK: Career management
    lazy var careerBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var companyNameMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "회사 이름"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var companyNameTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .black
        textField.placeholder = "회사 이름을 입력하세요."
        textField.clearButtonMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    lazy var companyNameBottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var joiningDateMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "입사 일자"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningDateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var joiningYearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningYearLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var joiningMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningMonthLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var joiningDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningDayLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var joiningDateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(joiningDateButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var selectJoiningDateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var selectJoiningDateMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.text = "날짜를 선택해 주세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var selectJoiningDateMarkLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var selectJoiningDateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectJoiningDateButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var leavingDateMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = "퇴사 일자"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leavingDateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var leavingYearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leavingYearLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var leavingMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leavingMonthLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var leavingDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leavingDayLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var leavingDateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(leavingDateButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var selectLeavingDateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var selectLeavingDateMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.text = "날짜를 선택해 주세요."
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var selectLeavingDateMarkLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var selectLeavingDateButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(selectLeavingDateButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var cancelCareerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(cancelCareerButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var addCareerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(addCareerButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var joiningDate: Date? = nil {
        didSet {
            if let date = self.joiningDate {
                let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
                
                self.joiningYearLabel.text = "\(yearMonthDay.year)"
                self.joiningMonthLabel.text = "\(yearMonthDay.month)"
                self.joiningDayLabel.text = "\(yearMonthDay.day)"
                
                self.selectJoiningDateView.isHidden = true
                self.joiningDateView.isHidden = false
                
            } else {
                self.selectJoiningDateView.isHidden = false
                self.joiningDateView.isHidden = true
            }
        }
    }
    
    var leavingDate: Date? = nil {
        didSet {
            if let date = self.leavingDate {
                let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
                
                self.leavingYearLabel.text = "\(yearMonthDay.year)"
                self.leavingMonthLabel.text = "\(yearMonthDay.month)"
                self.leavingDayLabel.text = "\(yearMonthDay.day)"
                
                self.selectLeavingDateView.isHidden = true
                self.leavingDateView.isHidden = false
                
            } else {
                self.selectLeavingDateView.isHidden = false
                self.leavingDateView.isHidden = true
            }
        }
    }
    
    // MARK: Calendar of schedule record
    lazy var calendarBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange!.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange!.startDate).month)
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
        label.text = "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).year)년 \(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).month)월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nextMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "nextMonthDisableButton"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(nextMonthButton(_:)), for: .touchUpInside)
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate ?? Date()).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange!.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange!.endDate).month)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        collectionView.register(CalendarDayOfScheduleRecordCell.self, forCellWithReuseIdentifier: "CalendarDayOfScheduleRecordCell")
        collectionView.register(CalendarHeaderOfScheduleRecordView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderOfScheduleRecordView")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    var targetYearMonthDate: Date?
    var careerDateRange: (startDate: Date, endDate: Date)?
    
    let menuCoverType: MenuCoverType
    private var delegate: MenuCoverDelegate?
    
    init(_ menuCoverType: MenuCoverType, delegate: MenuCoverDelegate?) {
        self.delegate = delegate
        self.menuCoverType = menuCoverType
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        
        self.initializeValueRelatedToMenuCoverType(self.menuCoverType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initializeAnnualPaidHolidaysOnPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeCountDownDuration()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- MenuCoverViewController disposed -----------------------------------")
    }

}

// MARK: - Extension for essential methods
extension MenuCoverViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    func initializeObjects() {
        switch self.menuCoverType {
        case .lastDateAtWork:
            self.datePicker.minimumDate = ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as? Date
            //self.datePicker.maximumDate = Date()
            
        case .addNormalSchedule(let normalButtonType): // MARK: addNormalSchedule
            switch normalButtonType {
            case .allButton:
                print("All buttons are available")
                self.workButton.isEnabled = true
                self.vacationButton.isEnabled = true
                self.holidayButton.isEnabled = true
                
            case .vacation:
                print("Work and vacation are available")
                self.workButton.isEnabled = true
                self.holidayButton.backgroundColor = .useRGB(red: 241, green: 241, blue: 241)
                self.holidayButton.isEnabled = false
                self.vacationButton.isEnabled = true
                
            case .holiday:
                print("Work and holiday are available")
                self.workButton.isEnabled = true
                self.vacationButton.backgroundColor = .useRGB(red: 241, green: 241, blue: 241)
                self.vacationButton.isEnabled = false
                self.holidayButton.isEnabled = true
            }
            
        case .insertNormalSchedule(_, let normalButtonType): // MARK: insertNormalSchedule
            switch normalButtonType {
            case .allButton:
                print("All buttons are available")
                self.workButton.isEnabled = true
                self.vacationButton.isEnabled = true
                self.holidayButton.isEnabled = true
                
            case .vacation:
                print("Work and vacation are available")
                self.workButton.isEnabled = true
                self.holidayButton.backgroundColor = .useRGB(red: 241, green: 241, blue: 241)
                self.holidayButton.isEnabled = false
                self.vacationButton.isEnabled = true
                
            case .holiday:
                print("Work and holiday are available")
                self.workButton.isEnabled = true
                self.vacationButton.backgroundColor = .useRGB(red: 241, green: 241, blue: 241)
                self.vacationButton.isEnabled = false
                self.holidayButton.isEnabled = true
            }
            
        case .overtime: // MARK: overtime
            print("")
            
        case .annualPaidHolidays: // MARK: annualPaidHolidays
            print("")
            
        case .careerManagement: // MARK: careerManagement
            print("")
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            print("")
        }
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView
        ], to: self.view)
        
        switch self.menuCoverType {
        case .lastDateAtWork: // MARK: lastDateAtWork
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .addNormalSchedule, .insertNormalSchedule: // MARK: addNormalSchedule, addNormalSchedule
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.normalScheduleListView
            ], to: self.popUpPanelView)
            
            SupportingMethods.shared.addSubviews([
                self.workButton,
                self.vacationButton,
                self.holidayButton,
                self.closeNormalScheduleButton
            ], to: self.normalScheduleListView)
            
        case .overtime: // MARK: overtime
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .annualPaidHolidays: // MARK: annualPaidHolidays
            SupportingMethods.shared.addSubviews([
                self.annualPaidHolidaysView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.annualPaidHolidaysMarkLabel,
                self.annualPaidHolidaysPickerView,
                self.cancelApplyingAnnualPaidHolidaysButton,
                self.applyAnnualPaidHolidaysButton,
            ], to: self.annualPaidHolidaysView)
            
            SupportingMethods.shared.addSubviews([
                self.dayMarkLabel
            ], to: self.annualPaidHolidaysPickerView)
            
        case .careerManagement: // MARK: careerManagement
            SupportingMethods.shared.addSubviews([
                self.careerBaseView,
                self.popUpPanelView
            ], to: self.baseView)
            
            // careerBaseView
            SupportingMethods.shared.addSubviews([
                self.companyNameMarkLabel,
                self.companyNameTextField,
                self.companyNameBottomLineView,
                self.joiningDateMarkLabel,
                self.joiningDateView,
                self.selectJoiningDateView,
                self.leavingDateMarkLabel,
                self.leavingDateView,
                self.selectLeavingDateView,
                self.cancelCareerButton,
                self.addCareerButton
            ], to: self.careerBaseView)
            
            SupportingMethods.shared.addSubviews([
                self.joiningYearLabel,
                self.joiningYearLineView,
                self.joiningMonthLabel,
                self.joiningMonthLineView,
                self.joiningDayLabel,
                self.joiningDayLineView,
                self.joiningDateButton
            ], to: self.joiningDateView)
            
            SupportingMethods.shared.addSubviews([
                self.selectJoiningDateMarkLabel,
                self.selectJoiningDateMarkLineView,
                self.selectJoiningDateButton
            ], to: self.selectJoiningDateView)
            
            SupportingMethods.shared.addSubviews([
                self.leavingYearLabel,
                self.leavingYearLineView,
                self.leavingMonthLabel,
                self.leavingMonthLineView,
                self.leavingDayLabel,
                self.leavingDayLineView,
                self.leavingDateButton
            ], to: self.leavingDateView)
            
            SupportingMethods.shared.addSubviews([
                self.selectLeavingDateMarkLabel,
                self.selectLeavingDateMarkLineView,
                self.selectLeavingDateButton
            ], to: self.selectLeavingDateView)
            
            // popUpPanelView
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            SupportingMethods.shared.addSubviews([
                
            ], to: self.baseView)
        }
    }
    
    func setLayouts() {
        // baseView
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        switch self.menuCoverType {
        case .lastDateAtWork: // MARK: lastDateAtWork
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // titleLabel
            NSLayoutConstraint.activate([
                self.titleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
                self.titleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.titleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // datePicker
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // confirmButton
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // declineButton
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
        case .addNormalSchedule, .insertNormalSchedule: // MARK: addNormalSchedule, insertNormalSchedule
            // normalScheduleListView
            NSLayoutConstraint.activate([
                self.normalScheduleListView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
                self.normalScheduleListView.heightAnchor.constraint(equalToConstant: 179),
                self.normalScheduleListView.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 25),
                self.normalScheduleListView.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -25)
            ])
            
            // closeNormalScheduleButton
            NSLayoutConstraint.activate([
                self.closeNormalScheduleButton.topAnchor.constraint(equalTo: self.normalScheduleListView.bottomAnchor, constant: 16),
                self.closeNormalScheduleButton.heightAnchor.constraint(equalToConstant: 28),
                self.closeNormalScheduleButton.centerXAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor),
                self.closeNormalScheduleButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // workButton
            NSLayoutConstraint.activate([
                self.workButton.topAnchor.constraint(equalTo: self.normalScheduleListView.topAnchor),
                self.workButton.heightAnchor.constraint(equalToConstant: 55),
                self.workButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.workButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // vacationButton
            NSLayoutConstraint.activate([
                self.vacationButton.topAnchor.constraint(equalTo: self.workButton.bottomAnchor, constant: 7),
                self.vacationButton.heightAnchor.constraint(equalToConstant: 55),
                self.vacationButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.vacationButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // holidayButton
            NSLayoutConstraint.activate([
                self.holidayButton.topAnchor.constraint(equalTo: self.vacationButton.bottomAnchor, constant: 7),
                self.holidayButton.heightAnchor.constraint(equalToConstant: 55),
                self.holidayButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.holidayButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
        case .overtime: // MARK: overtime
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // titleLabel
            NSLayoutConstraint.activate([
                self.titleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
                self.titleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.titleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // datePicker
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // confirmButton
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // declineButton
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
        case .annualPaidHolidays: // MARK: annualPaidHolidays
            // annualPaidHolidaysView
            NSLayoutConstraint.activate([
                self.annualPaidHolidaysView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.annualPaidHolidaysView.heightAnchor.constraint(equalToConstant: 250),
                self.annualPaidHolidaysView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.annualPaidHolidaysView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // annualPaidHolidaysMarkLabel
            NSLayoutConstraint.activate([
                self.annualPaidHolidaysMarkLabel.topAnchor.constraint(equalTo: self.annualPaidHolidaysView.topAnchor, constant: 15),
                self.annualPaidHolidaysMarkLabel.leadingAnchor.constraint(equalTo: self.annualPaidHolidaysView.leadingAnchor, constant: 25)
            ])
            
            // annualPaidHolidaysPickerView
            NSLayoutConstraint.activate([
                self.annualPaidHolidaysPickerView.topAnchor.constraint(equalTo: self.annualPaidHolidaysMarkLabel.bottomAnchor),
                self.annualPaidHolidaysPickerView.bottomAnchor.constraint(equalTo: self.applyAnnualPaidHolidaysButton.topAnchor),
                self.annualPaidHolidaysPickerView.leadingAnchor.constraint(equalTo: self.annualPaidHolidaysView.leadingAnchor),
                self.annualPaidHolidaysPickerView.trailingAnchor.constraint(equalTo: self.annualPaidHolidaysView.trailingAnchor)
            ])
            
            // dayMarkLabel
            NSLayoutConstraint.activate([
                self.dayMarkLabel.centerYAnchor.constraint(equalTo: self.annualPaidHolidaysPickerView.centerYAnchor),
                self.dayMarkLabel.leadingAnchor.constraint(equalTo: self.annualPaidHolidaysPickerView.centerXAnchor, constant: 20)
            ])
            
            // cancelApplyingAnnualPaidHolidaysButton
            NSLayoutConstraint.activate([
                self.cancelApplyingAnnualPaidHolidaysButton.bottomAnchor.constraint(equalTo: self.annualPaidHolidaysView.bottomAnchor, constant: -10),
                self.cancelApplyingAnnualPaidHolidaysButton.heightAnchor.constraint(equalToConstant: 28),
                self.cancelApplyingAnnualPaidHolidaysButton.trailingAnchor.constraint(equalTo: self.annualPaidHolidaysView.centerXAnchor, constant: -60),
                self.cancelApplyingAnnualPaidHolidaysButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // applyAnnualPaidHolidaysButton
            NSLayoutConstraint.activate([
                self.applyAnnualPaidHolidaysButton.bottomAnchor.constraint(equalTo: self.annualPaidHolidaysView.bottomAnchor, constant: -10),
                self.applyAnnualPaidHolidaysButton.heightAnchor.constraint(equalToConstant: 28),
                self.applyAnnualPaidHolidaysButton.leadingAnchor.constraint(equalTo: self.annualPaidHolidaysView.centerXAnchor, constant: 60),
                self.applyAnnualPaidHolidaysButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
        case .careerManagement: // MARK: careerManagement
            // careerBaseView
            NSLayoutConstraint.activate([
                self.careerBaseView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.careerBaseView.heightAnchor.constraint(equalToConstant: 311),
                self.careerBaseView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.careerBaseView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // companyNameMarkLabel
            NSLayoutConstraint.activate([
                self.companyNameMarkLabel.topAnchor.constraint(equalTo: self.careerBaseView.topAnchor, constant: 21),
                self.companyNameMarkLabel.heightAnchor.constraint(equalToConstant: 21),
                self.companyNameMarkLabel.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 21)
            ])
            
            // companyNameTextField
            NSLayoutConstraint.activate([
                self.companyNameTextField.bottomAnchor.constraint(equalTo: self.companyNameBottomLineView.topAnchor),
                self.companyNameTextField.heightAnchor.constraint(equalToConstant: 21),
                self.companyNameTextField.leadingAnchor.constraint(equalTo: self.companyNameBottomLineView.leadingAnchor, constant: 7),
                self.companyNameTextField.trailingAnchor.constraint(equalTo: self.companyNameBottomLineView.trailingAnchor, constant: -5)
            ])
            
            // companyNameBottomLineView
            NSLayoutConstraint.activate([
                self.companyNameBottomLineView.topAnchor.constraint(equalTo: self.companyNameMarkLabel.bottomAnchor, constant: 32),
                self.companyNameBottomLineView.heightAnchor.constraint(equalToConstant: 2),
                self.companyNameBottomLineView.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 20),
                self.companyNameBottomLineView.trailingAnchor.constraint(equalTo: self.careerBaseView.trailingAnchor, constant: -23)
            ])
            
            // joiningDateMarkLabel
            NSLayoutConstraint.activate([
                self.joiningDateMarkLabel.topAnchor.constraint(equalTo: self.companyNameBottomLineView.bottomAnchor, constant: 24),
                self.joiningDateMarkLabel.heightAnchor.constraint(equalToConstant: 22),
                self.joiningDateMarkLabel.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 21)
            ])
            
            // joiningDateView
            NSLayoutConstraint.activate([
                self.joiningDateView.topAnchor.constraint(equalTo: self.joiningDateMarkLabel.bottomAnchor, constant: 13),
                self.joiningDateView.heightAnchor.constraint(equalToConstant: 28),
                self.joiningDateView.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 22),
                self.joiningDateView.widthAnchor.constraint(equalToConstant: 150)
            ])
            
            // joiningYearLabel
            NSLayoutConstraint.activate([
                self.joiningYearLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
                self.joiningYearLabel.heightAnchor.constraint(equalToConstant: 25),
                self.joiningYearLabel.leadingAnchor.constraint(equalTo: self.joiningDateView.leadingAnchor)
            ])
            
            // joiningYearLineView
            NSLayoutConstraint.activate([
                self.joiningYearLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
                self.joiningYearLineView.heightAnchor.constraint(equalToConstant: 1),
                self.joiningYearLineView.leadingAnchor.constraint(equalTo: self.joiningYearLabel.leadingAnchor),
                self.joiningYearLineView.trailingAnchor.constraint(equalTo: self.joiningYearLabel.trailingAnchor)
            ])
            
            // joiningMonthLabel
            NSLayoutConstraint.activate([
                self.joiningMonthLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
                self.joiningMonthLabel.heightAnchor.constraint(equalToConstant: 25),
                self.joiningMonthLabel.leadingAnchor.constraint(equalTo: self.joiningYearLabel.trailingAnchor, constant: 12.5)
            ])
            
            // joiningMonthLineView
            NSLayoutConstraint.activate([
                self.joiningMonthLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
                self.joiningMonthLineView.heightAnchor.constraint(equalToConstant: 1),
                self.joiningMonthLineView.leadingAnchor.constraint(equalTo: self.joiningMonthLabel.leadingAnchor),
                self.joiningMonthLineView.trailingAnchor.constraint(equalTo: self.joiningMonthLabel.trailingAnchor)
            ])
            
            // joiningDayLabel
            NSLayoutConstraint.activate([
                self.joiningDayLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
                self.joiningDayLabel.heightAnchor.constraint(equalToConstant: 25),
                self.joiningDayLabel.leadingAnchor.constraint(equalTo: self.joiningMonthLabel.trailingAnchor, constant: 12.5)
            ])
            
            // joiningDayLineView
            NSLayoutConstraint.activate([
                self.joiningDayLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
                self.joiningDayLineView.heightAnchor.constraint(equalToConstant: 1),
                self.joiningDayLineView.leadingAnchor.constraint(equalTo: self.joiningDayLabel.leadingAnchor),
                self.joiningDayLineView.trailingAnchor.constraint(equalTo: self.joiningDayLabel.trailingAnchor)
            ])
            
            // joiningDateButton
            NSLayoutConstraint.activate([
                self.joiningDateButton.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
                self.joiningDateButton.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
                self.joiningDateButton.leadingAnchor.constraint(equalTo: self.joiningDateView.leadingAnchor),
                self.joiningDateButton.trailingAnchor.constraint(equalTo: self.joiningDateView.trailingAnchor)
            ])
            
            // selectJoiningDateView
            NSLayoutConstraint.activate([
                self.selectJoiningDateView.topAnchor.constraint(equalTo: self.joiningDateMarkLabel.bottomAnchor, constant: 13),
                self.selectJoiningDateView.heightAnchor.constraint(equalToConstant: 28),
                self.selectJoiningDateView.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 22),
                self.selectJoiningDateView.widthAnchor.constraint(equalToConstant: 150) // FIXME: Need to confirm
            ])
            
            // selectJoiningDateMarkLabel
            NSLayoutConstraint.activate([
                self.selectJoiningDateMarkLabel.topAnchor.constraint(equalTo: self.selectJoiningDateView.topAnchor),
                self.selectJoiningDateMarkLabel.heightAnchor.constraint(equalToConstant: 25),
                self.selectJoiningDateMarkLabel.leadingAnchor.constraint(equalTo: self.selectJoiningDateView.leadingAnchor)
            ])
            
            // selectJoiningDateMarkLineView
            NSLayoutConstraint.activate([
                self.selectJoiningDateMarkLineView.bottomAnchor.constraint(equalTo: self.selectJoiningDateView.bottomAnchor),
                self.selectJoiningDateMarkLineView.heightAnchor.constraint(equalToConstant: 1),
                self.selectJoiningDateMarkLineView.leadingAnchor.constraint(equalTo: selectJoiningDateMarkLabel.leadingAnchor),
                self.selectJoiningDateMarkLineView.trailingAnchor.constraint(equalTo: self.selectJoiningDateMarkLabel.trailingAnchor)
            ])
            
            // selectJoiningDateButton
            NSLayoutConstraint.activate([
                self.selectJoiningDateButton.topAnchor.constraint(equalTo: self.selectJoiningDateView.topAnchor),
                self.selectJoiningDateButton.bottomAnchor.constraint(equalTo: self.selectJoiningDateView.bottomAnchor),
                self.selectJoiningDateButton.leadingAnchor.constraint(equalTo: self.selectJoiningDateView.leadingAnchor),
                self.selectJoiningDateButton.trailingAnchor.constraint(equalTo: self.selectJoiningDateView.trailingAnchor)
            ])
            
            // leavingDateMarkLabel
            NSLayoutConstraint.activate([
                self.leavingDateMarkLabel.topAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor, constant: 13),
                self.leavingDateMarkLabel.heightAnchor.constraint(equalToConstant: 22),
                self.leavingDateMarkLabel.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 21)
            ])
            
            // leavingDateView
            NSLayoutConstraint.activate([
                self.leavingDateView.topAnchor.constraint(equalTo: self.leavingDateMarkLabel.bottomAnchor, constant: 13),
                self.leavingDateView.heightAnchor.constraint(equalToConstant: 28),
                self.leavingDateView.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 22),
                self.leavingDateView.widthAnchor.constraint(equalToConstant: 150)
            ])
            
            // leavingYearLabel
            NSLayoutConstraint.activate([
                self.leavingYearLabel.topAnchor.constraint(equalTo: self.leavingDateView.topAnchor),
                self.leavingYearLabel.heightAnchor.constraint(equalToConstant: 25),
                self.leavingYearLabel.leadingAnchor.constraint(equalTo: self.leavingDateView.leadingAnchor)
            ])
            
            // leavingYearLineView
            NSLayoutConstraint.activate([
                self.leavingYearLineView.bottomAnchor.constraint(equalTo: self.leavingDateView.bottomAnchor),
                self.leavingYearLineView.heightAnchor.constraint(equalToConstant: 1),
                self.leavingYearLineView.leadingAnchor.constraint(equalTo: self.leavingYearLabel.leadingAnchor),
                self.leavingYearLineView.trailingAnchor.constraint(equalTo: self.leavingYearLabel.trailingAnchor)
            ])
            
            // leavingMonthLabel
            NSLayoutConstraint.activate([
                self.leavingMonthLabel.topAnchor.constraint(equalTo: self.leavingDateView.topAnchor),
                self.leavingMonthLabel.heightAnchor.constraint(equalToConstant: 25),
                self.leavingMonthLabel.leadingAnchor.constraint(equalTo: self.leavingYearLabel.trailingAnchor, constant: 12.5)
            ])
            
            // leavingMonthLineView
            NSLayoutConstraint.activate([
                self.leavingMonthLineView.bottomAnchor.constraint(equalTo: self.leavingDateView.bottomAnchor),
                self.leavingMonthLineView.heightAnchor.constraint(equalToConstant: 1),
                self.leavingMonthLineView.leadingAnchor.constraint(equalTo: self.leavingMonthLabel.leadingAnchor),
                self.leavingMonthLineView.trailingAnchor.constraint(equalTo: self.leavingMonthLabel.trailingAnchor)
            ])
            
            // leavingDayLabel
            NSLayoutConstraint.activate([
                self.leavingDayLabel.topAnchor.constraint(equalTo: self.leavingDateView.topAnchor),
                self.leavingDayLabel.heightAnchor.constraint(equalToConstant: 25),
                self.leavingDayLabel.leadingAnchor.constraint(equalTo: self.leavingMonthLabel.trailingAnchor, constant: 12.5)
            ])
            
            // leavingDayLineView
            NSLayoutConstraint.activate([
                self.leavingDayLineView.bottomAnchor.constraint(equalTo: self.leavingDateView.bottomAnchor),
                self.leavingDayLineView.heightAnchor.constraint(equalToConstant: 1),
                self.leavingDayLineView.leadingAnchor.constraint(equalTo: self.leavingDayLabel.leadingAnchor),
                self.leavingDayLineView.trailingAnchor.constraint(equalTo: self.leavingDayLabel.trailingAnchor)
            ])
            
            // leavingDateButton
            NSLayoutConstraint.activate([
                self.leavingDateButton.topAnchor.constraint(equalTo: self.leavingDateView.topAnchor),
                self.leavingDateButton.bottomAnchor.constraint(equalTo: self.leavingDateView.bottomAnchor),
                self.leavingDateButton.leadingAnchor.constraint(equalTo: self.leavingDateView.leadingAnchor),
                self.leavingDateButton.trailingAnchor.constraint(equalTo: self.leavingDateView.trailingAnchor)
            ])
            
            // selectLeavingDateView
            NSLayoutConstraint.activate([
                self.selectLeavingDateView.topAnchor.constraint(equalTo: self.leavingDateMarkLabel.bottomAnchor, constant: 13),
                self.selectLeavingDateView.heightAnchor.constraint(equalToConstant: 28),
                self.selectLeavingDateView.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 22),
                self.selectLeavingDateView.widthAnchor.constraint(equalToConstant: 150) // FIXME: Need to confirm
            ])
            
            // selectLeavingDateMarkLabel
            NSLayoutConstraint.activate([
                self.selectLeavingDateMarkLabel.topAnchor.constraint(equalTo: self.selectLeavingDateView.topAnchor),
                self.selectLeavingDateMarkLabel.heightAnchor.constraint(equalToConstant: 25),
                self.selectLeavingDateMarkLabel.leadingAnchor.constraint(equalTo: self.selectLeavingDateView.leadingAnchor)
            ])
            
            // selectLeavingDateMarkLineView
            NSLayoutConstraint.activate([
                self.selectLeavingDateMarkLineView.bottomAnchor.constraint(equalTo: self.selectLeavingDateView.bottomAnchor),
                self.selectLeavingDateMarkLineView.heightAnchor.constraint(equalToConstant: 1),
                self.selectLeavingDateMarkLineView.leadingAnchor.constraint(equalTo: selectLeavingDateMarkLabel.leadingAnchor),
                self.selectLeavingDateMarkLineView.trailingAnchor.constraint(equalTo: self.selectLeavingDateMarkLabel.trailingAnchor)
            ])
            
            // selectLeavingDateButton
            NSLayoutConstraint.activate([
                self.selectLeavingDateButton.topAnchor.constraint(equalTo: self.selectLeavingDateView.topAnchor),
                self.selectLeavingDateButton.bottomAnchor.constraint(equalTo: self.selectLeavingDateView.bottomAnchor),
                self.selectLeavingDateButton.leadingAnchor.constraint(equalTo: self.selectLeavingDateView.leadingAnchor),
                self.selectLeavingDateButton.trailingAnchor.constraint(equalTo: self.selectLeavingDateView.trailingAnchor)
            ])
            
            // cancelCareerButton
            NSLayoutConstraint.activate([
                self.cancelCareerButton.bottomAnchor.constraint(equalTo: self.careerBaseView.bottomAnchor, constant: -10),
                self.cancelCareerButton.heightAnchor.constraint(equalToConstant: 28),
                self.cancelCareerButton.trailingAnchor.constraint(equalTo: self.careerBaseView.centerXAnchor, constant: -60),
                self.cancelCareerButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // addCareerButton
            NSLayoutConstraint.activate([
                self.addCareerButton.bottomAnchor.constraint(equalTo: self.careerBaseView.bottomAnchor, constant: -10),
                self.addCareerButton.heightAnchor.constraint(equalToConstant: 28),
                self.addCareerButton.leadingAnchor.constraint(equalTo: self.careerBaseView.centerXAnchor, constant: 60),
                self.addCareerButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // titleLabel
            NSLayoutConstraint.activate([
                self.titleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
                self.titleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.titleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.titleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // datePicker
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // confirmButton
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // declineButton
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            //
            NSLayoutConstraint.activate([
                
            ])
            
        }
    }
}

// MARK: - Extension for methods added
extension MenuCoverViewController {
    func initializeValueRelatedToMenuCoverType(_ menuCoverType: MenuCoverType) {
        if case .annualPaidHolidays(let numberOfAnnualPaidHolidays) = menuCoverType {
            self.numberOfAnnualPaidHolidays = numberOfAnnualPaidHolidays
        }
        
        if case .calendarOfScheduleRecord(let company) = menuCoverType {
            let startDateOfCareer = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(company.dateId))!
            
            self.careerDateRange = (startDate: startDateOfCareer, endDate: company.leavingDate ?? Date()) // MARK: to Today??
            
            self.targetYearMonthDate = company.leavingDate ?? Date()
        }
    }
    
    func initializeCountDownDuration() {
        if case .overtime(_, let overtime) = menuCoverType {
            self.datePicker.countDownDuration = TimeInterval(overtime ?? 60)
        }
    }
    
    func initializeAnnualPaidHolidaysOnPickerView() {
        if case .annualPaidHolidays = menuCoverType {
            self.annualPaidHolidaysPickerView.selectRow(self.annualPaidHolidays.firstIndex(of: self.numberOfAnnualPaidHolidays!)!, inComponent: 0, animated: false)
        }
    }
}

// MARK: - Extension for selector methods
extension MenuCoverViewController {
    // MARK: datePicker
    @objc func datePicker(_ datePicker: UIDatePicker) {
        if case .lastDateAtWork = self.menuCoverType {
            // FIXME: check realm
        }
        
        if case .careerManagement = self.menuCoverType {
            // FIXME: calculate joiningDate and leavingDate
        }
        
        if case .overtime(let regularWork, _) = self.menuCoverType {
            print("datePicker.countDownDuration: \(datePicker.countDownDuration)")
            if regularWork == .fullWork {
                if datePicker.countDownDuration > 16 * 3600 {
                    print("overTime > 16 * 3600")
                }
            }
            
            if regularWork == .halfWork {
                if datePicker.countDownDuration > 20 * 3600 {
                    print("overTime > 20 * 3600")
                }
            }
        }
    }
    
    // MARK: add, insert schedule
    @objc func workButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .addNormalSchedule = tempSelf.menuCoverType {
                tempSelf.delegate?.menuCoverDidDetermineAddNormalSchedule(.work)
            }
            
            if case .insertNormalSchedule(let scheduleType, _) = tempSelf.menuCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.morning(.work))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.afternoon(.work))
                }
            }
        }
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .addNormalSchedule = tempSelf.menuCoverType {
                tempSelf.delegate?.menuCoverDidDetermineAddNormalSchedule(.vacation)
            }
            
            if case .insertNormalSchedule(let scheduleType, _) = tempSelf.menuCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.morning(.vacation))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.afternoon(.vacation))
                }
            }
        }
    }
    
    @objc func holidayButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .addNormalSchedule = tempSelf.menuCoverType {
                tempSelf.delegate?.menuCoverDidDetermineAddNormalSchedule(.holiday)
            }
            
            if case .insertNormalSchedule(let scheduleType, _) = tempSelf.menuCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.morning(.holiday))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.menuCoverDidDetermineInsertNormalSchedule(.afternoon(.holiday))
                }
            }
        }
    }
    
    @objc func closeNormalScheduleButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        let tempSelf = self
        if case .lastDateAtWork = self.menuCoverType {
            self.dismiss(animated: false) {
                tempSelf.delegate?.menuCoverDidDetermineLastDate(self.datePicker.date)
            }
        }
        if case .careerManagement = self.menuCoverType {
            if self.datePicker.tag == 1 { // FIXME: joingDate
                
            }
            
            if self.datePicker.tag == 2 { // FIXME: leavingDate
                
            }
        }
        if case .overtime = self.menuCoverType {
            self.dismiss(animated: false) {
                tempSelf.delegate?.menuCoverDidDetermineOvertimeSeconds(Int(self.datePicker.countDownDuration))
            }
        }
    }
    
    @objc func declineButton(_ sender: UIButton) {
        if case .lastDateAtWork = self.menuCoverType {
            self.dismiss(animated: false)
        }
        if case .careerManagement = self.menuCoverType {
            if self.datePicker.tag == 1 { // FIXME: joingDate
                
            }
            
            if self.datePicker.tag == 2 { // FIXME: leavingDate
                
            }
        }
        if case .overtime = self.menuCoverType {
            self.dismiss(animated: false)
        }
    }
    
    // MARK: annual paid holidays
    @objc func applyAnnualPaidHolidaysButton(_ sender: UIButton) {
       
    }
    
    @objc func cancelApplyingAnnualPaidHolidaysButton(_ sender: UIButton) {
        
    }
    
    // MARK: career management
    @objc func selectJoiningDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for joining date
    }
    
    @objc func joiningDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for joining date
    }
    
    @objc func selectLeavingDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for leaving date
    }
    
    @objc func leavingDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for leaving date
    }
    
    @objc func addCareerButton(_ sender: UIButton) {
        guard let companyName = self.companyNameTextField.text,
                let joiningDate = self.joiningDate,
                let leavingDate = self.leavingDate else {
            return
        }
        
        self.delegate?.menuCoverDidDetermineCompany(companyName, joiningDate: joiningDate, leavingDate: leavingDate)
    }
    
    @objc func cancelCareerButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    // MARK: calendar of schedule record
    @objc func perviousMonthButton(_ sender: UIButton) {
        
    }
    
    @objc func nextMonthButton(_ sender: UIButton) {
        
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension MenuCoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0 // FIXME: temp code
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell() // FIXME: temp code
    }
}

// MARK: - Extension for UIPickerViewDelegate, UIPickerViewDataSource
extension MenuCoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.annualPaidHolidays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.annualPaidHolidays[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Number of annual paid holidays: \(self.annualPaidHolidays[row])")
        
        self.numberOfAnnualPaidHolidays = self.annualPaidHolidays[row]
    }
}
