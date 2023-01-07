//
//  InitialViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import UIKit

class InitialViewController: UIViewController {
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var upperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var lowerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
        button.isHidden = self.tempInitialSetting == nil
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "입사 일자"
        label.textAlignment = .left
        //label.adjustsFontSizeToFitWidth = true
        //label.minimumScaleFactor = 0.5
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "backgroundImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var companyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "회사 이름"
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var companyNameLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    var companyNameToolbar: UIToolbar = {
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)) // To avoid constraint issue
//        toolbar.barTintColor = .white
//        let flexbar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(resignTextFields(_:)))
//        //let donebarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignTextFields(_:)))
//        toolbar.setItems([flexbar, doneBarButton], animated: false)
//        toolbar.sizeToFit()
//
//        return toolbar
//    }()
    
    var companyNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textField.placeholder = "회사 이름을 입력하세요."
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.tag = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    var companyNameEraserButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "companyNameEraserButtonImage"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var joiningDateLabel: UILabel = {
        let label = UILabel()
        label.text = "입사 일자"
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var joiningDateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var yearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var yearMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.text = "년"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var yearLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var monthMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.text = "월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var monthLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var dayMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.text = "일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var dayLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var joiningDateEffectView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.useRGB(red: 200, green: 200, blue: 200)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var joiningDateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var joiningDatePickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var joiningDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.timeZone = TimeZone.current
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.alpha = 0
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        return datePicker
    }()
    
    var nextButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .Buttons.initialInactiveBottom
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var nextButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nextNormalImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var tempInitialSetting: [String:Any]?
    
    var joiningDate: Date = Date()
    
    var initialContentHeight: CGFloat!
    var upperViewTopAnchorConstant: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        self.setViewFoundation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initialContentSize()
        print(self.scrollView.contentSize)
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
        print("----------------------------------- InitialSettingDateViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for Essential Methods
extension InitialViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        // FIXME: Check calendar init & method creation for this.
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone.current
        
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: self.joiningDate)
        
        self.yearLabel.text = "\(todayDateComponents.year!)"
        self.monthLabel.text = "\(todayDateComponents.month!)"
        self.dayLabel.text = "\(todayDateComponents.day!)"
        
        self.joiningDatePicker.maximumDate = Date()
    }
    
    // Initialize views
    func initializeViews() {
        //self.companyNameTextField.inputAccessoryView = self.companyNameToolbar
    }
    
    // Set targets
    func setTargets() {
        self.companyNameTextField.addTarget(self, action: #selector(companyNameTextField(_:)), for: .editingChanged)
        self.companyNameEraserButton.addTarget(self, action: #selector(companyNameEraserButton(_:)), for: .touchUpInside)
        self.joiningDateButton.addTarget(self, action: #selector(joiningDateButton(_:)), for: .touchUpInside)
        self.joiningDatePicker.addTarget(self, action: #selector(joiningDatePicker(_:)), for: .valueChanged)
        self.nextButton.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
    }
    
    // Set gestures
    func setGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignTextFields(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // Set delegates
    func setDelegates() {
        self.companyNameTextField.delegate = self
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.scrollView,
            self.nextButtonView
            ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
            ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
            self.upperView,
            self.lowerView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.titleLabel,
            self.backgroundImageView
            ], to: self.upperView)
        
        SupportingMethods.shared.addSubviews([
            self.companyNameLabel,
            self.companyNameLineView,
            self.companyNameTextField,
            self.companyNameEraserButton,
            self.joiningDateLabel,
            self.joiningDateView,
            self.joiningDateEffectView,
            self.joiningDateButton,
            self.joiningDatePickerView
        ], to: self.lowerView)
        
        SupportingMethods.shared.addSubviews([
            self.yearLabel,
            self.yearMarkLabel,
            self.yearLineView,
            self.monthLabel,
            self.monthMarkLabel,
            self.monthLineView,
            self.dayLabel,
            self.dayMarkLabel,
            self.dayLineView,
            ], to: self.joiningDateView)
        
        SupportingMethods.shared.addSubviews([
            self.joiningDatePicker
        ], to: self.joiningDatePickerView)
        
        SupportingMethods.shared.addSubviews([
            self.nextButtonImageView,
            self.nextButton
        ], to: self.nextButtonView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Content view of scroll view layout (to set automatic content size)
//        let contentHeightConstraint = self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
//        contentHeightConstraint.priority = UILayoutPriority(1)
//        NSLayoutConstraint.activate([
//            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
//            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
//            contentHeightConstraint,
//            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
//            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
//            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
//            ])
        
        // content view layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        // upper view layout
        self.upperViewTopAnchorConstant = self.upperView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        NSLayoutConstraint.activate([
            self.upperViewTopAnchorConstant,
            self.upperView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 1/2),
            self.upperView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.upperView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        // lower view layout
        NSLayoutConstraint.activate([
            self.lowerView.topAnchor.constraint(equalTo: self.upperView.bottomAnchor),
            self.lowerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.lowerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.lowerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        // Dismiss button layout
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.upperView.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.upperView.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.upperView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.upperView.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
            
            /*
            self.titleLabel.topAnchor.constraint(equalTo: self.upperView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.upperView.trailingAnchor, constant: -16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
             */
        ])
        
        // Background image layout
        NSLayoutConstraint.activate([
            self.backgroundImageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 23),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.upperView.bottomAnchor),
            self.backgroundImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.backgroundImageView.widthAnchor.constraint(equalTo: self.backgroundImageView.heightAnchor, multiplier: 216/231)
        ])
        
        // Company name label layout
        NSLayoutConstraint.activate([
            self.companyNameLabel.topAnchor.constraint(equalTo: self.lowerView.topAnchor, constant: 36),
            self.companyNameLabel.heightAnchor.constraint(equalToConstant: 22),
            self.companyNameLabel.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.companyNameLabel.widthAnchor.constraint(equalToConstant: 63)
        ])
        
        // Company name line view layout
        NSLayoutConstraint.activate([
            self.companyNameLineView.topAnchor.constraint(equalTo: self.companyNameLabel.bottomAnchor, constant: 49),
            self.companyNameLineView.heightAnchor.constraint(equalToConstant: 1),
            self.companyNameLineView.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.companyNameLineView.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        // Company name text field layout
        NSLayoutConstraint.activate([
            self.companyNameTextField.bottomAnchor.constraint(equalTo: self.companyNameLineView.bottomAnchor, constant: -5),
            self.companyNameTextField.heightAnchor.constraint(equalToConstant: 22),
            self.companyNameTextField.leadingAnchor.constraint(equalTo: self.companyNameLineView.leadingAnchor, constant: 5),
            self.companyNameTextField.trailingAnchor.constraint(equalTo: self.companyNameLineView.trailingAnchor, constant: -5)
        ])
        
        // Company name eraser button layout
        NSLayoutConstraint.activate([
            self.companyNameEraserButton.centerYAnchor.constraint(equalTo: self.companyNameTextField.centerYAnchor),
            self.companyNameEraserButton.heightAnchor.constraint(equalToConstant: 17),
            self.companyNameEraserButton.leadingAnchor.constraint(equalTo: self.companyNameLineView.trailingAnchor, constant: 5),
            self.companyNameEraserButton.widthAnchor.constraint(equalToConstant: 17)
        ])
        
        // Joining date label layout
        NSLayoutConstraint.activate([
            self.joiningDateLabel.topAnchor.constraint(equalTo: self.companyNameLineView.bottomAnchor, constant: 36),
            self.joiningDateLabel.heightAnchor.constraint(equalToConstant: 22),
            self.joiningDateLabel.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.joiningDateLabel.widthAnchor.constraint(equalToConstant: 63)
        ])
        
        // Joining date view layout
        NSLayoutConstraint.activate([
            self.joiningDateView.topAnchor.constraint(equalTo: self.joiningDateLabel.bottomAnchor, constant: 10),
            self.joiningDateView.heightAnchor.constraint(equalToConstant: 34),
            self.joiningDateView.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.joiningDateView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
        
        // Year label layout
        NSLayoutConstraint.activate([
            self.yearLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.yearLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.yearLabel.leadingAnchor.constraint(equalTo: self.joiningDateView.leadingAnchor)
        ])
        
        // Year mark label layout
        NSLayoutConstraint.activate([
            self.yearMarkLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.yearMarkLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.yearMarkLabel.leadingAnchor.constraint(equalTo: self.yearLabel.trailingAnchor)
        ])
        
        // Year line view layout
        NSLayoutConstraint.activate([
            self.yearLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.yearLineView.heightAnchor.constraint(equalToConstant: 1),
            self.yearLineView.leadingAnchor.constraint(equalTo: self.yearLabel.leadingAnchor),
            self.yearLineView.trailingAnchor.constraint(equalTo: self.yearLabel.trailingAnchor)
        ])
        
        // Month label layout
        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.monthLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.monthLabel.leadingAnchor.constraint(equalTo: self.yearMarkLabel.trailingAnchor, constant: 15)
        ])
        
        // Month mark label layout
        NSLayoutConstraint.activate([
            self.monthMarkLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.monthMarkLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.monthMarkLabel.leadingAnchor.constraint(equalTo: self.monthLabel.trailingAnchor)
        ])
        
        // Month line view layout
        NSLayoutConstraint.activate([
            self.monthLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.monthLineView.heightAnchor.constraint(equalToConstant: 1),
            self.monthLineView.leadingAnchor.constraint(equalTo: self.monthLabel.leadingAnchor),
            self.monthLineView.trailingAnchor.constraint(equalTo: self.monthLabel.trailingAnchor)
        ])
        
        // Day label layout
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.dayLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.monthMarkLabel.trailingAnchor, constant: 15)
        ])
        
        // Day mark label layout
        NSLayoutConstraint.activate([
            self.dayMarkLabel.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.dayMarkLabel.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.dayMarkLabel.leadingAnchor.constraint(equalTo: self.dayLabel.trailingAnchor),
            self.dayMarkLabel.trailingAnchor.constraint(equalTo: self.joiningDateView.trailingAnchor)
        ])
        
        // Day line view layout
        NSLayoutConstraint.activate([
            self.dayLineView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.dayLineView.heightAnchor.constraint(equalToConstant: 1),
            self.dayLineView.leadingAnchor.constraint(equalTo: self.dayLabel.leadingAnchor),
            self.dayLineView.trailingAnchor.constraint(equalTo: self.dayLabel.trailingAnchor)
        ])
        
        // Joining date effect view layout
        NSLayoutConstraint.activate([
            self.joiningDateEffectView.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor, constant: -10),
            self.joiningDateEffectView.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor, constant: 10),
            self.joiningDateEffectView.leadingAnchor.constraint(equalTo: self.joiningDateView.leadingAnchor, constant: -10),
            self.joiningDateEffectView.trailingAnchor.constraint(equalTo: self.joiningDateView.trailingAnchor, constant: 10)
        ])
        
        // Joining date button layout
        NSLayoutConstraint.activate([
            self.joiningDateButton.topAnchor.constraint(equalTo: self.joiningDateView.topAnchor),
            self.joiningDateButton.bottomAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.joiningDateButton.leadingAnchor.constraint(equalTo: self.joiningDateView.leadingAnchor),
            self.joiningDateButton.trailingAnchor.constraint(equalTo: self.joiningDateView.trailingAnchor)
        ])
        
        // Joining date picker view layout
        NSLayoutConstraint.activate([
            self.joiningDatePickerView.topAnchor.constraint(equalTo: self.joiningDateView.bottomAnchor),
            self.joiningDatePickerView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor),
            self.joiningDatePickerView.leadingAnchor.constraint(equalTo: self.lowerView.leadingAnchor),
            self.joiningDatePickerView.trailingAnchor.constraint(equalTo: self.lowerView.trailingAnchor)
        ])
        
        // Joining date picker layout
        NSLayoutConstraint.activate([
            self.joiningDatePicker.topAnchor.constraint(equalTo: self.joiningDatePickerView.topAnchor),
            self.joiningDatePicker.bottomAnchor.constraint(equalTo: self.joiningDatePickerView.bottomAnchor),
            self.joiningDatePicker.leadingAnchor.constraint(equalTo: self.joiningDatePickerView.leadingAnchor),
            self.joiningDatePicker.trailingAnchor.constraint(equalTo: self.joiningDatePickerView.trailingAnchor)
        ])
        
        // Next button view layout
        NSLayoutConstraint.activate([
            self.nextButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nextButtonView.heightAnchor.constraint(equalToConstant: UIWindow().safeAreaInsets.bottom + 60),
            self.nextButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.nextButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Next button image view layout
        NSLayoutConstraint.activate([
            self.nextButtonImageView.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor, constant: 20.5),
            self.nextButtonImageView.heightAnchor.constraint(equalToConstant: 19),
            self.nextButtonImageView.centerXAnchor.constraint(equalTo: self.nextButtonView.centerXAnchor),
            self.nextButtonImageView.widthAnchor.constraint(equalToConstant: 27)
        ])
        
        // Next button layout
        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.nextButton.bottomAnchor.constraint(equalTo: self.nextButtonView.bottomAnchor),
            self.nextButton.leadingAnchor.constraint(equalTo: self.nextButtonView.leadingAnchor),
            self.nextButton.trailingAnchor.constraint(equalTo: self.nextButtonView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for Methods added
extension InitialViewController {
    enum KeyboardAppearance {
        case up (keyboardHeight: CGFloat, duration: Double)
        case down
    }
    
    func controlKeyboardAppearance(_ appearance: KeyboardAppearance) {
        var targetY: CGFloat!
        var targetHeight: CGFloat!
        var distanceHeight: CGFloat!
        
        switch appearance {
        case .up(let keyboardHeight, _):
            if(self.companyNameTextField.isFirstResponder) {
                targetY = self.view.safeAreaInsets.top +
                    self.view.safeAreaLayoutGuide.layoutFrame.height / 2 +
                    self.companyNameLineView.frame.origin.y + 10 // 10 more than actual target y
                targetHeight = self.view.bounds.size.height - targetY
                
                // fold date picker
                if self.upperViewTopAnchorConstant.constant == -200 {
                    self.upperViewTopAnchorConstant.constant = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.layoutIfNeeded()
                        
                        self.joiningDatePicker.alpha = 0
                    }, completion: nil)
                }
                
            } else {
                targetY = self.view.safeAreaInsets.top +
                    self.view.safeAreaLayoutGuide.layoutFrame.height / 2 +
                    self.joiningDateView.frame.origin.y +
                    self.yearLineView.frame.origin.y + 10 // 10 more than actual target y
                targetHeight = self.view.bounds.size.height - targetY
            }
            
            distanceHeight = keyboardHeight - targetHeight
            
            if distanceHeight > 0 {
                self.scrollView.contentSize.height += distanceHeight
                self.scrollView.contentOffset.y = distanceHeight
            }
            
        case .down:
            self.scrollView.contentSize.height = self.initialContentHeight
            self.scrollView.contentOffset.y = 0
        }
    }
    
    func initialContentSize() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.scrollView.contentSize = CGSize(width: safeArea.layoutFrame.width, height: safeArea.layoutFrame.height)
        self.initialContentHeight = self.scrollView.contentSize.height;
    }
}

