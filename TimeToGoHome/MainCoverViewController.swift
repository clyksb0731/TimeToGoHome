//
//  MainCoverViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/15.
//

import UIKit

enum MainCoverType {
    case normalSchedule(ScheduleType?)
    case overtimeSchedule(_ overtime: Date?, _ isEditingModeBeforPresented: Bool)
    case startingWorkTime(Date?)
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
    
    var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var popUpPanelView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
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
        if case .startingWorkTime(let today) = self.mainCoverType {
            datePicker.date = today ?? Date()
        }
        datePicker.maximumDate = Date()
        //datePicker.addTarget(self, action: #selector(startingWorkTimeDatePicker(_:)), for: .valueChanged)
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
    
    var mainCoverType: MainCoverType
    
    private var delegate: MainCoverDelegate?
    
    var tempMaximumOvertimeHour: Int = 6 // FIXME: Temp variable
    var previousPickerViewHourRowIndex: Int = 0
    var previousPickerViewMinuteRowIndex: Int = 0
    
    var isEditingBeforePresented: Bool?
    
    init(_ mainCoverType: MainCoverType, delegate: MainCoverDelegate?) {
        self.mainCoverType = mainCoverType
        self.delegate = delegate
        
        if case .overtimeSchedule(_, let isEditingBeforePresented) = mainCoverType {
            self.isEditingBeforePresented = isEditingBeforePresented
        }
        
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
            
        case .overtimeSchedule, .startingWorkTime:
            SupportingMethods.shared.addSubviews([
                self.datePicker,
                self.confirmButton,
                self.declineButton
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
            
        case .overtimeSchedule, .startingWorkTime: // MARK: startingWorkTime
            // Starting work time date picker layout
            NSLayoutConstraint.activate([
                self.datePicker.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
                self.datePicker.heightAnchor.constraint(equalToConstant: 195),
                self.datePicker.leadingAnchor.constraint(equalTo: self.popUpPanelView.leadingAnchor, constant: 5),
                self.datePicker.trailingAnchor.constraint(equalTo: self.popUpPanelView.trailingAnchor, constant: -5)
            ])
            
            // Starting work time confirm button layout
            NSLayoutConstraint.activate([
                self.confirmButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.confirmButton.heightAnchor.constraint(equalToConstant: 35),
                self.confirmButton.trailingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: -5),
                self.confirmButton.widthAnchor.constraint(equalToConstant: 97)
            ])
            
            // Starting work time decline button layout layout
            NSLayoutConstraint.activate([
                self.declineButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 10),
                self.declineButton.heightAnchor.constraint(equalToConstant: 35),
                self.declineButton.leadingAnchor.constraint(equalTo: self.popUpPanelView.centerXAnchor, constant: 5),
                self.declineButton.widthAnchor.constraint(equalToConstant: 97)
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
        UIDevice.lightHaptic()
        
        if case .normalSchedule(let scheduleType) = self.mainCoverType {
            if case .morning = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.work))
            }
            
            if case .afternoon = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.work))
            }
        }
        
        self.dismiss(animated: false)
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if case .normalSchedule(let scheduleType) = self.mainCoverType {
            if case .morning = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.vacation))
            }
            
            if case .afternoon = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.vacation))
            }
        }
        
        self.dismiss(animated: false)
    }
    
    @objc func holidayButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if case .normalSchedule(let scheduleType) = self.mainCoverType {
            if case .morning = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.morning(.holiday))
            }
            
            if case .afternoon = scheduleType {
                self.delegate?.mainCoverDidDetermineNormalSchedule(.afternoon(.holiday))
            }
        }
        
        self.dismiss(animated: false)
    }
    
    @objc func closeNormalScheduleButton(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @objc func confirmButton(_ sender: UIButton) {
        if case .overtimeSchedule = self.mainCoverType {
            self.delegate?.mainCoverDidDetermineOvertimeSchedule(.overtime(self.datePicker.date), isEditingModeBeforPresenting: self.isEditingBeforePresented)
        }
        
        if case .startingWorkTime = self.mainCoverType {
            self.delegate?.mianCoverDidDetermineStartingWorkTime(self.datePicker.date)
        }
        
        self.dismiss(animated: false)
    }
    
    @objc func declineButton(_ sender: UIButton) {
        if case .overtimeSchedule = self.mainCoverType {
            let presentingVC = self.presentingViewController
            self.dismiss(animated: false) {
                if let naviVC = presentingVC as? UINavigationController,
                    let mainVC = naviVC.topViewController as? MainViewController {
                    mainVC.isEditingMode = false
                }
            }
        }
        
        if case .startingWorkTime = self.mainCoverType {
            self.dismiss(animated: false)
        }
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
            if pickerView.selectedRow(inComponent: 0) == self.tempMaximumOvertimeHour {
                pickerView.selectRow(0, inComponent: 2, animated: true)
                print("Time is maximum value.")
                
            } else {
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
            }
            
            self.previousPickerViewHourRowIndex = pickerView.selectedRow(inComponent: 0)
            self.previousPickerViewMinuteRowIndex = pickerView.selectedRow(inComponent: 2)
        }
    }
}

