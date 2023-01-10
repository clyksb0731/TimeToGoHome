//
//  SettingHolidaysViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit

class SettingHolidaysViewController: UIViewController {
    
    lazy var firstSettingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var firstSettingMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "대한민국 공휴일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var firstSettingSwitch: YSBlueSwitch = {
        let switchButton = YSBlueSwitch()
        switchButton.addTarget(self, action: #selector(firstSettingSwitch(_:)), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
    }()
    
    lazy var firstSettingBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var secondSettingMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.text = "정기 휴일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var dayButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var sundayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .sunday)
        buttonView.tag = 1
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var mondayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .monday)
        buttonView.tag = 2
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var tuesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .tuesday)
        buttonView.tag = 3
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var wednesdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .wednesday)
        buttonView.tag = 4
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var thursdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .thursday)
        buttonView.tag = 5
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var fridayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .friday)
        buttonView.tag = 6
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var saturdayButtonView: DayButtonView = {
        let buttonView = DayButtonView(day: .saturday)
        buttonView.tag = 7
        buttonView.isSelected = self.holidays.contains(buttonView.tag)
        buttonView.isSelected = true
        buttonView.addTarget(self, action: #selector(holidayButtons(_:)), for: .touchUpInside)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var holidays: Set<Int> = {
        return Set(ReferenceValues.initialSetting[InitialSetting.regularHolidays.rawValue] as! [Int])
    }() {
        didSet {
            ReferenceValues.initialSetting.updateValue(Array(holidays), forKey: InitialSetting.regularHolidays.rawValue)
            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
        }
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
    

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- SettingHolidaysViewController disposed -----------------------------------")
    }

}

