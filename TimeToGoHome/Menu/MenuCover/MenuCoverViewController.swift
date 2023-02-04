//
//  MenuCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/19.
//

import UIKit

enum MenuCoverType {
    case lastDateAtWork
    case addNormalSchedule(NormalButtonType)
    case insertNormalSchedule(RecordScheduleType, NormalButtonType)
    case overtime(Int?)
    case careerManagement(CompanyModel?)
    case calendarOfScheduleRecord(companyModel: CompanyModel)
}

protocol MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date)
    func menuCoverDidDetermineAddNormalSchedule(_ workTimeType: WorkTimeType)
    func menuCoverDidDetermineInsertNormalSchedule(_ scheduleType: RecordScheduleType)
    func menuCoverDidDetermineOvertimeSeconds(_ overtimeSeconds: Int)
    func menuCoverDidDetermineCompanyName(_ name:String, joiningDate: Date, leavingDate: Date?, ofCompanyModel companyModel: CompanyModel?)
    func menuCoverDidDetermineSelectedDate(_ date: Date)
}

// Extension for Optional function effect
extension MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date) {}
    func menuCoverDidDetermineAddNormalSchedule(_ workTimeType: WorkTimeType) {}
    func menuCoverDidDetermineInsertNormalSchedule(_ scheduleType: RecordScheduleType) {}
    func menuCoverDidDetermineOvertimeSeconds(_ overtimeSeconds: Int) {}
    func menuCoverDidDetermineCompanyName(_ name:String, joiningDate: Date, leavingDate: Date?, ofCompanyModel companyModel: CompanyModel?) {}
    func menuCoverDidDetermineSelectedDate(_ date: Date) {}
}

class MenuCoverViewController: UIViewController {
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀"
        label.textAlignment = .right
        label.textColor = UIColor.useRGB(red: 255, green: 255, blue: 255)
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Date picker
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
        datePicker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
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
    
    // MARK: Overtime picker view
    lazy var overtimePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var overtimePickerHourView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimePickerHourMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var overtimePickerMinuteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimePickerMinuteMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "분"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var overtimeHours: [Int] = Array(0...16)
    var overtimeMinutes: [Int] = Array(0...59)
    
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
    
    // MARK: Career management
    lazy var careerBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
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
        textField.font = .systemFont(ofSize: 21, weight: .regular)
        textField.textColor = .black
        textField.placeholder = "회사 이름을 입력하세요."
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.delegate = self
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
        label.text = "날짜를 지정해 주세요."
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
        label.text = "날짜를 지정해 주세요."
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
    
