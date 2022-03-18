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
    
    init(mainCoverTypeFor coverType: MainCoverType) {
        self.mainCoverType = coverType
        
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
                self.overtimeDeclineButton
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
        case .normalSchedule:
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
            
            
        case .overtimeSchedule:
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
        case .startingWorkTime:
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
            ])
            
            //  layout
            NSLayoutConstraint.activate([
                
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
        
    }
    
    @objc func overtimeConfirmButton(_ sender: UIButton) {
        
    }
    
    @objc func overtimeDeclineButton(_ sender: UIButton) {
        
    }
    
    @objc func startingWorkTimeDatePicker(_ datePicker: UIDatePicker) {
        
    }
    
    @objc func startingWorkTimeConfirmButton(_ sender: UIButton) {
        
    }
    
    @objc func startingWorkTimeDeclineButton(_ sender: UIButton) {
        
    }
}

// MARK: - UIPickerViewDelegate
extension MainCoverViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 6
            
        } else {
            return 59
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
            
        } else {
            return "\(row + 1)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

