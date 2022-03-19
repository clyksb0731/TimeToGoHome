//
//  MainCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/15.
//

import UIKit

protocol MainCoverDelegate {
    func mainCoverDidDetermineSchedule(_ scheduleType: ScheduleType)
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date)
}

// Extension for Optional function effect
extension MainCoverDelegate {
    func mainCoverDidDetermineSchedule(_ scheduleType: ScheduleType) { }
    func mianCoverDidDetermineStartingWorkTime(_ startingWorkTime: Date) { }
}

enum MainCoverType {
    case normalSchedule(ScheduleType)
    case overtimeSchedule(Int?)
    case startingWorkTime(Date?)
}

class MainCoverViewController: UIViewController {
    
    var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // Case 1 - normal schedule type
    lazy var normalScheduleBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var normalScheduleTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "일정 변경"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
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
        button.setTitle("휴일", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(holidayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var closeNormalScheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(closeNormalScheduleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // Case 2 - overtime schedule type
    lazy var overtimeBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "추가 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var overtimePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var overtimeBottomLeftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimeBottomRightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimeConfirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "completeMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(overtimeConfirmButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var overtimeDeclineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(overtimeDeclineButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // Case 3 - starting work time type
    lazy var startingWorkTimeBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startingWorkTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var startingWorkTimeDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale.current
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(startingWorkTimeDatePicker(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    lazy var startingWorkTimeBottomLeftView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startingWorkTimeBottomRightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var startingWorkTimeConfirmButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "completeMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(startingWorkTimeConfirmButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var startingWorkTimeDeclineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(startingWorkTimeDeclineButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var mainCoverType: MainCoverType
    
    var delegate: MainCoverDelegate?
    
    var tempMaximumOvertimeHour: Int = 6 // FIXME: Temp variable
    var previousPickerViewHourRowIndex: Int = 0
    var previousPickerViewMinuteRowIndex: Int = 0
    
    init(_ mainCoverType: MainCoverType) {
        self.mainCoverType = mainCoverType
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.overtimePickerView.setPickerComponentNames(names: [1:"시간", 3:"분"])
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
        switch self.mainCoverType {
        case .normalSchedule:
            SupportingMethods.shared.addSubviews([
                self.baseView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.normalScheduleBaseView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.normalScheduleTitleLabel,
                self.normalScheduleListView,
                self.closeNormalScheduleButton
            ], to: self.normalScheduleBaseView)
            
            SupportingMethods.shared.addSubviews([
                self.workButton,
                self.vacationButton,
                self.holidayButton
            ], to: self.normalScheduleListView)
            
        case .overtimeSchedule:
            SupportingMethods.shared.addSubviews([
                self.baseView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.overtimeBaseView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.overtimeTitleLabel,
                self.overtimePickerView,
                self.overtimeBottomLeftView,
                self.overtimeConfirmButton,
                self.overtimeBottomRightView,
                self.overtimeDeclineButton
            ], to: self.overtimeBaseView)
            
        case .startingWorkTime:
            SupportingMethods.shared.addSubviews([
                self.baseView
            ], to: self.view)
            
            SupportingMethods.shared.addSubviews([
                self.startingWorkTimeBaseView
            ], to: self.baseView)
            
            SupportingMethods.shared.addSubviews([
                self.startingWorkTimeTitleLabel,
                self.startingWorkTimeDatePicker,
                self.startingWorkTimeBottomLeftView,
                self.startingWorkTimeConfirmButton,
                self.startingWorkTimeBottomRightView,
                self.startingWorkTimeDeclineButton
            ], to: self.startingWorkTimeBaseView)
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
        
        switch self.mainCoverType {
        case .normalSchedule: // MARK: Normal schedule
            // Normal schedule base view layout
            NSLayoutConstraint.activate([
                self.normalScheduleBaseView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.normalScheduleBaseView.heightAnchor.constraint(equalToConstant: 300),
                self.normalScheduleBaseView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.normalScheduleBaseView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // Normal schedule title label layout
            NSLayoutConstraint.activate([
                self.normalScheduleTitleLabel.topAnchor.constraint(equalTo: self.normalScheduleBaseView.topAnchor, constant: 17),
                self.normalScheduleTitleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.normalScheduleTitleLabel.leadingAnchor.constraint(equalTo: self.normalScheduleBaseView.leadingAnchor),
                self.normalScheduleTitleLabel.trailingAnchor.constraint(equalTo: self.normalScheduleBaseView.trailingAnchor)
            ])
            
            // Normal schedule list view layout
            NSLayoutConstraint.activate([
                self.normalScheduleListView.topAnchor.constraint(equalTo: self.normalScheduleTitleLabel.bottomAnchor, constant: 15),
                self.normalScheduleListView.heightAnchor.constraint(equalToConstant: 185),
                self.normalScheduleListView.leadingAnchor.constraint(equalTo: self.normalScheduleBaseView.leadingAnchor, constant: 25),
                self.normalScheduleListView.trailingAnchor.constraint(equalTo: self.normalScheduleBaseView.trailingAnchor, constant: -25)
            ])
            
            // Close normal schedule button layout
            NSLayoutConstraint.activate([
                self.closeNormalScheduleButton.topAnchor.constraint(equalTo: self.normalScheduleListView.bottomAnchor, constant: 16),
                self.closeNormalScheduleButton.heightAnchor.constraint(equalToConstant: 28),
                self.closeNormalScheduleButton.centerXAnchor.constraint(equalTo: self.normalScheduleBaseView.centerXAnchor),
                self.closeNormalScheduleButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // Work button layout
            NSLayoutConstraint.activate([
                self.workButton.topAnchor.constraint(equalTo: self.normalScheduleListView.topAnchor),
                self.workButton.heightAnchor.constraint(equalToConstant: 57),
                self.workButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.workButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // Vacation button layout
            NSLayoutConstraint.activate([
                self.vacationButton.topAnchor.constraint(equalTo: self.workButton.bottomAnchor, constant: 7),
                self.vacationButton.heightAnchor.constraint(equalToConstant: 57),
                self.vacationButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.vacationButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            // Holiday button layout
            NSLayoutConstraint.activate([
                self.holidayButton.topAnchor.constraint(equalTo: self.vacationButton.bottomAnchor, constant: 7),
                self.holidayButton.heightAnchor.constraint(equalToConstant: 57),
                self.holidayButton.leadingAnchor.constraint(equalTo: self.normalScheduleListView.leadingAnchor),
                self.holidayButton.trailingAnchor.constraint(equalTo: self.normalScheduleListView.trailingAnchor)
            ])
            
            
        case .overtimeSchedule: // MARK: overtimeSchedule
            // Overtime base view layout
            NSLayoutConstraint.activate([
                self.overtimeBaseView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.overtimeBaseView.heightAnchor.constraint(equalToConstant: 300),
                self.overtimeBaseView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.overtimeBaseView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // Overtime title label layout
            NSLayoutConstraint.activate([
                self.overtimeTitleLabel.topAnchor.constraint(equalTo: self.overtimeBaseView.topAnchor, constant: 17),
                self.overtimeTitleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.overtimeTitleLabel.leadingAnchor.constraint(equalTo: self.overtimeBaseView.leadingAnchor),
                self.overtimeTitleLabel.trailingAnchor.constraint(equalTo: self.overtimeBaseView.trailingAnchor)
            ])
            
            // Overtime picker view layout
            NSLayoutConstraint.activate([
                self.overtimePickerView.topAnchor.constraint(equalTo: self.overtimeTitleLabel.bottomAnchor, constant: 10),
                self.overtimePickerView.bottomAnchor.constraint(equalTo: self.overtimeBottomLeftView.topAnchor, constant: -10),
                self.overtimePickerView.leadingAnchor.constraint(equalTo: self.overtimeBaseView.leadingAnchor, constant: 15),
                self.overtimePickerView.trailingAnchor.constraint(equalTo: self.overtimeBaseView.trailingAnchor, constant: -15)
            ])
            
            // Overtime bottom left view layout
            NSLayoutConstraint.activate([
                self.overtimeBottomLeftView.bottomAnchor.constraint(equalTo: self.overtimeBaseView.bottomAnchor),
                self.overtimeBottomLeftView.heightAnchor.constraint(equalToConstant: 48),
                self.overtimeBottomLeftView.leadingAnchor.constraint(equalTo: self.overtimeBaseView.leadingAnchor),
                self.overtimeBottomLeftView.trailingAnchor.constraint(equalTo: self.overtimeBaseView.centerXAnchor)
            ])
            
            // Overtime bottom right view layout
            NSLayoutConstraint.activate([
                self.overtimeBottomRightView.bottomAnchor.constraint(equalTo: self.overtimeBaseView.bottomAnchor),
                self.overtimeBottomRightView.heightAnchor.constraint(equalToConstant: 48),
                self.overtimeBottomRightView.leadingAnchor.constraint(equalTo: self.overtimeBaseView.centerXAnchor),
                self.overtimeBottomRightView.trailingAnchor.constraint(equalTo: self.overtimeBaseView.trailingAnchor)
            ])
            
            // Overtime confirm button layout
            NSLayoutConstraint.activate([
                self.overtimeConfirmButton.centerYAnchor.constraint(equalTo: self.overtimeBottomLeftView.centerYAnchor),
                self.overtimeConfirmButton.heightAnchor.constraint(equalToConstant: 28),
                self.overtimeConfirmButton.centerXAnchor.constraint(equalTo: self.overtimeBottomLeftView.centerXAnchor),
                self.overtimeConfirmButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // Overtime decline button layout layout
            NSLayoutConstraint.activate([
                self.overtimeDeclineButton.centerYAnchor.constraint(equalTo: self.overtimeBottomRightView.centerYAnchor),
                self.overtimeDeclineButton.heightAnchor.constraint(equalToConstant: 28),
                self.overtimeDeclineButton.centerXAnchor.constraint(equalTo: self.overtimeBottomRightView.centerXAnchor),
                self.overtimeDeclineButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
        case .startingWorkTime: // MARK: startingWorkTime
            // Starting work time base view layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeBaseView.centerYAnchor.constraint(equalTo: self.baseView.centerYAnchor),
                self.startingWorkTimeBaseView.heightAnchor.constraint(equalToConstant: 300),
                self.startingWorkTimeBaseView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 32),
                self.startingWorkTimeBaseView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -32)
            ])
            
            // Starting work time title label layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeTitleLabel.topAnchor.constraint(equalTo: self.startingWorkTimeBaseView.topAnchor, constant: 17),
                self.startingWorkTimeTitleLabel.heightAnchor.constraint(equalToConstant: 22),
                self.startingWorkTimeTitleLabel.leadingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.leadingAnchor),
                self.startingWorkTimeTitleLabel.trailingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.trailingAnchor)
            ])
            
            // Starting work time date picker layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeDatePicker.topAnchor.constraint(equalTo: self.startingWorkTimeTitleLabel.bottomAnchor, constant: 10),
                self.startingWorkTimeDatePicker.bottomAnchor.constraint(equalTo: self.startingWorkTimeBottomLeftView.topAnchor, constant: -10),
                self.startingWorkTimeDatePicker.leadingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.leadingAnchor, constant: 5),
                self.startingWorkTimeDatePicker.trailingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.trailingAnchor, constant: -5)
            ])
            
            // Starting work time bottom left view layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeBottomLeftView.bottomAnchor.constraint(equalTo: self.startingWorkTimeBaseView.bottomAnchor),
                self.startingWorkTimeBottomLeftView.heightAnchor.constraint(equalToConstant: 48),
                self.startingWorkTimeBottomLeftView.leadingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.leadingAnchor),
                self.startingWorkTimeBottomLeftView.trailingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.centerXAnchor)
            ])
            
            // Starting work time bottom right view layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeBottomRightView.bottomAnchor.constraint(equalTo: self.startingWorkTimeBaseView.bottomAnchor),
                self.startingWorkTimeBottomRightView.heightAnchor.constraint(equalToConstant: 48),
                self.startingWorkTimeBottomRightView.leadingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.centerXAnchor),
                self.startingWorkTimeBottomRightView.trailingAnchor.constraint(equalTo: self.startingWorkTimeBaseView.trailingAnchor)
            ])
            
            // Starting work time confirm button layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeConfirmButton.centerYAnchor.constraint(equalTo: self.startingWorkTimeBottomLeftView.centerYAnchor),
                self.startingWorkTimeConfirmButton.heightAnchor.constraint(equalToConstant: 28),
                self.startingWorkTimeConfirmButton.centerXAnchor.constraint(equalTo: self.startingWorkTimeBottomLeftView.centerXAnchor),
                self.startingWorkTimeConfirmButton.widthAnchor.constraint(equalToConstant: 28)
            ])
            
            // Starting work time decline button layout layout
            NSLayoutConstraint.activate([
                self.startingWorkTimeDeclineButton.centerYAnchor.constraint(equalTo: self.startingWorkTimeBottomRightView.centerYAnchor),
                self.startingWorkTimeDeclineButton.heightAnchor.constraint(equalToConstant: 28),
                self.startingWorkTimeDeclineButton.centerXAnchor.constraint(equalTo: self.startingWorkTimeBottomRightView.centerXAnchor),
                self.startingWorkTimeDeclineButton.widthAnchor.constraint(equalToConstant: 28)
            ])
        }
    }
}

// MARK: - Extension for methods added
extension MainCoverViewController {
    
}

// MARK: - Extension for Selector methods
extension MainCoverViewController {
    @objc func workButton(_ sender: UIButton) {
        
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        
    }
    