    lazy var cancelApplyCareerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "declineMarkButton"), for: .normal)
        //button.setImage(UIImage(systemName: "x.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        //button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(cancelApplyCareerButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var applyCareerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "confirmMarkButton"), for: .normal)
        //button.setImage(UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        //button.tintColor = .useRGB(red: 61, green: 61, blue: 61, alpha: 0.5)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(applyCareerButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var bottomTransparentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var joiningDate: Date? = nil {
        didSet {
            if let date = self.joiningDate {
                let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
                
                self.joiningYearLabel.text = "\(yearMonthDay.year)"
                self.joiningMonthLabel.text = String(format: "%02d", yearMonthDay.month)
                self.joiningDayLabel.text = String(format: "%02d", yearMonthDay.day)
                
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
                let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
                
                if Int(dateFormatter.string(from: date))! < Int(dateFormatter.string(from: Date()))! {
                    let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
                    
                    self.leavingYearLabel.text = "\(yearMonthDay.year)"
                    self.leavingMonthLabel.text = String(format: "%02d", yearMonthDay.month)
                    self.leavingDayLabel.text = String(format: "%02d", yearMonthDay.day)
                    
                    self.selectLeavingDateView.isHidden = true
                    self.leavingDateView.isHidden = false
                    
                } else {
                    self.selectLeavingDateMarkLineView.isHidden = true
                    self.selectLeavingDateMarkLabel.text = "현재, 재직 중"
                    self.selectLeavingDateMarkLabel.textColor = .useRGB(red: 151, green: 151, blue: 151)
                    self.selectLeavingDateButton.isEnabled = false
                    
                    self.selectLeavingDateView.isHidden = false
                    self.leavingDateView.isHidden = true
                }
                
            } else {
                self.selectLeavingDateView.isHidden = false
                self.leavingDateView.isHidden = true
            }
        }
    }
    
    var bottomTransparentViewBottomAnchor: NSLayoutConstraint!
    
    // MARK: Calendar of schedule record
    lazy var calendarPopUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
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
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate).month)
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
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate).month)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var calendarBaseView: UIView = {
        let previousMonthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(previousMonthSwipeGesture(_:)))
        let nextMonthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextMonthSwipeGesure(_:)))
        
        previousMonthSwipe.direction = .right
        nextMonthSwipe.direction = .left
        
        let view = UIView()
        view.addGestureRecognizer(previousMonthSwipe)
        view.addGestureRecognizer(nextMonthSwipe)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var calendarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 40, height: 45)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: 280, height: 21)
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
    
    var companyModelForCalendar: CompanyModel! // Due to initialization
    var companyModelForCareerManagement: CompanyModel?
    var todayYearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
    var targetYearMonthDate: Date!
    var careerDateRange: (startDate: Date, endDate: Date)!
    var selectedIndexOfYearMonthAndDay: (year: Int, month: Int, day: Int)?
    
    // MARK: Default variable
    let menuCoverType: MenuCoverType
    private var delegate: MenuCoverDelegate?
    
    init(_ menuCoverType: MenuCoverType, delegate: MenuCoverDelegate? = nil) {
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
        
        self.initializeViewsRelatedToMenuCoverTypes()
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
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(baseViewTapGesture(_:)))
        self.baseView.addGestureRecognizer(tapGesture)
    }
    
    func setNotificationCenters() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView,
            self.titleLabel
        ], to: self.view)
        
        switch self.menuCoverType {
        case .lastDateAtWork: // MARK: lastDateAtWork
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.popUpPanelTitleLabel,
                self.datePicker,
                self.declineButton,
                self.confirmButton
            ], to: self.popUpPanelView)
            
        case .addNormalSchedule, .insertNormalSchedule: // MARK: addNormalSchedule, addNormalSchedule
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.popUpPanelTitleLabel,
                self.normalScheduleListView,
                self.closeNormalScheduleButton
            ], to: self.popUpPanelView)
            
            SupportingMethods.shared.addSubviews([
                self.workButton,
                self.vacationButton,
                self.holidayButton
            ], to: self.normalScheduleListView)
            
        case .overtime: // MARK: overtime
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.popUpPanelTitleLabel,
                self.overtimePicker,
                self.declineButton,
                self.confirmButton
            ], to: self.popUpPanelView)
            
            SupportingMethods.shared.addSubviews([
                self.overtimePickerHourView,
                self.overtimePickerHourMarkLabel,
                self.overtimePickerMinuteView,
                self.overtimePickerMinuteMarkLabel
            ], to: self.overtimePicker)
            
        case .careerManagement: // MARK: careerManagement
            SupportingMethods.shared.addSubviews([
                self.careerBaseView,
                self.bottomTransparentView,
                self.popUpPanelView
            ], to: self.view)
            
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
                self.cancelApplyCareerButton,
                self.applyCareerButton
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
                self.popUpPanelTitleLabel,
                self.datePicker,
                self.declineButton,
                self.confirmButton
            ], to: self.popUpPanelView)
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            SupportingMethods.shared.addSubviews([
                self.calendarPopUpView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.yearMonthButtonView,
                self.calendarBaseView
            ], to: self.calendarPopUpView)
            
            SupportingMethods.shared.addSubviews([
                self.previousMonthButton,
                self.yearMonthLabel,
                self.nextMonthButton
            ], to: self.yearMonthButtonView)
            
            SupportingMethods.shared.addSubviews([
                self.calendarCollectionView
            ], to: self.calendarBaseView)
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
            
        case .addNormalSchedule, .insertNormalSchedule: // MARK: addNormalSchedule, insertNormalSchedule
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // popUpPanelTitleLabel
            NSLayoutConstraint.activate([
                self.popUpPanelTitleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
                self.popUpPanelTitleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.popUpPanelTitleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.popUpPanelTitleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // normalScheduleListView
            NSLayoutConstraint.activate([
                self.normalScheduleListView.topAnchor.constraint(equalTo: self.popUpPanelTitleLabel.bottomAnchor, constant: 16),
                self.normalScheduleListView.heightAnchor.constraint(equalToConstant: 179),
                self.normalScheduleListView.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 25),
                self.normalScheduleListView.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -25)
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
            
            // closeNormalScheduleButton
            NSLayoutConstraint.activate([
                self.closeNormalScheduleButton.topAnchor.constraint(equalTo: self.normalScheduleListView.bottomAnchor, constant: 16),
                self.closeNormalScheduleButton.heightAnchor.constraint(equalToConstant: 28),
                self.closeNormalScheduleButton.centerXAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor),
                self.closeNormalScheduleButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
        case .overtime: // MARK: overtime
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // popUpPanelTitleLabel
            NSLayoutConstraint.activate([
                self.popUpPanelTitleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
                self.popUpPanelTitleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.popUpPanelTitleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.popUpPanelTitleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // overtimePicker
            NSLayoutConstraint.activate([
                self.overtimePicker.topAnchor.constraint(equalTo: self.popUpPanelTitleLabel.bottomAnchor),
                self.overtimePicker.bottomAnchor.constraint(equalTo: self.declineButton.topAnchor),
                self.overtimePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
                self.overtimePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
            ])
            
            // overtimePickerHourView
            NSLayoutConstraint.activate([
                self.overtimePickerHourView.centerYAnchor.constraint(equalTo: self.overtimePicker.centerYAnchor),
                self.overtimePickerHourView.heightAnchor.constraint(equalToConstant: 24),
                self.overtimePickerHourView.leadingAnchor.constraint(equalTo: self.overtimePicker.leadingAnchor),
                self.overtimePickerHourView.trailingAnchor.constraint(equalTo: self.overtimePicker.centerXAnchor)
            ])
            
            // overtimePickerHourMarkLabel
            NSLayoutConstraint.activate([
                self.overtimePickerHourMarkLabel.centerYAnchor.constraint(equalTo: self.overtimePickerHourView.centerYAnchor),
                self.overtimePickerHourMarkLabel.leadingAnchor.constraint(equalTo: self.overtimePickerHourView.centerXAnchor, constant: 20)
            ])
            
            // overtimePickerMinuteView
            NSLayoutConstraint.activate([
                self.overtimePickerMinuteView.centerYAnchor.constraint(equalTo: self.overtimePicker.centerYAnchor),
                self.overtimePickerMinuteView.heightAnchor.constraint(equalToConstant: 24),
                self.overtimePickerMinuteView.leadingAnchor.constraint(equalTo: self.overtimePicker.centerXAnchor),
                self.overtimePickerMinuteView.trailingAnchor.constraint(equalTo: self.overtimePicker.trailingAnchor)
            ])
            
            // overtimePickerMinuteMarkLabel
            NSLayoutConstraint.activate([
                self.overtimePickerMinuteMarkLabel.centerYAnchor.constraint(equalTo: self.overtimePickerMinuteView.centerYAnchor),
                self.overtimePickerMinuteMarkLabel.leadingAnchor.constraint(equalTo: self.overtimePickerMinuteView.centerXAnchor, constant: 20)
            ])
            
            // declineButton
            NSLayoutConstraint.activate([
                self.declineButton.bottomAnchor.constraint(equalTo: self.popUpPanelView.bottomAnchor, constant: -6),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // confirmButton
            NSLayoutConstraint.activate([
                self.confirmButton.bottomAnchor.constraint(equalTo: self.popUpPanelView.bottomAnchor, constant: -6),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
        case .careerManagement: // MARK: careerManagement
            // titleLabel
            NSLayoutConstraint.activate([
                self.titleLabel.bottomAnchor.constraint(equalTo: self.careerBaseView.topAnchor, constant: -20),
                self.titleLabel.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor)
            ])
            
            // careerBaseView
            let careerBaseCenterYAnchor = self.careerBaseView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor)
            careerBaseCenterYAnchor.priority = UILayoutPriority(750)
            NSLayoutConstraint.activate([
                careerBaseCenterYAnchor,
                self.careerBaseView.heightAnchor.constraint(equalToConstant: 311),
                self.careerBaseView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomTransparentView.topAnchor),
                self.careerBaseView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.careerBaseView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // companyNameMarkLabel
            NSLayoutConstraint.activate([
                self.companyNameMarkLabel.topAnchor.constraint(equalTo: self.careerBaseView.topAnchor, constant: 24),
                self.companyNameMarkLabel.heightAnchor.constraint(equalToConstant: 21),
                self.companyNameMarkLabel.leadingAnchor.constraint(equalTo: self.careerBaseView.leadingAnchor, constant: 24)
            ])
            
            // companyNameTextField
            NSLayoutConstraint.activate([
                self.companyNameTextField.bottomAnchor.constraint(equalTo: self.companyNameBottomLineView.topAnchor),
                self.companyNameTextField.heightAnchor.constraint(equalToConstant: 24),
                self.companyNameTextField.leadingAnchor.constraint(equalTo: self.companyNameBottomLineView.leadingAnchor, constant: 7),
                self.companyNameTextField.trailingAnchor.constraint(equalTo: self.companyNameBottomLineView.trailingAnchor, constant: -5)
            ])
            
            // companyNameBottomLineView
            NSLayoutConstraint.activate([
                self.companyNameBottomLineView.topAnchor.constraint(equalTo: self.companyNameMarkLabel.bottomAnchor, constant: 38),
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
                self.selectJoiningDateView.widthAnchor.constraint(equalTo: self.selectJoiningDateMarkLabel.widthAnchor)
            ])
            
            // selectJoiningDateMarkLabel
            NSLayoutConstraint.activate([
                self.selectJoiningDateMarkLabel.topAnchor.constraint(equalTo: self.selectJoiningDateView.topAnchor),
                self.selectJoiningDateMarkLabel.heightAnchor.constraint(equalToConstant: 25),
                self.selectJoiningDateMarkLabel.leadingAnchor.constraint(equalTo: self.selectJoiningDateView.leadingAnchor),
                self.selectJoiningDateMarkLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.careerBaseView.trailingAnchor, constant: -5)
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
                self.selectLeavingDateView.widthAnchor.constraint(equalTo: self.selectLeavingDateMarkLabel.widthAnchor)
            ])
            
            // selectLeavingDateMarkLabel
            NSLayoutConstraint.activate([
                self.selectLeavingDateMarkLabel.topAnchor.constraint(equalTo: self.selectLeavingDateView.topAnchor),
                self.selectLeavingDateMarkLabel.heightAnchor.constraint(equalToConstant: 25),
                self.selectLeavingDateMarkLabel.leadingAnchor.constraint(equalTo: self.selectLeavingDateView.leadingAnchor),
                self.selectLeavingDateMarkLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.careerBaseView.trailingAnchor, constant: -5)
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
            
            // cancelApplyCareerButton
            NSLayoutConstraint.activate([
                self.cancelApplyCareerButton.bottomAnchor.constraint(equalTo: self.careerBaseView.bottomAnchor, constant: -10),
                self.cancelApplyCareerButton.heightAnchor.constraint(equalToConstant: 28),
                self.cancelApplyCareerButton.trailingAnchor.constraint(equalTo: self.careerBaseView.centerXAnchor, constant: -60),
                self.cancelApplyCareerButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // applyCareerButton
            NSLayoutConstraint.activate([
                self.applyCareerButton.bottomAnchor.constraint(equalTo: self.careerBaseView.bottomAnchor, constant: -10),
                self.applyCareerButton.heightAnchor.constraint(equalToConstant: 28),
                self.applyCareerButton.leadingAnchor.constraint(equalTo: self.careerBaseView.centerXAnchor, constant: 60),
                self.applyCareerButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // bottomTransparentView
            self.bottomTransparentViewBottomAnchor = self.bottomTransparentView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor)
            NSLayoutConstraint.activate([
                self.bottomTransparentViewBottomAnchor,
                self.bottomTransparentView.heightAnchor.constraint(equalToConstant: 10),
                self.bottomTransparentView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
                self.bottomTransparentView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
            ])
            
            // popUpPanelView
            NSLayoutConstraint.activate([
                self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
                self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
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
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            // calendarPopUpView
            NSLayoutConstraint.activate([
                self.calendarPopUpView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.calendarPopUpView.heightAnchor.constraint(equalToConstant: 53 + 21 + 45 * 6),
                self.calendarPopUpView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
                self.calendarPopUpView.widthAnchor.constraint(equalToConstant: 310)
            ])
            
            // yearMonthButtonView
            NSLayoutConstraint.activate([
                self.yearMonthButtonView.topAnchor.constraint(equalTo: self.calendarPopUpView.topAnchor, constant: 16),
                self.yearMonthButtonView.heightAnchor.constraint(equalToConstant: 21),
                self.yearMonthButtonView.centerXAnchor.constraint(equalTo: self.calendarPopUpView.centerXAnchor),
                self.yearMonthButtonView.widthAnchor.constraint(equalToConstant: 170)
            ])
            
            // previousMonthButton
            NSLayoutConstraint.activate([
                self.previousMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
                self.previousMonthButton.heightAnchor.constraint(equalToConstant: 21),
                self.previousMonthButton.leadingAnchor.constraint(equalTo: self.yearMonthButtonView.leadingAnchor),
                self.previousMonthButton.widthAnchor.constraint(equalToConstant: 30)
            ])
            
            // yearMonthLabel
            NSLayoutConstraint.activate([
                self.yearMonthLabel.topAnchor.constraint(equalTo: self.yearMonthButtonView.topAnchor),
                self.yearMonthLabel.bottomAnchor.constraint(equalTo: self.yearMonthButtonView.bottomAnchor),
                self.yearMonthLabel.leadingAnchor.constraint(equalTo: self.previousMonthButton.trailingAnchor),
                self.yearMonthLabel.trailingAnchor.constraint(equalTo: self.nextMonthButton.leadingAnchor)
            ])
            
            // nextMonthButton
            NSLayoutConstraint.activate([
                self.nextMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
                self.nextMonthButton.heightAnchor.constraint(equalToConstant: 21),
                self.nextMonthButton.trailingAnchor.constraint(equalTo: self.yearMonthButtonView.trailingAnchor),
                self.nextMonthButton.widthAnchor.constraint(equalToConstant: 30)
            ])
            
            // calendarBaseView
            NSLayoutConstraint.activate([
                self.calendarBaseView.topAnchor.constraint(equalTo: self.yearMonthButtonView.bottomAnchor, constant: 16),
                self.calendarBaseView.heightAnchor.constraint(equalToConstant: 21 + 45 * 6),
                self.calendarBaseView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
                self.calendarBaseView.widthAnchor.constraint(equalToConstant: 7 * 40)
            ])
            
            // calendarCollectionView
            SupportingMethods.shared.makeConstraintsOf(self.calendarCollectionView, sameAs: self.calendarBaseView)
        }
    }
}

// MARK: - Extension for methods added
extension MenuCoverViewController {
    func initializeValueRelatedToMenuCoverType(_ menuCoverType: MenuCoverType) {
        if case .careerManagement(let companyModel) = menuCoverType {
            self.companyModelForCareerManagement = companyModel
        }
        
        if case .calendarOfScheduleRecord(let companyModel) = menuCoverType {
            self.companyModelForCalendar = companyModel
            
            let startDateOfCareer = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(companyModel.company!.dateId))!
            
            let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate - 86400))
            let yesterday = SupportingMethods.shared.makeDateWithYear(yearMonthDay.year, month: yearMonthDay.month, andDay: yearMonthDay.day)
            
            if let leavingDate = companyModel.company?.leavingDate {
                let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
                
                if Int(dateFormatter.string(from: leavingDate))! < Int(dateFormatter.string(from: Date()))! {
                    self.careerDateRange = (startDate: startDateOfCareer, endDate: leavingDate)
                    
                } else {
                    self.careerDateRange = (startDate: startDateOfCareer, endDate: yesterday)
                }
                
            } else {
                self.careerDateRange = (startDate: startDateOfCareer, endDate: yesterday)
            }
            
            self.targetYearMonthDate = {
                let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate)
                
                return SupportingMethods.shared.makeDateWithYear(yearMonthDay.year, month: yearMonthDay.month)
            }()
        }
    }
    
    func initializeViewsRelatedToMenuCoverTypes() {
        switch self.menuCoverType {
        case .lastDateAtWork: // MARK: lastDateAtWork
            self.datePicker.minimumDate = ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as? Date
            if let leavingDate = ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date {
                self.datePicker.date = leavingDate
            }
            
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
            
        case .overtime(let overtime):
            if let overtime = overtime {
                let hours = overtime / 3600
                let minutes = (overtime % 3600) / 60
                
                let rowHours = hours >= self.overtimeHours.last! ? self.overtimeHours.last! : hours
                let rowMinutes = hours >= self.overtimeHours.last! ? 0 : minutes
                
                self.overtimePicker.selectRow(rowHours, inComponent: 0, animated: false)
                self.overtimePicker.selectRow(rowMinutes, inComponent: 1, animated: false)
                
            } else {
                self.overtimePicker.selectRow(0, inComponent: 0, animated: false)
                self.overtimePicker.selectRow(0, inComponent: 1, animated: false)
            }
            
        case .careerManagement(let companyModel): // MARK: careerManagement
            self.titleLabel.text = companyModel == nil ? "경력 추가" : "경력 수정"
            self.titleLabel.isHidden = false
            self.datePicker.maximumDate = Date(timeIntervalSinceReferenceDate: Date().timeIntervalSinceReferenceDate - 86400) // to tomorrow
            self.popUpPanelView.isHidden = true
            
            if let companyModel = companyModel {
                let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
                self.companyNameTextField.text = companyModel.company?.name
                
                self.joiningDate = dateFormatter.date(from: String((companyModel.company?.dateId)!))!
                
                if let leavingDate = companyModel.company?.leavingDate {
                    self.leavingDate = leavingDate
                    
                } else {
                    self.selectLeavingDateMarkLineView.isHidden = true
                    self.selectLeavingDateMarkLabel.text = "현재, 재직 중"
                    self.selectLeavingDateMarkLabel.textColor = .useRGB(red: 151, green: 151, blue: 151)
                    self.selectLeavingDateButton.isEnabled = false
                }
            }
            
        case .calendarOfScheduleRecord: // MARK: calendarOfScheduleRecord
            print("")
        }
    }
    
    func moveToPreviousMonth() {
        let startingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate)
        let endingCareerYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate)
        
        guard self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingCareerRangeYearMonth.year, month: startingCareerRangeYearMonth.month) else {
            
            return
        }
        
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month -= 1
        if month == 0 {
            year -= 1
            month = 12
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.todayYearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingCareerRangeYearMonth.year, month: startingCareerRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingCareerYearMonth.year, month: endingCareerYearMonth.month)
        
        //UIDevice.softHaptic()
    }
    
    func moveToNextMonth() {
        let startingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate)
        let endingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate)
        
        guard self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingCareerRangeYearMonth.year, month: endingCareerRangeYearMonth.month) else {
            
            return
        }
        
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.todayYearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingCareerRangeYearMonth.year, month: startingCareerRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingCareerRangeYearMonth.year, month: endingCareerRangeYearMonth.month)
        
        //UIDevice.softHaptic()
    }
    
    func calculateSecondsWithOvertimePickerView() -> Int {
        let selectedHour = self.overtimeHours[self.overtimePicker.selectedRow(inComponent: 0)]
        let selectedMinute = self.overtimeMinutes[self.overtimePicker.selectedRow(inComponent: 1)]
        
        var overtimeSeconds = selectedMinute * 60
        overtimeSeconds += selectedHour * 3600
        
        overtimeSeconds = overtimeSeconds > self.overtimeHours.last! * 3600 ?
        self.overtimeHours.last! * 3600 : overtimeSeconds
        
        return overtimeSeconds
    }
}

