//
//  SettingNumberOfPaidHolidaysViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/10.
//

import UIKit

class SettingNumberOfPaidHolidaysViewController: UIViewController {
    
    lazy var annualPaidHolidaysMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.text = "연차 일수"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var annualPaidHolidaysPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 2
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var dayMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 221, green: 221, blue: 221)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var annualPaidHolidaysTypeMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.text = "휴가 기준"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var settingVacationButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var fiscalYearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingVacationNormalButton"), for: .normal)
        button.setImage(UIImage(named: "settingVacationSelectedButton"), for: .selected)
        button.addTarget(self, action: #selector(fiscalYearButton(_:)), for: .touchUpInside)
        button.isSelected = self.annualPaidHolidaysType == .fiscalYear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var fiscalYearMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "회계연도"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var joiningDayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "settingVacationNormalButton"), for: .normal)
        button.setImage(UIImage(named: "settingVacationSelectedButton"), for: .selected)
        button.addTarget(self, action: #selector(joiningDayButton(_:)), for: .touchUpInside)
        button.isSelected = self.annualPaidHolidaysType == .joiningDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var joiningDayMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.text = "입사날짜"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var annualPaidHolidaysType: AnnualPaidHolidaysType = {
        return VacationModel.annualPaidHolidaysType
    }()
    var tempAnnualPaidHolidaysType: AnnualPaidHolidaysType!
    
    var annualPaidHolidays: [Int] = Array(0...99)
    
    var numberOfAnnualPaidHolidays: Int = VacationModel.numberOfAnnualPaidHolidays
    var tempNumberOfAnnualPaidHolidays: Int = VacationModel.numberOfAnnualPaidHolidays

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.annualPaidHolidaysPickerView.selectRow(self.annualPaidHolidays.firstIndex(of: self.numberOfAnnualPaidHolidays)!, inComponent: 0, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- SettingNumberOfPaidHolidaysViewController disposed -----------------------------------")
    }

}

