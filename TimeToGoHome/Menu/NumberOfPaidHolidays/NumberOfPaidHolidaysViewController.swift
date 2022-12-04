//
//  NumberOfPaidHolidaysViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/04.
//

import UIKit

class NumberOfPaidHolidaysViewController: UIViewController {
    
    lazy var numberOfVacationsHoldLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .regular)
        label.text = "\(VacationModel.numberOfVacationsHold)"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var numberOfAnnualPaidHolidaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = " / \(self.numberOfAnnualPaidHolidays)일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var numberOfAnnualPaidHolidays: Int = {
        if let numberOfAnnualPaidHolidays = ReferenceValues.initialSetting[InitialSetting.annualPaidHolidays.rawValue] as? Int {
            return numberOfAnnualPaidHolidays
            
        } else {
            return 15
        }
    }() {
        didSet {
            self.numberOfAnnualPaidHolidaysLabel.text = " / \(self.numberOfAnnualPaidHolidays)일"
            
            ReferenceValues.initialSetting.updateValue(self.numberOfAnnualPaidHolidays, forKey: InitialSetting.annualPaidHolidays.rawValue)
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
            print("----------------------------------- NumberOfPaidHolidaysViewController disposed -----------------------------------")
    }

}

// MARK: - Extension for essential methods
extension NumberOfPaidHolidaysViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "휴가 사용 현황"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
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
            self.numberOfVacationsHoldLabel,
            self.numberOfAnnualPaidHolidaysLabel
        ], to: self.view)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // numberOfVacationsHoldLabel
        NSLayoutConstraint.activate([
            self.numberOfVacationsHoldLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 66),
            self.numberOfVacationsHoldLabel.trailingAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
        
        // numberOfAnnualPaidHolidaysLabel
        NSLayoutConstraint.activate([
            self.numberOfAnnualPaidHolidaysLabel.lastBaselineAnchor.constraint(equalTo: self.numberOfVacationsHoldLabel.lastBaselineAnchor),
            self.numberOfAnnualPaidHolidaysLabel.leadingAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension NumberOfPaidHolidaysViewController {
    
}

// MARK: - Extension for selector methods
extension NumberOfPaidHolidaysViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let menuCoverVC = MenuCoverViewController(.annualPaidHolidays(numberOfAnnualPaidHolidays: self.numberOfAnnualPaidHolidays), delegate: self)
        
        self.present(menuCoverVC, animated: false)
    }
}

// MARK: - Extension for MenuCoverDelegate
extension NumberOfPaidHolidaysViewController: MenuCoverDelegate {
    func menuCoverDidDetermineAnnualPaidHolidays(_ holidays: Int) {
        self.numberOfVacationsHoldLabel.text = "\(VacationModel.numberOfVacationsHold)일"
        
        self.numberOfAnnualPaidHolidays = holidays
    }
}