// MARK: - Extension for selector methods
extension MenuCoverViewController {
    @objc func baseViewTapGesture(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
    
    // MARK: datePicker
    @objc func datePicker(_ datePicker: UIDatePicker) {
        if case .lastDateAtWork = self.menuCoverType {
            // nothing
        }
        
        if case .careerManagement = self.menuCoverType {
            // nothing
        }
    }
    
    @objc func declineButton(_ sender: UIButton) {
        if case .lastDateAtWork = self.menuCoverType { // MARK: lastDateAtWork
            self.dismiss(animated: false)
        }
        
        if case .overtime = self.menuCoverType { // MARK: overtime
            self.dismiss(animated: false)
        }
        
        if case .careerManagement = self.menuCoverType { // MARK: careerManagement
            self.titleLabel.isHidden = false
            
            if self.datePicker.tag == 1 {
                self.popUpPanelView.isHidden = true
                self.careerBaseView.isHidden = false
            }
            
            if self.datePicker.tag == 2 {
                self.popUpPanelView.isHidden = true
                self.careerBaseView.isHidden = false
            }
        }
    }
    @objc func confirmButton(_ sender: UIButton) {
        let tempSelf = self
        if case .lastDateAtWork = self.menuCoverType { // MARK: lastDateAtWork
            self.dismiss(animated: false) {
                tempSelf.delegate?.menuCoverDidDetermineLastDate(tempSelf.datePicker.date)
            }
        }
        
        if case .overtime = self.menuCoverType { // MARK: overtime
            guard self.calculateSecondsWithOvertimePickerView() >= 60 else {
                SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "추가 근무 시간은 최소 1분입니다.")
                
                return
            }
            
            self.dismiss(animated: false) {
                tempSelf.delegate?.menuCoverDidDetermineOvertimeSeconds(tempSelf.calculateSecondsWithOvertimePickerView())
            }
        }
        
        if case .careerManagement = self.menuCoverType { // MARK: careerManagement
            self.titleLabel.isHidden = false
            
            if self.datePicker.tag == 1 {
                self.joiningDate = self.datePicker.date
                
                self.popUpPanelView.isHidden = true
                self.careerBaseView.isHidden = false
            }
            
            if self.datePicker.tag == 2 {
                self.leavingDate = self.datePicker.date
                
                self.popUpPanelView.isHidden = true
                self.careerBaseView.isHidden = false
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
    
    // MARK: career management
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            self.bottomTransparentViewBottomAnchor.constant = -keyboardSize.height
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            self.bottomTransparentViewBottomAnchor.constant = 0
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                
            }
        }
    }
    