// MARK: - Extension for essential methods
extension SettingNumberOfPaidHolidaysViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "연차 휴가"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func initializeObjects() {
        self.tempAnnualPaidHolidaysType = self.annualPaidHolidaysType
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.annualPaidHolidaysMarkLabel,
            self.annualPaidHolidaysPickerView,
            self.separatorLineView,
            self.annualPaidHolidaysTypeMarkLabel,
            self.settingVacationButtonsView,
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.dayMarkLabel
        ], to: self.annualPaidHolidaysPickerView)
        
        SupportingMethods.shared.addSubviews([
            self.fiscalYearButton,
            self.fiscalYearMarkLabel,
            self.joiningDayButton,
            self.joiningDayMarkLabel
        ], to: self.settingVacationButtonsView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // annualPaidHolidaysMarkLabel
        NSLayoutConstraint.activate([
            self.annualPaidHolidaysMarkLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32),
            self.annualPaidHolidaysMarkLabel.heightAnchor.constraint(equalToConstant: 22),
            self.annualPaidHolidaysMarkLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32)
        ])
        
        // annualPaidHolidaysPickerView
        NSLayoutConstraint.activate([
            self.annualPaidHolidaysPickerView.topAnchor.constraint(equalTo: self.annualPaidHolidaysMarkLabel.bottomAnchor),
            self.annualPaidHolidaysPickerView.heightAnchor.constraint(equalToConstant: 240),
            self.annualPaidHolidaysPickerView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.annualPaidHolidaysPickerView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        // dayMarkLabel
        NSLayoutConstraint.activate([
            self.dayMarkLabel.centerYAnchor.constraint(equalTo: self.annualPaidHolidaysPickerView.centerYAnchor),
            self.dayMarkLabel.leadingAnchor.constraint(equalTo: self.annualPaidHolidaysPickerView.centerXAnchor, constant: 20)
        ])
        
        // separatorLineView
        NSLayoutConstraint.activate([
            self.separatorLineView.bottomAnchor.constraint(equalTo: self.annualPaidHolidaysPickerView.bottomAnchor),
            self.separatorLineView.heightAnchor.constraint(equalToConstant: 1.5),
            self.separatorLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            self.separatorLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24)
        ])
        
        // annualPaidHolidaysTypeMarkLabel
        NSLayoutConstraint.activate([
            self.annualPaidHolidaysTypeMarkLabel.topAnchor.constraint(equalTo: self.separatorLineView.bottomAnchor, constant: 32),
            self.annualPaidHolidaysTypeMarkLabel.heightAnchor.constraint(equalToConstant: 22),
            self.annualPaidHolidaysTypeMarkLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32)
        ])
        
        // settingVacationButtonsView
        NSLayoutConstraint.activate([
            self.settingVacationButtonsView.topAnchor.constraint(equalTo: self.annualPaidHolidaysTypeMarkLabel.bottomAnchor, constant: 32),
            self.settingVacationButtonsView.heightAnchor.constraint(equalToConstant: 28),
            self.settingVacationButtonsView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.settingVacationButtonsView.widthAnchor.constraint(equalToConstant: 229)
        ])
        
        // fiscalYearButton
        NSLayoutConstraint.activate([
            self.fiscalYearButton.centerYAnchor.constraint(equalTo: self.settingVacationButtonsView.centerYAnchor),
            self.fiscalYearButton.heightAnchor.constraint(equalToConstant: 28),
            self.fiscalYearButton.leadingAnchor.constraint(equalTo: self.settingVacationButtonsView.leadingAnchor),
            self.fiscalYearButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // fiscalYearMarkLabel
        NSLayoutConstraint.activate([
            self.fiscalYearMarkLabel.topAnchor.constraint(equalTo: self.settingVacationButtonsView.topAnchor),
            self.fiscalYearMarkLabel.bottomAnchor.constraint(equalTo: self.settingVacationButtonsView.bottomAnchor),
            self.fiscalYearMarkLabel.leadingAnchor.constraint(equalTo: self.fiscalYearButton.trailingAnchor, constant: 5),
            self.fiscalYearMarkLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        // joiningDayButton
        NSLayoutConstraint.activate([
            self.joiningDayButton.centerYAnchor.constraint(equalTo: self.settingVacationButtonsView.centerYAnchor),
            self.joiningDayButton.heightAnchor.constraint(equalToConstant: 28),
            self.joiningDayButton.trailingAnchor.constraint(equalTo: self.joiningDayMarkLabel.leadingAnchor, constant: -5),
            self.joiningDayButton.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // joiningDayMarkLabel
        NSLayoutConstraint.activate([
            self.joiningDayMarkLabel.topAnchor.constraint(equalTo: self.settingVacationButtonsView.topAnchor),
            self.joiningDayMarkLabel.bottomAnchor.constraint(equalTo: self.settingVacationButtonsView.bottomAnchor),
            self.joiningDayMarkLabel.trailingAnchor.constraint(equalTo: self.settingVacationButtonsView.trailingAnchor),
            self.joiningDayMarkLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingNumberOfPaidHolidaysViewController {
    
}

// MARK: - Extension for selector methods
extension SettingNumberOfPaidHolidaysViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let calculatedDateRange = VacationModel.calculateVacationScheduleDateRange(self.annualPaidHolidaysType)
        
        let calculatedNumberOfVacationHold = VacationModel.calculateNumberOfVacationHold(startDate: calculatedDateRange.startDate, endDate: calculatedDateRange.endDate)
        
        if calculatedNumberOfVacationHold > self.numberOfAnnualPaidHolidays * 2 {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "휴가기준을 \(self.annualPaidHolidaysType == .fiscalYear ? "회계연도":"입사날짜")로 변경하면 연차 일수보다 예정(혹은 사용)된 휴가 일수가 많아집니다. 휴가 일수를 조정 후 휴가기준을 변경하세요.")
            
            return
        }
        
        if self.annualPaidHolidaysType != self.tempAnnualPaidHolidaysType {
            VacationModel.annualPaidHolidaysType = self.annualPaidHolidaysType
        }
        
        if self.tempNumberOfAnnualPaidHolidays != self.numberOfAnnualPaidHolidays {
            VacationModel.numberOfAnnualPaidHolidays = self.numberOfAnnualPaidHolidays
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    @objc func fiscalYearButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.annualPaidHolidaysType = .fiscalYear
        
        self.fiscalYearButton.isSelected = true
        self.joiningDayButton.isSelected = false
    }
    
    @objc func joiningDayButton(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        self.annualPaidHolidaysType = .joiningDay
        
        self.fiscalYearButton.isSelected = false
        self.joiningDayButton.isSelected = true
    }
}

// MARK: - Extension for UIPickerViewDelegate, UIPickerViewDataSource
extension SettingNumberOfPaidHolidaysViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.annualPaidHolidays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.annualPaidHolidays[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let calculatedDateRange = VacationModel.calculateVacationScheduleDateRange(self.annualPaidHolidaysType)
        
        let calculatedNumberOfVacationHold = VacationModel.calculateNumberOfVacationHold(startDate: calculatedDateRange.startDate, endDate: calculatedDateRange.endDate)
        
        if calculatedNumberOfVacationHold > self.annualPaidHolidays[row] * 2 {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "알림", andMessage: "사용한(혹은 사용할) 휴가 날 수보다 적게 설정할 수 없습니다.")
            
            pickerView.selectRow(self.annualPaidHolidays.firstIndex(of: calculatedNumberOfVacationHold > 99 * 2 ? 99 : calculatedNumberOfVacationHold % 2 > 0 ? calculatedNumberOfVacationHold / 2 + 1 : calculatedNumberOfVacationHold / 2)!, inComponent: 0, animated: true)
            
        } else {
            print("Number of annual paid holidays: \(self.annualPaidHolidays[row])")
            
            self.numberOfAnnualPaidHolidays = self.annualPaidHolidays[row]
        }
    }
}
