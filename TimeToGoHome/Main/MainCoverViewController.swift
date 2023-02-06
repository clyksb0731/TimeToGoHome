//
//  MainCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/15.
//

import UIKit

enum NormalButtonType {
    case allButton
    case vacation
    case holiday
}

enum MainCoverType {
    case normalSchedule(ScheduleType?, NormalButtonType)
    case overtimeSchedule(finishingRegularTime: Date, overtime: Date?,  isEditingModeBeforPresented: Bool)
    case startingWorkTime(WorkScheduleModel)
}

protocol MainCoverDelegate {
    func mainCoverDidDetermineNormalSchedule(_ scheduleType: ScheduleType)
    func mainCoverDidDetermineOvertimeSchedule(_ scheduleType: ScheduleType, isEditingModeBeforPresenting: Bool!)
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date)
}

// Extension for Optional function effect
extension MainCoverDelegate {
    func mainCoverDidDetermineNormalSchedule(_ scheduleType: ScheduleType) { }
    func mainCoverDidDetermineOvertimeSchedule(_ scheduleType: ScheduleType, isEditingModeBeforPresenting: Bool!) { }
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date) { }
}

class MainCoverViewController: UIViewController {
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var instanceMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 254, green: 106, blue: 106)
        view.layer.cornerRadius = 16
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view;
    }()
    
    lazy var instanceMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "점심시간은 피해주세요"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        switch self.mainCoverType {
        case .normalSchedule:
            label.text = "일정 변경"
            
        case .overtimeSchedule:
            label.text = "업무 종료 시간"
            
        case .startingWorkTime:
            label.text = "출근 시간"
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Case 1 - normal schedule type
    lazy var normalScheduleListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var workButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Schedule.work
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
        button.backgroundColor = .Schedule.vacation
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
        button.backgroundColor = .Schedule.holiday
        button.setTitleColor(.white, for: .normal)
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
    
    // Case 2 - overtime schedule type, Case 3 - starting work time type
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale(identifier: "ko_KR")
        //datePicker.addTarget(self, action: #selector(startingWorkTimeDatePicker(_:)), for: .valueChanged)
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
    
    var mainCoverType: MainCoverType
    
    private var delegate: MainCoverDelegate?
    
    var isEditingBeforePresented: Bool?
    
    init(_ mainCoverType: MainCoverType, delegate: MainCoverDelegate?) {
        self.mainCoverType = mainCoverType
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
        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            print("----------------------------------- MainCoverViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension MainCoverViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
    }
    
    // Initialize views
    func initializeViews() {
        if case .normalSchedule(_, let buttonType) = self.mainCoverType {
            switch buttonType {
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
        }
        
        if case .overtimeSchedule(let finishingRegularTime, let overtime, let isEditingBeforePresented) = self.mainCoverType {
            let now = Date()
            
            if let overtime = overtime {
                self.datePicker.date = overtime
                
            } else {
                self.datePicker.date = now
            }
            
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: now)
            let maximumDateComponents = DateComponents(timeZone: TimeZone.current, year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!, hour: 23, minute: 59)
            let maximumDate = calendar.date(from: maximumDateComponents)
            
            self.datePicker.minimumDate = Date(timeIntervalSinceReferenceDate: finishingRegularTime.timeIntervalSinceReferenceDate + 60)
            self.datePicker.maximumDate = maximumDate
            
            self.isEditingBeforePresented = isEditingBeforePresented
        }
        
        if case .startingWorkTime(let schedule) = self.mainCoverType {
            if case .morning(let workTimeType) = schedule.morning, case .work = workTimeType,
               case .afternoon(let workTimeType) = schedule.afternoon, case .work = workTimeType {
                
                
                let morningStartingWorkTimeValueRange = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValueRange.rawValue] as! [String:Double]
                
                let morningEarliestTimeValue = morningStartingWorkTimeValueRange["earliestTime"]!
                let morningLatestTime = morningStartingWorkTimeValueRange["latestTime"]!
                
                self.datePicker.minimumDate = SupportingMethods.shared.makeTimeDateWithValue(morningEarliestTimeValue)
                self.datePicker.maximumDate = SupportingMethods.shared.makeTimeDateWithValue(morningLatestTime)
                
                if let startingWorkTime = schedule.startingWorkTime {
                    self.datePicker.date = startingWorkTime
                    
                } else {
                    self.datePicker.date = SupportingMethods.shared.makeTimeDateWithValue(morningEarliestTimeValue)!
                }
                
            } else if case .morning(let workTimeType) = schedule.morning, case .work = workTimeType {
                let morningStartingWorkTimeValueRange = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValueRange.rawValue] as! [String:Double]
                
                let morningEarliestTimeValue = morningStartingWorkTimeValueRange[TimeRange.earliestTime.rawValue]!
                let morningLatestTime = morningStartingWorkTimeValueRange[TimeRange.latestTime.rawValue]!
                
                self.datePicker.minimumDate = SupportingMethods.shared.makeTimeDateWithValue(morningEarliestTimeValue)
                self.datePicker.maximumDate = SupportingMethods.shared.makeTimeDateWithValue(morningLatestTime)
                
                if let startingWorkTime = schedule.startingWorkTime {
                    self.datePicker.date = startingWorkTime
                    
                } else {
                    self.datePicker.date = SupportingMethods.shared.makeTimeDateWithValue(morningEarliestTimeValue)!
                }
                
            } else if case .afternoon(let workTimeType) = schedule.afternoon, case .work = workTimeType {
                let afternoonStartingWorkTimeValueRage = ReferenceValues.initialSetting[InitialSetting.afternoonStartingWorkTimeValueRange.rawValue] as! [String:Double]
                
                let afternoonEarliestTimeValue = afternoonStartingWorkTimeValueRage[TimeRange.earliestTime.rawValue]!
                let afternoonLatestTime = afternoonStartingWorkTimeValueRage[TimeRange.latestTime.rawValue]!
                
                self.datePicker.minimumDate = SupportingMethods.shared.makeTimeDateWithValue(afternoonEarliestTimeValue)
                self.datePicker.maximumDate = SupportingMethods.shared.makeTimeDateWithValue(afternoonLatestTime)
                
                if let startingWorkTime = schedule.startingWorkTime {
                    self.datePicker.date = startingWorkTime
                    
                } else {
                    self.datePicker.date = SupportingMethods.shared.makeTimeDateWithValue(afternoonEarliestTimeValue)!
                }
                
                self.datePicker.addTarget(self, action: #selector(datePicker(_:)), for: .valueChanged)
                
            } else {
                // vaction, holiday
            }
        }
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
            self.baseView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.popUpPanelView
        ], to: self.baseView)
        
        SupportingMethods.shared.addSubviews([
            self.titleLabel
        ], to: self.popUpPanelView)
        
        switch self.mainCoverType {
        case .normalSchedule:
            SupportingMethods.shared.addSubviews([
                self.normalScheduleListView,
                self.closeNormalScheduleButton
            ], to: self.popUpPanelView)
            
            SupportingMethods.shared.addSubviews([
                self.workButton,
                self.vacationButton,
                self.holidayButton
            ], to: self.normalScheduleListView)
            
        case .overtimeSchedule:
            SupportingMethods.shared.addSubviews([
                self.datePicker,
                self.declineButton,
                self.confirmButton
            ], to: self.popUpPanelView)
            
        case .startingWorkTime:
            SupportingMethods.shared.addSubviews([
                self.instanceMessageView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.instanceMessageLabel
            ], to: self.instanceMessageView)
            
            SupportingMethods.shared.addSubviews([
                self.datePicker,
                self.declineButton,
                self.confirmButton
            ], to: self.popUpPanelView)
        }
    }
    
    // Set layouts
    func setLayouts() {
        // Base view layout
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // PopUp panel view layout
        NSLayoutConstraint.activate([
            self.popUpPanelView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
            self.popUpPanelView.heightAnchor.constraint(equalToConstant: 300),
            self.popUpPanelView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
            self.popUpPanelView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
        ])
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: 22),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 22),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor)
        ])
        
        switch self.mainCoverType {
        case .normalSchedule: // MARK: Normal schedule
            // Normal schedule list view layout
            NSLayoutConstraint.activate([
                self.normalScheduleListView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
                self.normalScheduleListView.heightAnchor.constraint(equalToConstant: 179),
                self.normalScheduleListView.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 25),
                self.normalScheduleListView.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -25)
            ])
            
            // Close normal schedule button layout
            NSLayoutConstraint.activate([
                self.closeNormalScheduleButton.topAnchor.constraint(equalTo: self.normalScheduleListView.bottomAnchor, constant: 16),
                self.closeNormalScheduleButton.heightAnchor.constraint(equalToConstant: 28),
                self.closeNormalScheduleButton.centerXAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor),
                self.closeNormalScheduleButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // Work button layout
            NSLayoutConstraint.activate([
                self.workButton.topAnchor.constraint(equalTo: self.normalScheduleListView.topAnchor),
                self.workButton.heightAnchor.constraint(equalToConstant: 55),
                self.workButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.workButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // Vacation button layout
            NSLayoutConstraint.activate([
                self.vacationButton.topAnchor.constraint(equalTo: self.workButton.bottomAnchor, constant: 7),
                self.vacationButton.heightAnchor.constraint(equalToConstant: 55),
                self.vacationButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.vacationButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // Holiday button layout
            NSLayoutConstraint.activate([
                self.holidayButton.topAnchor.constraint(equalTo: self.vacationButton.bottomAnchor, constant: 7),
                self.holidayButton.heightAnchor.constraint(equalToConstant: 55),
                self.holidayButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.holidayButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
        case .overtimeSchedule: // MARK: Overtime schedule
            // Overtime date picker layout
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // Overtime decline button layout layout
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // Overtime time confirm button layout
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
        case .startingWorkTime: // MARK: Starting worktime
            // instanceMessageView layout
            NSLayoutConstraint.activate([
                self.instanceMessageView.bottomAnchor.constraint(equalTo: self.popUpPanelView.topAnchor, constant: -16),
                self.instanceMessageView.heightAnchor.constraint(equalToConstant: 32),
                self.instanceMessageView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
                self.instanceMessageView.widthAnchor.constraint(equalToConstant: 180)
            ])
            
            // instanceMessageLabel layout
            SupportingMethods.shared.makeConstraintsOf(self.instanceMessageLabel, sameAs: self.instanceMessageView)
            
            // Starting work time date picker layout
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // Starting work time decline button layout layout
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // Starting work time confirm button layout
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
        }
    }
}

// MARK: - Extension for methods added
extension MainCoverViewController {
    func showInstanceMessage(_ completion:(() -> ())? = nil) {
        self.instanceMessageView.alpha = 1
        self.instanceMessageView.isHidden = false
        
        UIView.animate(withDuration: 1.5) {
            self.instanceMessageView.alpha = 0
            
        } completion: { finished in
            if finished {
                self.instanceMessageView.isHidden = true
                self.instanceMessageView.alpha = 1
                
                completion?()
            }
        }
    }
}

// MARK: - Extension for Selector methods
extension MainCoverViewController {
    @objc func workButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .normalSchedule(let scheduleType, _) = tempSelf.mainCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.work))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.work))
                }
            }
        }
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .normalSchedule(let scheduleType, _) = tempSelf.mainCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.vacation))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.vacation))
                }
            }
        }
    }
    
    @objc func holidayButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            UIDevice.lightHaptic()
            
            if case .normalSchedule(let scheduleType, _) = tempSelf.mainCoverType {
                if case .morning = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.holiday))
                }
                
                if case .afternoon = scheduleType {
                    tempSelf.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.holiday))
                }
            }
        }
    }
    
    @objc func closeNormalScheduleButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        let tempSelf = self
        self.dismiss(animated: false) {
            if case .overtimeSchedule = tempSelf.mainCoverType {
                tempSelf.delegate?.mainCoverDidDetermineOvertimeSchedule(.overtime(SupportingMethods.shared.makeMinuteDate(from: tempSelf.datePicker.date)), isEditingModeBeforPresenting: tempSelf.isEditingBeforePresented)
            }
            
            if case .startingWorkTime = tempSelf.mainCoverType {
                tempSelf.delegate?.mianCoverDidDetermineStartingWorkTime(SupportingMethods.shared.makeMinuteDate(from: tempSelf.datePicker.date))
            }
        }
    }
    
    @objc func declineButton(_ sender: UIButton) {
        if case .overtimeSchedule = self.mainCoverType {
            let presentingVC = self.presentingViewController
            let tempSelf = self
            self.dismiss(animated: false) {
                if let mainVC = presentingVC as? MainViewController {
                    mainVC.isEditingMode = tempSelf.isEditingBeforePresented!
                }
            }
        }
        
        if case .startingWorkTime = self.mainCoverType {
            self.dismiss(animated: false)
        }
    }
    
    @objc func datePicker(_ datePicker: UIDatePicker) {
        guard let lunchTimeValue = ReferenceValues.initialSetting[InitialSetting.lunchTimeValue.rawValue] as? Double,
              let afternoonStartingWorkTimeValueRage = ReferenceValues.initialSetting[InitialSetting.afternoonStartingWorkTimeValueRange.rawValue] as? [String:Double] else {
            return
        }
        
        let dateInterval = Int(datePicker.date.timeIntervalSinceReferenceDate)
        let lunchTimeDateInterval = Int(SupportingMethods.shared.makeTimeDateWithValue(lunchTimeValue)!.timeIntervalSinceReferenceDate)
        
        if dateInterval >= lunchTimeDateInterval && dateInterval < lunchTimeDateInterval + 3600 {
            self.confirmButton.isEnabled = false
            self.datePicker.date = SupportingMethods.shared.makeTimeDateWithValue(afternoonStartingWorkTimeValueRage["earliestTime"]!)!
            
            self.showInstanceMessage {
                self.confirmButton.isEnabled = true
            }
        }
    }
}