    @objc func holidayButton(_ sender: UIButton) {
        
    }
    
    @objc func closeNormalScheduleButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func overtimeConfirmButton(_ sender: UIButton) {
        
    }
    
    @objc func overtimeDeclineButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func startingWorkTimeDatePicker(_ datePicker: UIDatePicker) {
        
    }
    
    @objc func startingWorkTimeConfirmButton(_ sender: UIButton) {
        
    }
    
    @objc func startingWorkTimeDeclineButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UIPickerViewDelegate
extension MainCoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4 // To make '시간', '분' labels
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.tempMaximumOvertimeHour + 1
            
        } else if component == 1 {
            return 1 // must be 1
            
        } else if component == 2 {
            return pickerView.selectedRow(inComponent: 0) == 0 ? 59 : 60
            
        } else { // 3
            return 1 // must be 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
            
        } else if component == 1 {
            return ""
            
        } else if component == 2 {
            return pickerView.selectedRow(inComponent: 0) == 0 ? "\(row + 1)" : "\(row)"
            
        } else { // 3
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("previous minute index: \(self.previousPickerViewMinuteRowIndex)")
        if pickerView.selectedRow(inComponent: 0) != self.previousPickerViewHourRowIndex { // When component 0 has been changed.
            pickerView.reloadComponent(2)
        }
        
        DispatchQueue.main.async {
            if pickerView.selectedRow(inComponent: 0) != self.previousPickerViewHourRowIndex { // When component 0 has been changed.
                if self.previousPickerViewHourRowIndex == 0 {
                    pickerView.selectRow(self.previousPickerViewMinuteRowIndex + 1, inComponent: 2, animated: false)
                    print("1: \(self.previousPickerViewMinuteRowIndex + 1)")
                    
                } else {
                    if pickerView.selectedRow(inComponent: 0) == 0 {
                        if self.previousPickerViewMinuteRowIndex == 0 {
                            pickerView.selectRow(self.previousPickerViewMinuteRowIndex, inComponent: 2, animated: false)
                            print("2: \(self.previousPickerViewMinuteRowIndex)")
                            
                        } else {
                            pickerView.selectRow(self.previousPickerViewMinuteRowIndex - 1, inComponent: 2, animated: false)
                            print("3: \(self.previousPickerViewMinuteRowIndex - 1)")
                        }
                        
                    } else {
                        print("4: Nothing changed")
                    }
                }
            }
            
            self.previousPickerViewHourRowIndex = pickerView.selectedRow(inComponent: 0)
            self.previousPickerViewMinuteRowIndex = pickerView.selectedRow(inComponent: 2)
        }
    }
}