    @objc func selectJoiningDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for joining date
        self.companyNameTextField.resignFirstResponder()
        
        self.titleLabel.isHidden = true
        self.popUpPanelTitleLabel.text = "입사 일자"
        self.datePicker.tag = 1
        if let dateId = self.companyModelForCareerManagement?.company?.dateId, let joiningDate = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: "\(dateId)") {
            self.datePicker.setDate(joiningDate, animated: false)
        } else {
            self.datePicker.setDate(Date(), animated: false)
        }
        self.careerBaseView.isHidden = true
        self.popUpPanelView.isHidden = false
    }
    
    @objc func joiningDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for joining date
        self.companyNameTextField.resignFirstResponder()
        
        self.titleLabel.isHidden = true
        self.popUpPanelTitleLabel.text = "입사 일자"
        self.datePicker.tag = 1
        self.datePicker.setDate(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: "\(self.joiningYearLabel.text!)\(self.joiningMonthLabel.text!)\(self.joiningDayLabel.text!)")!, animated: false)
        
        self.careerBaseView.isHidden = true
        self.popUpPanelView.isHidden = false
    }
    
    @objc func selectLeavingDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for leaving date
        self.companyNameTextField.resignFirstResponder()
        
        self.titleLabel.isHidden = true
        self.popUpPanelTitleLabel.text = "퇴사 일자"
        self.datePicker.tag = 2
        self.datePicker.setDate(self.companyModelForCareerManagement?.company?.leavingDate ?? Date(), animated: false)
        
        self.careerBaseView.isHidden = true
        self.popUpPanelView.isHidden = false
    }
    
    @objc func leavingDateButton(_ sender: UIButton) {
        // hide career base view
        // show date picker for leaving date
        self.companyNameTextField.resignFirstResponder()
        
        self.titleLabel.isHidden = true
        self.popUpPanelTitleLabel.text = "퇴사 일자"
        self.datePicker.tag = 2
        self.datePicker.setDate(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: "\(self.leavingYearLabel.text!)\(self.leavingMonthLabel.text!)\(self.leavingDayLabel.text!)")!, animated: false)
        
        self.careerBaseView.isHidden = true
        self.popUpPanelView.isHidden = false
    }
    
    @objc func applyCareerButton(_ sender: UIButton) {
        let trimmedCompanyName = self.companyNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let newCompanyName = self.companyNameTextField.text, trimmedCompanyName != "" else {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "회사 이름을 입력하세요.")
            
            return
        }
        guard let newJoiningDate = self.joiningDate else {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "입사 날짜를 선택하세요.")
            
            return
        }
        
        if let companyModel = self.companyModelForCareerManagement { // If company is selected
            if CompanyModel.hasAnyCompanyExistedFor(joiningDate: newJoiningDate, andLeavingDate: self.leavingDate ?? Date(), exceptCompany: companyModel.company) {
                SupportingMethods.shared.makeAlert(on: self, withTitle: "회사 중복", andMessage: "해당 기간과 중복되는 경력 사항이 있습니다.")
                
                return
            }
            
            UIDevice.lightHaptic()
            
            let schedulesBefore = companyModel.getSchedulesBefore(newJoiningDate)!
            let scheduleAfter = companyModel.getSchedulesAfter(self.leavingDate ?? Date())!
            if !schedulesBefore.isEmpty || !scheduleAfter.isEmpty {
                SupportingMethods.shared.makeAlert(on: self, withTitle: "근무 내역 삭제", andMessage: "지정된 기간 외 시간에 근무 내역이 존재합니다. 지정된 기간으로 변경 시 해당 근무 내역은 삭제됩니다. 계속 진행할까요?", okAction: UIAlertAction(title: "예", style: .destructive, handler: { action in
                    companyModel.removeSchedules(schedulesBefore)
                    companyModel.removeSchedules(scheduleAfter)
                    
                    let tempSelf = self
                    self.dismiss(animated: false) {
                        tempSelf.delegate?.menuCoverDidDetermineCompanyName(newCompanyName, joiningDate: newJoiningDate, leavingDate: tempSelf.leavingDate, ofCompanyModel: companyModel)
                    }
                    
                }), cancelAction: UIAlertAction(title: "아니오", style: .cancel), completion: nil)
                
            } else {
                let tempSelf = self
                self.dismiss(animated: false) {
                    tempSelf.delegate?.menuCoverDidDetermineCompanyName(newCompanyName, joiningDate: newJoiningDate, leavingDate: tempSelf.leavingDate, ofCompanyModel: companyModel)
                }
            }
            
        } else { // If no company is selected
            if CompanyModel.hasAnyCompanyExistedFor(joiningDate: newJoiningDate, andLeavingDate: self.leavingDate!) {
                SupportingMethods.shared.makeAlert(on: self, withTitle: "회사 중복", andMessage: "해당 기간과 중복되는 경력 사항이 있습니다.")
                
                return
            }
            
            UIDevice.lightHaptic()
            
            let tempSelf = self
            self.dismiss(animated: false) {
                tempSelf.delegate?.menuCoverDidDetermineCompanyName(newCompanyName, joiningDate: newJoiningDate, leavingDate: tempSelf.leavingDate, ofCompanyModel: tempSelf.companyModelForCareerManagement)
            }
        }
    }
    
    @objc func cancelApplyCareerButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    // MARK: calendar of schedule record
    @objc func previousMonthSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.moveToPreviousMonth()
    }
    
    @objc func nextMonthSwipeGesure(_ sender: UISwipeGestureRecognizer) {
        self.moveToNextMonth()
    }
    
    @objc func perviousMonthButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.moveToPreviousMonth()
        
        /*
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month -= 1
        if month == 0 {
            year -= 1
            month = 12
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.todayYearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        let startingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate)
        let endingCareerYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate)
        
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingCareerRangeYearMonth.year, month: startingCareerRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingCareerYearMonth.year, month: endingCareerYearMonth.month)
        
        UIDevice.softHaptic()
        */
    }
    
    @objc func nextMonthButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.moveToNextMonth()
        
        /*
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.todayYearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        let startingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.startDate)
        let endingCareerRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.careerDateRange.endDate)
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingCareerRangeYearMonth.year, month: startingCareerRangeYearMonth.month)
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingCareerRangeYearMonth.year, month: endingCareerRangeYearMonth.month)
        
        UIDevice.softHaptic()
        */
    }
}

