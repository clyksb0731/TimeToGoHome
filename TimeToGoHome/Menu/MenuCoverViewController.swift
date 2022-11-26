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
    case overtime(regularWork: MenuCoverRegularWorkType, overtime: Int)
    case annualPaidHolidays
    case careerManagement
    case calendarOfWorkRecord
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
    
    // Case 1 - normal schedule type
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
    
    let menuCoverType: MenuCoverType
    private var delegate: MenuCoverDelegate?
    
    init(_ menuCoverType: MenuCoverType, delegate: MenuCoverDelegate?) {
        self.menuCoverType = menuCoverType
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
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
            
        case .addNormalSchedule(let normalButtonType):
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
            
        case .insertNormalSchedule(_, let normalButtonType):
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
            
        case .overtime:
            print("")
            
        case .annualPaidHolidays:
            print("")
            
        case .careerManagement:
            print("")
            
        case .calendarOfWorkRecord:
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
        case .lastDateAtWork:
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .addNormalSchedule, .insertNormalSchedule:
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
            
        case .overtime:
            SupportingMethods.shared.addSubviews([
                self.popUpPanelView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .annualPaidHolidays:
            SupportingMethods.shared.addSubviews([
                
            ], to: self.baseView)
            
        case .careerManagement:
            SupportingMethods.shared.addSubviews([
                // careerManagement
                self.popUpPanelView
            ], to: self.baseView)
            
            // + careerManagement
            // popUpPanelView
            SupportingMethods.shared.addSubviews([
                self.titleLabel,
                self.datePicker,
                self.confirmButton,
                self.declineButton
            ], to: self.popUpPanelView)
            
        case .calendarOfWorkRecord:
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
        case .lastDateAtWork:
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
            
        case .addNormalSchedule, .insertNormalSchedule:
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
            
        case .overtime:
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
            
        case .annualPaidHolidays:
            //
            NSLayoutConstraint.activate([
                
            ])
            
        case .careerManagement:
            //
            NSLayoutConstraint.activate([
                
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
            
        case .calendarOfWorkRecord:
            //
            NSLayoutConstraint.activate([
                
            ])
            
        }
    }
}

// MARK: - Extension for methods added
extension MenuCoverViewController {
    func initializeCountDownDuration() {
        if case .overtime(_, let overtime) = menuCoverType {
            self.datePicker.countDownDuration = TimeInterval(overtime)
        }
    }
}

// MARK: - Extension for selector methods
extension MenuCoverViewController {
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
}
