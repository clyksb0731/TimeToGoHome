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
        view.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.3)
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
        button.setTitleColor(.white, for: .normal)
        button.setTitle("휴일", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .semibold)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(holidayButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var closeNormalScheduleListViewButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancelMainCoverVCImage"), for: .normal)
        button.addTarget(self, action: #selector(closeNormalScheduleListViewButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // Case 2 - overtime schedule type
    lazy var overtimeScheduleBaseView: UIView = {
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
        
    }
    
    // Set layouts
    func setLayouts() {
        
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
    
    @objc func closeNormalScheduleListViewButton(_ sender: UIButton) {
        
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