// MARK: - Extension for UITextFieldDelegate
extension MenuCoverViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension MenuCoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // weekday of 1st - 1 + days of month -> full items
        return SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 1 + SupportingMethods.shared.getDaysOfMonthFor(self.targetYearMonthDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayOfScheduleRecordCell", for: indexPath) as! CalendarDayOfScheduleRecordCell
        
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        
        if day >= 1 {
            let isToday: Bool = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == self.todayYearMonthDay.year &&
            SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == self.todayYearMonthDay.month &&
            day == self.todayYearMonthDay.day
            
            var isSelected = false
            if let selectedIndexOfYearMonthAndDay = self.selectedIndexOfYearMonthAndDay {
            isSelected = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == selectedIndexOfYearMonthAndDay.year &&
                SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == selectedIndexOfYearMonthAndDay.month &&
                day == selectedIndexOfYearMonthAndDay.day
            }
            
            let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
            
            let isEnable = (dateOfDay >= self.careerDateRange.startDate && dateOfDay <= self.careerDateRange.endDate)
            
            var recordedSchedule: WorkScheduleRecordModel?
            if let schedule = self.companyModelForCalendar.getScheduleOn(dateOfDay) {
                recordedSchedule = WorkScheduleRecordModel(dateId: Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: dateOfDay))!, morning: WorkTimeType(rawValue: schedule.morning), afternoon: WorkTimeType(rawValue: schedule.afternoon), overtime: schedule.overtime)
            }
            
            item.setItem(dateOfDay, recordedSchedule: recordedSchedule, isToday: isToday, isSelected: isSelected, isEnable: isEnable)
            
        } else {
            item.setItem(nil)
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderOfScheduleRecordView", for: indexPath) as! CalendarHeaderOfScheduleRecordView
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
        
        guard (dateOfDay >= self.careerDateRange.startDate && dateOfDay <= self.careerDateRange.endDate) else {
            return
        }
        
        UIDevice.lightHaptic()
        
        self.selectedIndexOfYearMonthAndDay = (SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year,
                                               SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month,
                                               day)
        
        //collectionView.reloadData() // replace as followings.
        // MARK: Because not necessary to change day after selecting another day.
        let item = collectionView.cellForItem(at: indexPath) as! CalendarDayOfScheduleRecordCell
        item.bottomLineView.isHidden = false
        item.dayLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        
        DispatchQueue.main.async {
            let recordedSchedule: WorkScheduleRecordModel = {
                let dateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: dateOfDay))!
                if let schedule = self.companyModelForCalendar.getScheduleOn(dateOfDay) {
                    if schedule.morning == WorkTimeType.holiday.rawValue &&
                        schedule.afternoon == WorkTimeType.holiday.rawValue {
                        self.companyModelForCalendar.removeSchedule(schedule) // Remove full holiday from recorded schedules.
                        
                        return WorkScheduleRecordModel(dateId: dateId)
                        
                    } else {
                        return WorkScheduleRecordModel(dateId: dateId, morning: WorkTimeType(rawValue: schedule.morning), afternoon: WorkTimeType(rawValue: schedule.afternoon), overtime: schedule.overtime)
                    }
                    
                } else {
                    return WorkScheduleRecordModel(dateId: dateId)
                }
            }()
            
            let dayWorkRecordVC = DayWorkRecordViewController(recordedSchedule: recordedSchedule, companyModel: self.companyModelForCalendar)
            
            let presentingVC = self.presentingViewController as? CustomizedNavigationController
            self.dismiss(animated: false) {
                presentingVC?.pushViewController(dayWorkRecordVC, animated: true)
            }
        }
    }
}

// MARK: - Extension for UIPickerViewDelegate, UIPickerViewDataSource
extension MenuCoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // hour
            return self.overtimeHours.count
            
        } else { // component == 1, minute
            return self.overtimeMinutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { // hour
            return String(self.overtimeHours[row])
            
        } else { // component == 1, minute
            return String(self.overtimeMinutes[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(self.overtimeHours[pickerView.selectedRow(inComponent: 0)])시간  \(self.overtimeMinutes[pickerView.selectedRow(inComponent: 1)])분")
        
        if self.overtimeHours[pickerView.selectedRow(inComponent: 0)] == self.overtimeHours.last {
            self.overtimePicker.selectRow(0, inComponent: 1, animated: true)
        }
    }
}