// MARK: - Extension for Selector methods
extension InitialViewController {
    @objc func dismissButton(_ sender: UIButton) {
        ReferenceValues.initialSetting = self.tempInitialSetting!
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func resignTextFields(_ sender: Any) {
        self.companyNameTextField.resignFirstResponder()
    }
    
    @objc func companyNameTextField(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.companyNameEraserButton.isHidden = textField.text == "" || text == ""
        //self.nextButton.isSelected = textField.text != "" && text != ""
        self.nextButtonView.backgroundColor = textField.text != "" && text != "" ?
            .Buttons.initialActiveBottom : .Buttons.initialInactiveBottom
        self.nextButtonImageView.image = textField.text != "" && text != "" ?
            UIImage(named: "nextSelectedImage") : UIImage(named: "nextNormalImage")
        self.nextButton.isEnabled = textField.text != "" && text != ""
    }
    
    @objc func companyNameEraserButton(_ sender: UIButton) {
        self.companyNameTextField.text = ""
        self.companyNameEraserButton.isHidden = true
        
        //self.nextButton.isSelected = false
        self.nextButtonView.backgroundColor = .Buttons.initialInactiveBottom
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        self.nextButton.isEnabled = false
    }
    
    @objc func joiningDateButton(_ sender: UIButton) {
        // Effect for touching button
        UIView.animate(withDuration: 0.15) {
            self.joiningDateEffectView.alpha = 0.3
            
        } completion: { (finish) in
            if finish {
                UIView.animate(withDuration: 0.15, animations: {
                    self.joiningDateEffectView.alpha = 0
                }, completion: nil)
            }
        }

        // Animation for date picker
        if self.upperViewTopAnchorConstant.constant == 0 {
            self.upperViewTopAnchorConstant.constant = -200
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                
                self.joiningDatePicker.alpha = 1
                
            } completion: { finished in
                if finished {
                    
                }
            }
            
        } else {
            self.upperViewTopAnchorConstant.constant = 0
            self.joiningDatePicker.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                if finished {
                    
                }
            }
        }
    }
    
    @objc func joiningDatePicker(_ sender: UIDatePicker) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: sender.date)
        
        self.yearLabel.text = "\(todayDateComponents.year!)"
        self.monthLabel.text = "\(todayDateComponents.month!)"
        self.dayLabel.text = "\(todayDateComponents.day!)"
        
        self.joiningDate = sender.date
        
        /*
        if let year = todayDateComponents.year {
            print("\(year)년")
        }
        
        if let month = todayDateComponents.month {
            print("\(month)월")
        }
        
        if let day = todayDateComponents.day {
            print("\(day)일")
        }
        */
    }
    
    @objc func nextButton(_ sender: UIButton) {
        guard let companyName = self.companyNameTextField.text else {
            return
        }
        
        guard CompanyModel.checkIfJoiningDateIsNew(self.joiningDate) else {
            let presentingVC = self.presentingViewController
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "신규 회사는 최종 경력보다 빠를 수 없습니다. 경력 사항을 수정할까요?", okAction: UIAlertAction(title: "경력 수정", style: .default, handler: { action in
                if let tempInitialSetting = self.tempInitialSetting {
                    ReferenceValues.initialSetting = tempInitialSetting
                }
                
                presentingVC?.dismiss(animated: false) {
                    let menuNaviVC = CustomizedNavigationController()
                    menuNaviVC.viewControllers = [MenuViewController(), CareerViewController()] // FIXME: What happen at leavingDate ??
                    presentingVC?.present(menuNaviVC, animated: false)
                }
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel))
            
            return
        }
        
        // Temporary data for initial setting
        ReferenceValues.initialSetting.updateValue(companyName, forKey: InitialSetting.companyName.rawValue)
        ReferenceValues.initialSetting.updateValue(self.joiningDate, forKey: InitialSetting.joiningDate.rawValue)
        
        let companyLocationVC = CompanyLocationViewController()
        let naviVC = CustomizedNavigationController(rootViewController: companyLocationVC)
        
        self.present(naviVC, animated: true, completion: {
            self.upperViewTopAnchorConstant.constant = 0
            self.joiningDatePicker.alpha = 0
        })
    }
    
    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            
            self.controlKeyboardAppearance(.up(keyboardHeight: keyboardSize.height, duration: duration))
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        self.controlKeyboardAppearance(.down)
    }
}

extension InitialViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" &&
            textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