// MARK: - Extension for essential methods
extension SettingHolidaysViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "휴무일"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.firstSettingView,
            self.secondSettingMarkLabel,
            self.dayButtonsView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.firstSettingMarkLabel,
            self.firstSettingSwitch,
            self.firstSettingBottomLine
        ], to: self.firstSettingView)
        
        SupportingMethods.shared.addSubviews([
            self.sundayButtonView,
            self.mondayButtonView,
            self.tuesdayButtonView,
            self.wednesdayButtonView,
            self.thursdayButtonView,
            self.fridayButtonView,
            self.saturdayButtonView
        ], to: self.dayButtonsView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // firstSettingView
        NSLayoutConstraint.activate([
            self.firstSettingView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.firstSettingView.heightAnchor.constraint(equalToConstant: 50),
            self.firstSettingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.firstSettingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // firstSettingMarkLabel
        NSLayoutConstraint.activate([
            self.firstSettingMarkLabel.centerYAnchor.constraint(equalTo: self.firstSettingView.centerYAnchor),
            self.firstSettingMarkLabel.leadingAnchor.constraint(equalTo: self.firstSettingView.leadingAnchor, constant: 20)
        ])
        
        // firstSettingSwitch
        NSLayoutConstraint.activate([
            self.firstSettingSwitch.centerYAnchor.constraint(equalTo: self.firstSettingView.centerYAnchor),
            self.firstSettingSwitch.trailingAnchor.constraint(equalTo: self.firstSettingView.trailingAnchor, constant: -24)
        ])
        
        // firstSettingBottomLine
        NSLayoutConstraint.activate([
            self.firstSettingBottomLine.bottomAnchor.constraint(equalTo: self.firstSettingView.bottomAnchor),
            self.firstSettingBottomLine.heightAnchor.constraint(equalToConstant: 0.5),
            self.firstSettingBottomLine.leadingAnchor.constraint(equalTo: self.firstSettingView.leadingAnchor),
            self.firstSettingBottomLine.trailingAnchor.constraint(equalTo: self.firstSettingView.trailingAnchor)
        ])
        
        // secondSettingMarkLabel
        NSLayoutConstraint.activate([
            self.secondSettingMarkLabel.topAnchor.constraint(equalTo: self.firstSettingView.bottomAnchor, constant: 13),
            self.secondSettingMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.secondSettingMarkLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20)
        ])
        
        // dayButtonsView
        NSLayoutConstraint.activate([
            self.dayButtonsView.topAnchor.constraint(equalTo: self.secondSettingMarkLabel.bottomAnchor, constant: 18),
            self.dayButtonsView.heightAnchor.constraint(equalToConstant: 36),
            self.dayButtonsView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.dayButtonsView.widthAnchor.constraint(equalToConstant: 302)
        ])
        
        // sundayButtonView
        NSLayoutConstraint.activate([
            self.sundayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.sundayButtonView.leadingAnchor.constraint(equalTo: self.dayButtonsView.leadingAnchor)
        ])
        
        // mondayButtonView
        NSLayoutConstraint.activate([
            self.mondayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.mondayButtonView.leadingAnchor.constraint(equalTo: self.sundayButtonView.trailingAnchor, constant: 20)
        ])
        
        // tuesdayButtonView
        NSLayoutConstraint.activate([
            self.tuesdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.tuesdayButtonView.leadingAnchor.constraint(equalTo: self.mondayButtonView.trailingAnchor, constant: 20)
        ])
        
        // wednesdayButtonView
        NSLayoutConstraint.activate([
            self.wednesdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.wednesdayButtonView.leadingAnchor.constraint(equalTo: self.tuesdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // thursdayButtonView
        NSLayoutConstraint.activate([
            self.thursdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.thursdayButtonView.leadingAnchor.constraint(equalTo: self.wednesdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // fridayButtonView
        NSLayoutConstraint.activate([
            self.fridayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.fridayButtonView.leadingAnchor.constraint(equalTo: self.thursdayButtonView.trailingAnchor, constant: 20)
        ])
        
        // saturdayButtonView
        NSLayoutConstraint.activate([
            self.saturdayButtonView.centerYAnchor.constraint(equalTo: self.dayButtonsView.centerYAnchor),
            self.saturdayButtonView.leadingAnchor.constraint(equalTo: self.fridayButtonView.trailingAnchor, constant: 20)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingHolidaysViewController {
    func applyKoreanHolidays(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        success?()
        //
        failure?()
    }
}

// MARK: - Extension for selector methods
extension SettingHolidaysViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func firstSettingSwitch(_ sender: YSBlueSwitch) {
        print("First setting switch is \(sender.isOn ? "On" : "Off")")
        
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        self.applyKoreanHolidays {
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
            
        } failure: {
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
    
    @objc func holidayButtons(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        if let buttonView = sender.superview as? DayButtonView {
            buttonView.isSelected.toggle()
            
            switch buttonView.day {
            case .sunday:
                if buttonView.isSelected {
                    self.holidays.insert(1)
                    print("sunday on")
                    
                } else {
                    self.holidays.remove(1)
                    print("sunday off")
                }
                
            case .monday:
                if buttonView.isSelected {
                    self.holidays.insert(2)
                    print("monday on")
                    
                } else {
                    self.holidays.remove(2)
                    print("monday off")
                }
                
            case .tuesday:
                if buttonView.isSelected {
                    self.holidays.insert(3)
                    print("tuesday on")
                    
                } else {
                    self.holidays.remove(3)
                    print("tuesday off")
                }
                
            case .wednesday:
                if buttonView.isSelected {
                    self.holidays.insert(4)
                    print("wednesday on")
                    
                } else {
                    self.holidays.remove(4)
                    print("wednesday off")
                }
                
            case .thursday:
                if buttonView.isSelected {
                    self.holidays.insert(5)
                    print("thursday on")
                    
                } else {
                    self.holidays.remove(5)
                    print("thursday off")
                }
                
            case .friday:
                if buttonView.isSelected {
                    self.holidays.insert(6)
                    print("friday on")
                    
                } else {
                    self.holidays.remove(6)
                    print("friday off")
                }
                
            case .saturday:
                if buttonView.isSelected {
                    self.holidays.insert(7)
                    print("saturday on")
                    
                } else {
                    self.holidays.remove(7)
                    print("saturday off")
                }
            }
        }
    }
}
