//
//  WorkTypeViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class WorkTypeViewController: UIViewController {
    enum MarkingViewType {
        case earliest (CGPoint)
        case latest (CGPoint)
        case attendance (CGPoint)
    }
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 590)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "근무 형태"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var staggeredTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("시차출퇴근형", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.useRGB(red: 78, green: 216, blue: 220)
        button.tag = 1
        //button.isSelected = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var normalTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("일반형", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.useRGB(red: 78, green: 216, blue: 220)
        button.alpha = 0.5
        button.tag = 2
        //button.isSelected = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var momentLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .useRGB(red: 116, green: 116, blue: 128, alpha: 0.08)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 50)
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var staggeredTypeTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "가장 빠른 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var earliestAttendance7Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "7"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var earliestAttendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var earliestAttendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var earliestAttendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var earliestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 212, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 10.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var earliestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "가장 늦은 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var latestAttendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var latestAttendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var latestAttendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var latestAttendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var latestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 212, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 10.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var latestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var normalTypeTimeView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendance7Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "7"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var attendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 212, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 10.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarFifthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var attendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var leavingMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "퇴근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leaving16Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "16"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leaving17Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "17"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leaving18Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "18"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leaving19Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "19"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leaving20Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "20"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var leavingTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 242, green: 234, blue: 227, alpha: 0.5)
        view.layer.cornerRadius = 10.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var leavingTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 166, green: 166, blue: 166)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var holidaysLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.6)
        label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
        label.text = "정기 휴일 설정"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var dayButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var sundayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .sunday)
        buttonView.tag = 1
        buttonView.isSelected = true
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var mondayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .monday)
        buttonView.tag = 2
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var tuesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .tuesday)
        buttonView.tag = 3
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var wednesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .wednesday)
        buttonView.tag = 4
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var thursdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .thursday)
        buttonView.tag = 5
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var fridayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .friday)
        buttonView.tag = 6
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var saturdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .saturday)
        buttonView.tag = 7
        buttonView.isSelected = true
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var startButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 146, green: 243, blue: 205)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var startButtonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 255, green: 255, blue: 255)
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.text = "시작"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var startButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var earliestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var latestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var attendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var leavingTimeBarMarkingViewConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    deinit {
            print("----------------------------------- WorkTypeViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for override methods
extension WorkTypeViewController {
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
}

// MARK: - Extension for essential methods
extension WorkTypeViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        self.staggeredTypeButton.addTarget(self, action: #selector(workTypeButtons(_:)), for: .touchUpInside)
        self.normalTypeButton.addTarget(self, action: #selector(workTypeButtons(_:)), for: .touchUpInside)
        
        self.sundayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.mondayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.tuesdayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.wednesdayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.thursdayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.fridayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        self.saturdayButtonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        
        self.startButton.addTarget(self, action: #selector(startButton(_:)), for: .touchUpInside)
    }
    
    // Set gestures
    func setGestures() {
        // Earliest attendance time bar view
        let earliestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(earliestAttendanceTimeBarViewTapGesture(_:)))
        self.earliestAttendanceTimeBarView.addGestureRecognizer(earliestAttendanceTimeBarViewTapGesture)
        
        // Earliest attendance time bar marking view
        let earliestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(earliestAttendanceTimeBarMarkingViewPanGesture(_:)))
        self.earliestAttendanceTimeBarMarkingView.addGestureRecognizer(earliestAttendanceTimeBarMarkingViewPanGesture)
        
        // Latest attendance time bar view
        let latestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(latestAttendanceTimeBarViewTapGesture(_:)))
        self.latestAttendanceTimeBarView.addGestureRecognizer(latestAttendanceTimeBarViewTapGesture)
        
        // Latest attendance time bar marking view
        let latestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(latestAttendanceTimeBarMarkingViewPanGesture(_:)))
        self.latestAttendanceTimeBarMarkingView.addGestureRecognizer(latestAttendanceTimeBarMarkingViewPanGesture)
        
        // Attendance time bar view
        let attendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(attendanceTimeBarViewTapGesture(_:)))
        self.attendanceTimeBarView.addGestureRecognizer(attendanceTimeBarViewTapGesture)
        
        // Attendance time bar marking view
        let attendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(attendanceTimeBarMarkingViewPanGesture(_:)))
        self.attendanceTimeBarMarkingView.addGestureRecognizer(attendanceTimeBarMarkingViewPanGesture)
    }
    
    // Set delegates
    func setDelegates() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.scrollView,
            self.startButtonView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.titleLabel,
            self.staggeredTypeButton,
            self.normalTypeButton,
            self.momentLabel,
            self.staggeredTypeTimeView,
            self.normalTypeTimeView,
            self.holidaysLabel,
            self.dayButtonsView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.earliestAttendanceMarkLabel,
            self.earliestAttendance7Label,
            self.earliestAttendance8Label,
            self.earliestAttendance9Label,
            self.earliestAttendance10Label,
            self.earliestAttendanceTimeBarView,
            self.latestAttendanceMarkLabel,
            self.latestAttendance8Label,
            self.latestAttendance9Label,
            self.latestAttendance10Label,
            self.latestAttendance11Label,
            self.latestAttendanceTimeBarView
        ], to: self.staggeredTypeTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.earliestAttendanceTimeBarFirstPointView,
            self.earliestAttendanceTimeBarSecondPointView,
            self.earliestAttendanceTimeBarThirdPointView,
            self.earliestAttendanceTimeBarFourthPointView,
            self.earliestAttendanceTimeBarMarkingView
        ], to: self.earliestAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.latestAttendanceTimeBarFirstPointView,
            self.latestAttendanceTimeBarSecondPointView,
            self.latestAttendanceTimeBarThirdPointView,
            self.latestAttendanceTimeBarFourthPointView,
            self.latestAttendanceTimeBarMarkingView
        ], to: self.latestAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.attendanceMarkLabel,
            self.attendance7Label,
            self.attendance8Label,
            self.attendance9Label,
            self.attendance10Label,
            self.attendance11Label,
            self.attendanceTimeBarView,
            self.leavingMarkLabel,
            self.leaving16Label,
            self.leaving17Label,
            self.leaving18Label,
            self.leaving19Label,
            self.leaving20Label,
            self.leavingTimeBarView
        ], to: self.normalTypeTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.attendanceTimeBarFirstPointView,
            self.attendanceTimeBarSecondPointView,
            self.attendanceTimeBarThirdPointView,
            self.attendanceTimeBarFourthPointView,
            self.attendanceTimeBarFifthPointView,
            self.attendanceTimeBarMarkingView
        ], to: self.attendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.leavingTimeBarMarkingView
        ], to: self.leavingTimeBarView)
        
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
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.startButtonView.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: 590),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        // Dismiss button layout
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
        ])
        
        // Staggered type button layout
        NSLayoutConstraint.activate([
            self.staggeredTypeButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.staggeredTypeButton.heightAnchor.constraint(equalToConstant: 117),
            self.staggeredTypeButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -20),
            self.staggeredTypeButton.widthAnchor.constraint(equalToConstant: 117)
        ])
        
        // Normal type button layout
        NSLayoutConstraint.activate([
            self.normalTypeButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
            self.normalTypeButton.heightAnchor.constraint(equalToConstant: 117),
            self.normalTypeButton.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 20),
            self.normalTypeButton.widthAnchor.constraint(equalToConstant: 117)
        ])
        
        // Moment label layout
        NSLayoutConstraint.activate([
            self.momentLabel.topAnchor.constraint(equalTo: self.staggeredTypeButton.bottomAnchor, constant: 20),
            self.momentLabel.heightAnchor.constraint(equalToConstant: 48),
            self.momentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.momentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 49)
        ])
        
        // MARK: Staggered type time view layout
        NSLayoutConstraint.activate([
            self.staggeredTypeTimeView.topAnchor.constraint(equalTo: self.staggeredTypeButton.bottomAnchor, constant: 82),
            self.staggeredTypeTimeView.heightAnchor.constraint(equalToConstant: 87),
            self.staggeredTypeTimeView.leadingAnchor.constraint(equalTo: self.staggeredTypeButton.leadingAnchor),
            self.staggeredTypeTimeView.trailingAnchor.constraint(equalTo: self.normalTypeButton.trailingAnchor)
        ])
        
        // Earliest attendance mark label layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceMarkLabel.topAnchor.constraint(equalTo: self.staggeredTypeTimeView.topAnchor, constant: 10),
            self.earliestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.earliestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.staggeredTypeTimeView.leadingAnchor),
            self.earliestAttendanceMarkLabel.widthAnchor.constraint(equalToConstant: 92)
        ])
        
        // Earliest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarView.topAnchor.constraint(equalTo: self.earliestAttendanceMarkLabel.topAnchor),
            self.earliestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 21),
            self.earliestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.staggeredTypeTimeView.trailingAnchor),
            self.earliestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 164)
        ])
        
        // Earliest attendance 7 label layout
        NSLayoutConstraint.activate([
            self.earliestAttendance7Label.bottomAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.topAnchor),
            self.earliestAttendance7Label.heightAnchor.constraint(equalToConstant: 10),
            self.earliestAttendance7Label.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.leadingAnchor, constant: 12)
        ])
        
        // Earliest attendance 8 label layout
        NSLayoutConstraint.activate([
            self.earliestAttendance8Label.bottomAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.topAnchor),
            self.earliestAttendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.earliestAttendance8Label.centerXAnchor.constraint(equalTo: self.earliestAttendance7Label.centerXAnchor, constant: 35)
        ])
        
        // Earliest attendance 9 label layout
        NSLayoutConstraint.activate([
            self.earliestAttendance9Label.bottomAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.topAnchor),
            self.earliestAttendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.earliestAttendance9Label.centerXAnchor.constraint(equalTo: self.earliestAttendance8Label.centerXAnchor, constant: 35)
        ])
        
        // Earliest attendance 10 label layout
        NSLayoutConstraint.activate([
            self.earliestAttendance10Label.bottomAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.topAnchor),
            self.earliestAttendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.earliestAttendance10Label.centerXAnchor.constraint(equalTo: self.earliestAttendance9Label.centerXAnchor, constant: 35)
        ])
        
        // Earliest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.centerYAnchor),
            self.earliestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 5),
            self.earliestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.earliestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Earliest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.centerYAnchor),
            self.earliestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 5),
            self.earliestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 35),
            self.earliestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Earliest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.centerYAnchor),
            self.earliestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 5),
            self.earliestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 35),
            self.earliestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Earliest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.centerYAnchor),
            self.earliestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 5),
            self.earliestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 35),
            self.earliestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Earliest attendance time bar marking view layout
        self.earliestAttendaceTimeBarMarkingViewConstraint = self.earliestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.leadingAnchor, constant: 12 + 35)
        NSLayoutConstraint.activate([
            self.earliestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.centerYAnchor),
            self.earliestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.earliestAttendaceTimeBarMarkingViewConstraint,
            self.earliestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Latest attendance mark label layout
        NSLayoutConstraint.activate([
            self.latestAttendanceMarkLabel.topAnchor.constraint(equalTo: self.earliestAttendanceMarkLabel.bottomAnchor, constant: 35),
            self.latestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.latestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.staggeredTypeTimeView.leadingAnchor),
            self.latestAttendanceMarkLabel.widthAnchor.constraint(equalToConstant: 92)
        ])
        
        // Latest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarView.topAnchor.constraint(equalTo: self.earliestAttendanceTimeBarView.bottomAnchor, constant: 35),
            self.latestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 21),
            self.latestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.staggeredTypeTimeView.trailingAnchor),
            self.latestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 164)
        ])
        
        // Latest attendance 8 label layout
        NSLayoutConstraint.activate([
            self.latestAttendance8Label.bottomAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.topAnchor),
            self.latestAttendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.latestAttendance8Label.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.leadingAnchor, constant: 12 + 35)
        ])
        
        // Latest attendance 9 label layout
        NSLayoutConstraint.activate([
            self.latestAttendance9Label.bottomAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.topAnchor),
            self.latestAttendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.latestAttendance9Label.centerXAnchor.constraint(equalTo: self.latestAttendance8Label.centerXAnchor, constant: 35)
        ])
        
        // Latest attendance 10 label layout
        NSLayoutConstraint.activate([
            self.latestAttendance10Label.bottomAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.topAnchor),
            self.latestAttendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.latestAttendance10Label.centerXAnchor.constraint(equalTo: self.latestAttendance9Label.centerXAnchor, constant: 35)
        ])
        
        // Latest attendance 11 label layout
        NSLayoutConstraint.activate([
            self.latestAttendance11Label.bottomAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.topAnchor),
            self.latestAttendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.latestAttendance11Label.centerXAnchor.constraint(equalTo: self.latestAttendance10Label.centerXAnchor, constant: 35)
        ])
        
        // Latest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.centerYAnchor),
            self.latestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 5),
            self.latestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.leadingAnchor, constant: 12 + 35),
            self.latestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Latest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.centerYAnchor),
            self.latestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 5),
            self.latestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 35),
            self.latestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Latest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.centerYAnchor),
            self.latestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 5),
            self.latestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 35),
            self.latestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Latest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.centerYAnchor),
            self.latestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 5),
            self.latestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 35),
            self.latestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Latest attendance time bar marking view layout
        self.latestAttendaceTimeBarMarkingViewConstraint = self.latestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.leadingAnchor, constant: 12 + 35 + 35 + 35)
        NSLayoutConstraint.activate([
            self.latestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.latestAttendanceTimeBarView.centerYAnchor),
            self.latestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.latestAttendaceTimeBarMarkingViewConstraint,
            self.latestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // MARK: Normal type time view layout
        NSLayoutConstraint.activate([
            self.normalTypeTimeView.topAnchor.constraint(equalTo: self.normalTypeButton.bottomAnchor, constant: 82),
            self.normalTypeTimeView.heightAnchor.constraint(equalToConstant: 87),
            self.normalTypeTimeView.leadingAnchor.constraint(equalTo: self.staggeredTypeButton.leadingAnchor),
            self.normalTypeTimeView.trailingAnchor.constraint(equalTo: self.normalTypeButton.trailingAnchor)
        ])
        
        // Attendance mark label layout
        NSLayoutConstraint.activate([
            self.attendanceMarkLabel.topAnchor.constraint(equalTo: self.normalTypeTimeView.topAnchor, constant: 10),
            self.attendanceMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.attendanceMarkLabel.leadingAnchor.constraint(equalTo: self.normalTypeTimeView.leadingAnchor),
            self.attendanceMarkLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // Attendance time bar view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarView.topAnchor.constraint(equalTo: self.attendanceMarkLabel.topAnchor),
            self.attendanceTimeBarView.heightAnchor.constraint(equalToConstant: 21),
            self.attendanceTimeBarView.trailingAnchor.constraint(equalTo: self.normalTypeTimeView.trailingAnchor),
            self.attendanceTimeBarView.widthAnchor.constraint(equalToConstant: 164)
        ])
        
        // Attendance 7 label layout
        NSLayoutConstraint.activate([
            self.attendance7Label.bottomAnchor.constraint(equalTo: self.attendanceTimeBarView.topAnchor),
            self.attendance7Label.heightAnchor.constraint(equalToConstant: 10),
            self.attendance7Label.centerXAnchor.constraint(equalTo: self.attendanceTimeBarView.leadingAnchor, constant: 12)
        ])
        
        // Attendance 8 label layout
        NSLayoutConstraint.activate([
            self.attendance8Label.bottomAnchor.constraint(equalTo: self.attendanceTimeBarView.topAnchor),
            self.attendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.attendance8Label.centerXAnchor.constraint(equalTo: self.attendance7Label.centerXAnchor, constant: 35)
        ])
        
        // Attendance 9 label layout
        NSLayoutConstraint.activate([
            self.attendance9Label.bottomAnchor.constraint(equalTo: self.attendanceTimeBarView.topAnchor),
            self.attendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.attendance9Label.centerXAnchor.constraint(equalTo: self.attendance8Label.centerXAnchor, constant: 35)
        ])
        
        // Attendance 10 label layout
        NSLayoutConstraint.activate([
            self.attendance10Label.bottomAnchor.constraint(equalTo: self.attendanceTimeBarView.topAnchor),
            self.attendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.attendance10Label.centerXAnchor.constraint(equalTo: self.attendance9Label.centerXAnchor, constant: 35)
        ])
        
        // Attendance 11 label layout
        NSLayoutConstraint.activate([
            self.attendance11Label.bottomAnchor.constraint(equalTo: self.attendanceTimeBarView.topAnchor),
            self.attendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.attendance11Label.centerXAnchor.constraint(equalTo: self.attendance10Label.centerXAnchor, constant: 35)
        ])
        
        // Attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 5),
            self.attendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarView.leadingAnchor, constant: 12),
            self.attendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 5),
            self.attendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarFirstPointView.centerXAnchor, constant: 35),
            self.attendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 5),
            self.attendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarSecondPointView.centerXAnchor, constant: 35),
            self.attendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 5),
            self.attendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarThirdPointView.centerXAnchor, constant: 35),
            self.attendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Attendance time bar fifth point view layout
        NSLayoutConstraint.activate([
            self.attendanceTimeBarFifthPointView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarFifthPointView.heightAnchor.constraint(equalToConstant: 5),
            self.attendanceTimeBarFifthPointView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarFourthPointView.centerXAnchor, constant: 35),
            self.attendanceTimeBarFifthPointView.widthAnchor.constraint(equalToConstant: 5)
        ])
        
        // Attendance time bar marking view layout
        self.attendaceTimeBarMarkingViewConstraint = self.attendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.attendanceTimeBarView.leadingAnchor, constant: 12 + 35 + 35)
        NSLayoutConstraint.activate([
            self.attendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.attendanceTimeBarView.centerYAnchor),
            self.attendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.attendaceTimeBarMarkingViewConstraint,
            self.attendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Leaving mark label layout
        NSLayoutConstraint.activate([
            self.leavingMarkLabel.topAnchor.constraint(equalTo: self.attendanceMarkLabel.bottomAnchor, constant: 35),
            self.leavingMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.leavingMarkLabel.leadingAnchor.constraint(equalTo: self.normalTypeTimeView.leadingAnchor),
            self.leavingMarkLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        // Latest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.leavingTimeBarView.topAnchor.constraint(equalTo: self.attendanceTimeBarView.bottomAnchor, constant: 35),
            self.leavingTimeBarView.heightAnchor.constraint(equalToConstant: 21),
            self.leavingTimeBarView.trailingAnchor.constraint(equalTo: self.normalTypeTimeView.trailingAnchor),
            self.leavingTimeBarView.widthAnchor.constraint(equalToConstant: 164)
        ])
        
        // Leaving 16 label layout
        NSLayoutConstraint.activate([
            self.leaving16Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving16Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving16Label.centerXAnchor.constraint(equalTo: self.leavingTimeBarView.leadingAnchor, constant: 12)
        ])
        
        // Leaving 17 label layout
        NSLayoutConstraint.activate([
            self.leaving17Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving17Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving17Label.centerXAnchor.constraint(equalTo: self.leaving16Label.centerXAnchor, constant: 35)
        ])
        
        // Leaving 18 label layout
        NSLayoutConstraint.activate([
            self.leaving18Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving18Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving18Label.centerXAnchor.constraint(equalTo: self.leaving17Label.centerXAnchor, constant: 35)
        ])
        
        // Leaving 19 label layout
        NSLayoutConstraint.activate([
            self.leaving19Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving19Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving19Label.centerXAnchor.constraint(equalTo: self.leaving18Label.centerXAnchor, constant: 35)
        ])
        
        // Leaving 20 label layout
        NSLayoutConstraint.activate([
            self.leaving20Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving20Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving20Label.centerXAnchor.constraint(equalTo: self.leaving19Label.centerXAnchor, constant: 35)
        ])
        
        // Leaving time bar marking view layout
        self.leavingTimeBarMarkingViewConstraint = self.leavingTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.leavingTimeBarView.leadingAnchor, constant: 12 + 35 + 35)
        NSLayoutConstraint.activate([
            self.leavingTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.leavingTimeBarView.centerYAnchor),
            self.leavingTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.leavingTimeBarMarkingViewConstraint,
            self.leavingTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Holidays label layout
        NSLayoutConstraint.activate([
            self.holidaysLabel.topAnchor .constraint(equalTo: self.staggeredTypeTimeView.bottomAnchor, constant: 70),
            self.holidaysLabel.heightAnchor.constraint(equalToConstant: 24),
            self.holidaysLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 43),
            self.holidaysLabel.widthAnchor.constraint(equalToConstant: 119)
        ])
        
        // Day buttons view layout
        NSLayoutConstraint.activate([
            self.dayButtonsView.topAnchor.constraint(equalTo: self.holidaysLabel.bottomAnchor, constant: 34),
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
        
        // Start button view layout
        NSLayoutConstraint.activate([
            self.startButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.startButtonView.heightAnchor.constraint(equalToConstant: UIWindow().safeAreaInsets.bottom + 60),
            self.startButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.startButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Start button label layout
        NSLayoutConstraint.activate([
            self.startButtonLabel.topAnchor.constraint(equalTo: self.startButtonView.topAnchor, constant: 19),
            self.startButtonLabel.heightAnchor.constraint(equalToConstant: 24),
            self.startButtonLabel.centerXAnchor.constraint(equalTo: self.startButtonView.centerXAnchor),
            self.startButtonLabel.widthAnchor.constraint(equalToConstant: 43)
        ])
        
        // Start button layout
        NSLayoutConstraint.activate([
            self.startButton.topAnchor.constraint(equalTo: self.startButtonView.topAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.startButtonView.bottomAnchor),
            self.startButton.leadingAnchor.constraint(equalTo: self.startButtonView.leadingAnchor),
            self.startButton.trailingAnchor.constraint(equalTo: self.startButtonView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension WorkTypeViewController {
    func locateMarkingBarViewFor(_ type: MarkingViewType) {
        switch type {
        case .earliest(let point):
            if point.x <= 12 + 17.5 {
                self.earliestAttendaceTimeBarMarkingViewConstraint.constant = 12
                
            } else if point.x > 12 + 17.5 && point.x <= 12 + 17.5 + 35 {
                self.earliestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35
                
            } else if point.x > 12 + 17.5 + 35 && point.x <= 12 + 17.5 + 35 + 35 {
                self.earliestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35 + 35
                
            } else {
                self.earliestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35 + 35 + 35
            }
            
            UIView.animate(withDuration: 0.2) {
                self.earliestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.earliestAttendanceTimeBarView.isUserInteractionEnabled = true
                }
            }
            
        case .latest(let point):
            if point.x <= 12 + 35 + 17.5 {
                self.latestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35
                
            } else if point.x > 12 + 35 + 17.5 && point.x <= 12 + 35 + 17.5 + 35 {
                self.latestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35 + 35
                
            } else if point.x > 12 + 35 + 17.5 + 35 && point.x <= 12 + 35 + 17.5 + 35 + 35 {
                self.latestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35 * 3
                
            } else {
                self.latestAttendaceTimeBarMarkingViewConstraint.constant = 12 + 35 * 4
            }
            
            UIView.animate(withDuration: 0.2) {
                self.latestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.latestAttendanceTimeBarView.isUserInteractionEnabled = true
                }
            }
            
        case .attendance(let point):
            if point.x <= 12 + 17.5 {
                self.attendaceTimeBarMarkingViewConstraint.constant = 12
                self.leavingTimeBarMarkingViewConstraint.constant = 12
                
            } else if point.x > 12 + 17.5 && point.x <= 12 + 17.5 + 35 {
                self.attendaceTimeBarMarkingViewConstraint.constant = 12 + 35
                self.leavingTimeBarMarkingViewConstraint.constant = 12 + 35
                
            } else if point.x > 12 + 17.5 + 35 && point.x <= 12 + 17.5 + 35 + 35 {
                self.attendaceTimeBarMarkingViewConstraint.constant = 12 + 35 + 35
                self.leavingTimeBarMarkingViewConstraint.constant = 12 + 35 + 35
                
            } else if point.x > 12 + 17.5 + 35 + 35 && point.x <= 12 + 17.5 + 35 * 3 {
                self.attendaceTimeBarMarkingViewConstraint.constant = 12 + 35 * 3
                self.leavingTimeBarMarkingViewConstraint.constant = 12 + 35 * 3
                
            } else {
                self.attendaceTimeBarMarkingViewConstraint.constant = 12 + 35 * 4
                self.leavingTimeBarMarkingViewConstraint.constant = 12 + 35 * 4
            }
            
            UIView.animate(withDuration: 0.2) {
                self.attendanceTimeBarView.layoutIfNeeded()
                self.leavingTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.attendanceTimeBarView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func moveMarkingBarViewTo(_ type: MarkingViewType) {
        switch type {
        case .earliest(let point):
            self.earliestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
                12 : point.x > 12 + 35 * 3 ?
                12 + 35 * 3 : point.x
            
        case .latest(let point):
            self.latestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 + 35 ?
                12 + 35 : point.x > 12 + 35 * 4 ?
                12 + 35 * 4 : point.x
            
        case .attendance(let point):
            self.attendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
                12 : point.x > 12 + 35 * 4 ?
                12 + 35 * 4 : point.x
        }
    }
    
    func showMomentLabelFor(_ type: MarkingViewType, withAnimation animation: Bool) {
        self.momentLabel.layer.removeAllAnimations()
        
        switch type {
        case .earliest(let point):
            if point.x <= 12 + 17.5 { // ~ 7
                self.momentLabel.text = "7"
                
            } else if point.x > 12 + 17.5 && point.x <= 12 + 17.5 + 35 { // 8
                self.momentLabel.text = "8"
                
            } else if point.x > 12 + 17.5 + 35 && point.x <= 12 + 17.5 + 35 + 35 { // 9
                self.momentLabel.text = "9"
                
            } else { // 10 ~
                self.momentLabel.text = "10"
            }
            
        case .latest(let point):
            if point.x <= 12 + 35 + 17.5 { // ~ 8
                self.momentLabel.text = "8"
                
            } else if point.x > 12 + 35 + 17.5 && point.x <= 12 + 35 + 17.5 + 35 { // 9
                self.momentLabel.text = "9"
                
            } else if point.x > 12 + 35 + 17.5 + 35 && point.x <= 12 + 35 + 17.5 + 35 + 35 { // 10
                self.momentLabel.text = "10"
                
            } else { // 11 ~
                self.momentLabel.text = "11"
            }
            
        case .attendance(let point):
            if point.x <= 12 + 17.5 { // ~ 7
                self.momentLabel.text = "7"
                
            } else if point.x > 12 + 17.5 && point.x <= 12 + 17.5 + 35 { // 8
                self.momentLabel.text = "8"
                
            } else if point.x > 12 + 17.5 + 35 && point.x <= 12 + 17.5 + 35 + 35 { // 9
                self.momentLabel.text = "9"
                
            } else if point.x > 12 + 17.5 + 35 + 35 && point.x <= 12 + 17.5 + 35 * 3 { // 10
                self.momentLabel.text = "10"
                
            } else { // 11 ~
                self.momentLabel.text = "11"
            }
        }
        
        self.momentLabel.alpha = 1
        self.momentLabel.isHidden = false
        
        if animation {
            UIView.animate(withDuration: 1.0) {
                self.momentLabel.alpha = 0
                
            } completion: { finished in
                if finished {
                    self.momentLabel.isHidden = true
                    self.momentLabel.alpha = 1
                }
            }
        }
    }
}

// MARK: - Extension for Selector methods
extension WorkTypeViewController {
    @objc func workTypeButtons(_ sender: UIButton) {
        if sender.tag == 1 {
            self.staggeredTypeButton.alpha = 1
            self.normalTypeButton.alpha = 0.5
            
            self.staggeredTypeTimeView.isHidden = false
            self.normalTypeTimeView.isHidden = true
            
        } else {
            self.staggeredTypeButton.alpha = 0.5
            self.normalTypeButton.alpha = 1
            
            self.staggeredTypeTimeView.isHidden = true
            self.normalTypeTimeView.isHidden = false
        }
    }
    
    @objc func earliestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        print("earliestAttendanceTimeBarView point: \(point)")
        
        self.earliestAttendanceTimeBarView.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.earliest(point))
        self.showMomentLabelFor(.earliest(point), withAnimation: true)
    }
    
    @objc func earliestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        print("earliestAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.moveMarkingBarViewTo(.earliest(point))
            self.showMomentLabelFor(.earliest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.earliest(point))
            self.showMomentLabelFor(.earliest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.earliest(point))
            self.showMomentLabelFor(.earliest(point), withAnimation: true)
        }
    }
    
    @objc func latestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        print("latestAttendanceTimeBarView point: \(point)")
        
        self.latestAttendanceTimeBarView.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.latest(point))
        self.showMomentLabelFor(.latest(point), withAnimation: true)
    }
    
    @objc func latestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        print("leavingAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.moveMarkingBarViewTo(.latest(point))
            self.showMomentLabelFor(.latest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.latest(point))
            self.showMomentLabelFor(.latest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.latest(point))
            self.showMomentLabelFor(.latest(point), withAnimation: true)
        }
    }
    
    @objc func attendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        print("attendanceTimeBarView point: \(point)")
        
        self.attendanceTimeBarView.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.attendance(point))
        self.showMomentLabelFor(.attendance(point), withAnimation: true)
    }
    
    @objc func attendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        print("attendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.moveMarkingBarViewTo(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: true)
        }
    }
    
    @objc func holidayButtons(_ sender: UIButton) {
        if let buttonView = sender.superview as? DayButtonView {
            buttonView.isSelected = !buttonView.isSelected
            
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
        let mainNaviVC = UINavigationController(rootViewController: MainViewController())
        mainNaviVC.modalPresentationStyle = .fullScreen
        
        self.present(mainNaviVC, animated: true, completion: nil)
    }
}
