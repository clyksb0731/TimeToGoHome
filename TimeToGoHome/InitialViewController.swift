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
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "입사 일자"
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
    
    var entryDateLabel: UILabel = {
        let label = UILabel()
        label.text = "입사 일자"
        label.textAlignment = .center
        label.textColor = UIColor.useRGB(red: 0, green: 0, blue: 0)
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var entryDateView: UIView = {
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
    
    var entryDateEffectView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = UIColor.useRGB(red: 200, green: 200, blue: 200)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var entryDateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var entryDatePickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var entryDatePicker: UIDatePicker = {
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
        view.backgroundColor = UIColor.useRGB(red: 238, green: 238, blue: 238)
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
        
        let today: Date = Date()
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        self.yearLabel.text = "\(todayDateComponents.year!)"
        self.monthLabel.text = "\(todayDateComponents.month!)"
        self.dayLabel.text = "\(todayDateComponents.day!)"
        
        self.entryDatePicker.maximumDate = today
    }
    
    // Initialize views
    func initializeViews() {
        //self.companyNameTextField.inputAccessoryView = self.companyNameToolbar
    }
    
    // Set targets
    func setTargets() {
        self.companyNameTextField.addTarget(self, action: #selector(companyNameTextField(_:)), for: .editingChanged)
        self.companyNameEraserButton.addTarget(self, action: #selector(companyNameEraserButton(_:)), for: .touchUpInside)
        self.entryDateButton.addTarget(self, action: #selector(entryDateButton(_:)), for: .touchUpInside)
        self.entryDatePicker.addTarget(self, action: #selector(entryDatePicker(_:)), for: .valueChanged)
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
            self.titleLabel,
            self.backgroundImageView
            ], to: self.upperView)
        
        SupportingMethods.shared.addSubviews([
            self.companyNameLabel,
            self.companyNameLineView,
            self.companyNameTextField,
            self.companyNameEraserButton,
            self.entryDateLabel,
            self.entryDateView,
            self.entryDateEffectView,
            self.entryDateButton,
            self.entryDatePickerView
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
            ], to: self.entryDateView)
        
        SupportingMethods.shared.addSubviews([
            self.entryDatePicker
        ], to: self.entryDatePickerView)
        
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
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.upperView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 45),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.upperView.trailingAnchor, constant: -16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
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
        
        // Entry date label layout
        NSLayoutConstraint.activate([
            self.entryDateLabel.topAnchor.constraint(equalTo: self.companyNameLineView.bottomAnchor, constant: 36),
            self.entryDateLabel.heightAnchor.constraint(equalToConstant: 22),
            self.entryDateLabel.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.entryDateLabel.widthAnchor.constraint(equalToConstant: 63)
        ])
        
        // Entry date view layout
        NSLayoutConstraint.activate([
            self.entryDateView.topAnchor.constraint(equalTo: self.entryDateLabel.bottomAnchor, constant: 10),
            self.entryDateView.heightAnchor.constraint(equalToConstant: 34),
            self.entryDateView.centerXAnchor.constraint(equalTo: self.lowerView.centerXAnchor),
            self.entryDateView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
        
        // Year label layout
        NSLayoutConstraint.activate([
            self.yearLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.yearLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.yearLabel.leadingAnchor.constraint(equalTo: self.entryDateView.leadingAnchor)
        ])
        
        // Year mark label layout
        NSLayoutConstraint.activate([
            self.yearMarkLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.yearMarkLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.yearMarkLabel.leadingAnchor.constraint(equalTo: self.yearLabel.trailingAnchor)
        ])
        
        // Year line view layout
        NSLayoutConstraint.activate([
            self.yearLineView.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.yearLineView.heightAnchor.constraint(equalToConstant: 1),
            self.yearLineView.leadingAnchor.constraint(equalTo: self.yearLabel.leadingAnchor),
            self.yearLineView.trailingAnchor.constraint(equalTo: self.yearLabel.trailingAnchor)
        ])
        
        // Month label layout
        NSLayoutConstraint.activate([
            self.monthLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.monthLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.monthLabel.leadingAnchor.constraint(equalTo: self.yearMarkLabel.trailingAnchor, constant: 15)
        ])
        
        // Month mark label layout
        NSLayoutConstraint.activate([
            self.monthMarkLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.monthMarkLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.monthMarkLabel.leadingAnchor.constraint(equalTo: self.monthLabel.trailingAnchor)
        ])
        
        // Month line view layout
        NSLayoutConstraint.activate([
            self.monthLineView.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.monthLineView.heightAnchor.constraint(equalToConstant: 1),
            self.monthLineView.leadingAnchor.constraint(equalTo: self.monthLabel.leadingAnchor),
            self.monthLineView.trailingAnchor.constraint(equalTo: self.monthLabel.trailingAnchor)
        ])
        
        // Day label layout
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.dayLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.monthMarkLabel.trailingAnchor, constant: 15)
        ])
        
        // Day mark label layout
        NSLayoutConstraint.activate([
            self.dayMarkLabel.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.dayMarkLabel.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.dayMarkLabel.leadingAnchor.constraint(equalTo: self.dayLabel.trailingAnchor),
            self.dayMarkLabel.trailingAnchor.constraint(equalTo: self.entryDateView.trailingAnchor)
        ])
        
        // Day line view layout
        NSLayoutConstraint.activate([
            self.dayLineView.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.dayLineView.heightAnchor.constraint(equalToConstant: 1),
            self.dayLineView.leadingAnchor.constraint(equalTo: self.dayLabel.leadingAnchor),
            self.dayLineView.trailingAnchor.constraint(equalTo: self.dayLabel.trailingAnchor)
        ])
        
        // Entry date effect view layout
        NSLayoutConstraint.activate([
            self.entryDateEffectView.topAnchor.constraint(equalTo: self.entryDateView.topAnchor, constant: -10),
            self.entryDateEffectView.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor, constant: 10),
            self.entryDateEffectView.leadingAnchor.constraint(equalTo: self.entryDateView.leadingAnchor, constant: -10),
            self.entryDateEffectView.trailingAnchor.constraint(equalTo: self.entryDateView.trailingAnchor, constant: 10)
        ])
        
        // Entry date button layout
        NSLayoutConstraint.activate([
            self.entryDateButton.topAnchor.constraint(equalTo: self.entryDateView.topAnchor),
            self.entryDateButton.bottomAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.entryDateButton.leadingAnchor.constraint(equalTo: self.entryDateView.leadingAnchor),
            self.entryDateButton.trailingAnchor.constraint(equalTo: self.entryDateView.trailingAnchor)
        ])
        
        // Entry date picker view layout
        NSLayoutConstraint.activate([
            self.entryDatePickerView.topAnchor.constraint(equalTo: self.entryDateView.bottomAnchor),
            self.entryDatePickerView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor),
            self.entryDatePickerView.leadingAnchor.constraint(equalTo: self.lowerView.leadingAnchor),
            self.entryDatePickerView.trailingAnchor.constraint(equalTo: self.lowerView.trailingAnchor)
        ])
        
        // Entry date picker layout
        NSLayoutConstraint.activate([
            self.entryDatePicker.topAnchor.constraint(equalTo: self.entryDatePickerView.topAnchor),
            self.entryDatePicker.bottomAnchor.constraint(equalTo: self.entryDatePickerView.bottomAnchor),
            self.entryDatePicker.leadingAnchor.constraint(equalTo: self.entryDatePickerView.leadingAnchor),
            self.entryDatePicker.trailingAnchor.constraint(equalTo: self.entryDatePickerView.trailingAnchor)
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
                        
                        self.entryDatePicker.alpha = 0
                    }, completion: nil)
                }
                
            } else {
                targetY = self.view.safeAreaInsets.top +
                    self.view.safeAreaLayoutGuide.layoutFrame.height / 2 +
                    self.entryDateView.frame.origin.y +
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
    @objc func resignTextFields(_ sender: Any) {
        self.companyNameTextField.resignFirstResponder()
    }
    
    @objc func companyNameTextField(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.companyNameEraserButton.isHidden = textField.text == "" || text == ""
        //self.nextButton.isSelected = textField.text != "" && text != ""
        self.nextButtonView.backgroundColor = textField.text != "" && text != "" ?
            UIColor.useRGB(red: 146, green: 243, blue: 205) : UIColor.useRGB(red: 238, green: 238, blue: 238)
        self.nextButtonImageView.image = textField.text != "" && text != "" ?
            UIImage(named: "nextSelectedImage") : UIImage(named: "nextNormalImage")
        self.nextButton.isEnabled = textField.text != "" && text != ""
    }
    
    @objc func companyNameEraserButton(_ sender: UIButton) {
        self.companyNameTextField.text = ""
        self.companyNameEraserButton.isHidden = true
        
        //self.nextButton.isSelected = false
        self.nextButtonView.backgroundColor = UIColor.useRGB(red: 238, green: 238, blue: 238)
        self.nextButtonImageView.image = UIImage(named: "nextNormalImage")
        self.nextButton.isEnabled = false
    }
    
    @objc func entryDateButton(_ sender: UIButton) {
        // Effect for touching button
        UIView.animate(withDuration: 0.15) {
            self.entryDateEffectView.alpha = 0.3
            
        } completion: { (finish) in
            if finish {
                UIView.animate(withDuration: 0.15, animations: {
                    self.entryDateEffectView.alpha = 0
                }, completion: nil)
            }
        }

        // Animation for date picker
        if self.upperViewTopAnchorConstant.constant == 0 {
            self.upperViewTopAnchorConstant.constant = -200
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                
                self.entryDatePicker.alpha = 1
                
            } completion: { finished in
                if finished {
                    
                }
            }
            
        } else {
            self.upperViewTopAnchorConstant.constant = 0
            self.entryDatePicker.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                
            } completion: { finished in
                if finished {
                    
                }
            }
        }
    }
    
    @objc func entryDatePicker(_ sender: UIDatePicker) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let todayDateComponents = calendar.dateComponents([.year, .month, .day], from: sender.date)
        
        self.yearLabel.text = "\(todayDateComponents.year!)"
        self.monthLabel.text = "\(todayDateComponents.month!)"
        self.dayLabel.text = "\(todayDateComponents.day!)"
        
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
        let companyLocationVC = CompanyLocationViewController()
        let naviVC = UINavigationController(rootViewController: companyLocationVC)
        naviVC.modalPresentationStyle = .fullScreen
        
        self.present(naviVC, animated: true, completion: {
            self.upperViewTopAnchorConstant.constant = 0
            self.entryDatePicker.alpha = 0
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
