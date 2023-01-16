//
//  VacationUsageViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/04.
//

import UIKit

class VacationUsageViewController: UIViewController {
    
    lazy var yearMonthButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "previousMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "previousMonthDisableButton"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(perviousMonthButton(_:)), for: .touchUpInside)
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate).month)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var yearMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.text = "\(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year)년 \(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month)월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "nextMonthNormalButton"), for: .normal)
        button.setImage(UIImage(named: "nextMonthDisableButton"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(nextMonthButton(_:)), for: .touchUpInside)
        button.isEnabled = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month) != SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate).month)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var calendarBaseView: UIView = {
        let previousMonthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(previousMonthSwipeGesture(_:)))
        let nextMonthSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextMonthSwipeGesure(_:)))
        
        previousMonthSwipe.direction = .right
        nextMonthSwipe.direction = .left
        
        let view = UIView()
        view.addGestureRecognizer(previousMonthSwipe)
        view.addGestureRecognizer(nextMonthSwipe)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var calendarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 45, height: 45)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.headerReferenceSize = CGSize(width: 315, height: 21)
        flowLayout.footerReferenceSize = .zero
        
        //let collectionView = UICollectionView()
        //collectionView.collectionViewLayout = flowLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(CalendarDayOfVacationUsageCell.self, forCellWithReuseIdentifier: "CalendarDayOfVacationUsageCell")
        collectionView.register(CalendarHeaderOfVacationUsageView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderOfVacationUsageView")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 151, green: 151, blue: 151)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var numberOfVacationMarkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .useRGB(red: 197, green: 199, blue: 201)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "휴가 (\(VacationModel.annualPaidHolidaysType == .fiscalYear ? "회계연도" : "입사날짜"))"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var numberOfVacationLabel: UILabel = {
        let numberOfVacationsHold = VacationModel.numberOfVacationsHold
        
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "\((Int(numberOfVacationsHold * 10)) % 10 == 0 ? "\(Int(numberOfVacationsHold))" : "\(numberOfVacationsHold)")일 | \(self.numberOfAnnualPaidHolidays)일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var vacationSettingButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningVacationButtonView: VacationButtonView = {
        let buttonView = VacationButtonView(title: "오전")
        buttonView.tag = 1
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.isEnable = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    lazy var afternoonVacationButtonView: VacationButtonView = {
        let buttonView = VacationButtonView(title: "오후")
        buttonView.tag = 2
        buttonView.addTarget(self, action: #selector(vacationButton(_:)), for: .touchUpInside)
        buttonView.isEnable = false
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonView
    }()
    
    var todayDateComponents: DateComponents = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        return dateComponents
    }()
    
    var targetYearMonthDate: Date = {
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        
        return SupportingMethods.shared.makeDateWithYear(yearMonthDay.year, month: yearMonthDay.month)
    }()
    
    var selectedIndexOfYearMonthAndDay: (year: Int, month: Int, day: Int)?
    
    lazy var vacationScheduleDateRange: (startDate: Date, endDate: Date) = {
        return VacationModel.determineVacationScheduleDateRange()
    }()
    
    var numberOfAnnualPaidHolidays: Int = {
        if let numberOfAnnualPaidHolidays = ReferenceValues.initialSetting[InitialSetting.annualPaidHolidays.rawValue] as? Int {
            return numberOfAnnualPaidHolidays
            
        } else {
            return 15
        }
    }()
    
    var holidays: Set<Int> = {
        if let holidays = ReferenceValues.initialSetting[InitialSetting.regularHolidays.rawValue] as? [Int] {
            return Set(holidays)
            
        } else {
            return [1,7]
        }
    }()

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
            print("----------------------------------- VacationUsageViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension VacationUsageViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "휴가 일정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    func initializeObjects() {
        VacationModel.observe {
            self.calendarCollectionView.reloadData()
            
            DispatchQueue.main.async {
                let numberOfVacationsHold = VacationModel.numberOfVacationsHold
                self.numberOfVacationLabel.text = "\((Int(numberOfVacationsHold * 10)) % 10 == 0 ? "\(Int(numberOfVacationsHold))" : "\(numberOfVacationsHold)")일 | \(self.numberOfAnnualPaidHolidays)일"
                
                SupportingMethods.shared.turnCoverView(.off, on: self.view)
            }
        }
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.yearMonthButtonView,
            self.calendarBaseView,
            self.separatorLineView,
            self.numberOfVacationMarkLabel,
            self.numberOfVacationLabel,
            self.vacationSettingButtonView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.previousMonthButton,
            self.yearMonthLabel,
            self.nextMonthButton
        ], to: self.yearMonthButtonView)
        
        SupportingMethods.shared.addSubviews([
            self.calendarCollectionView
        ], to: self.calendarBaseView)
        
        SupportingMethods.shared.addSubviews([
            self.morningVacationButtonView,
            self.afternoonVacationButtonView
        ], to: self.vacationSettingButtonView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // yearMonthButtonView
        NSLayoutConstraint.activate([
            self.yearMonthButtonView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 17),
            self.yearMonthButtonView.heightAnchor.constraint(equalToConstant: 21),
            self.yearMonthButtonView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.yearMonthButtonView.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // perviousMonthButton
        NSLayoutConstraint.activate([
            self.previousMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
            self.previousMonthButton.heightAnchor.constraint(equalToConstant: 21),
            self.previousMonthButton.leadingAnchor.constraint(equalTo: self.yearMonthButtonView.leadingAnchor),
            self.previousMonthButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        // yearMonthLabel
        NSLayoutConstraint.activate([
            self.yearMonthLabel.topAnchor.constraint(equalTo: self.yearMonthButtonView.topAnchor),
            self.yearMonthLabel.bottomAnchor.constraint(equalTo: self.yearMonthButtonView.bottomAnchor),
            self.yearMonthLabel.leadingAnchor.constraint(equalTo: self.previousMonthButton.trailingAnchor),
            self.yearMonthLabel.trailingAnchor.constraint(equalTo: self.nextMonthButton.leadingAnchor)
        ])
        
        // nextMonthButton
        NSLayoutConstraint.activate([
            self.nextMonthButton.centerYAnchor.constraint(equalTo: self.yearMonthButtonView.centerYAnchor),
            self.nextMonthButton.heightAnchor.constraint(equalToConstant: 21),
            self.nextMonthButton.trailingAnchor.constraint(equalTo: self.yearMonthButtonView.trailingAnchor),
            self.nextMonthButton.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        // calendarBaseView
        NSLayoutConstraint.activate([
            self.calendarBaseView.topAnchor.constraint(equalTo: self.yearMonthButtonView.bottomAnchor, constant: 26),
            self.calendarBaseView.heightAnchor.constraint(equalToConstant: 21 + 45 * 6),
            self.calendarBaseView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.calendarBaseView.widthAnchor.constraint(equalToConstant: 7 * 45)
        ])
        
        // calendarCollectionView
        SupportingMethods.shared.makeConstraintsOf(self.calendarCollectionView, sameAs: self.calendarBaseView)
        
        // separatorLineView
        NSLayoutConstraint.activate([
            self.separatorLineView.topAnchor.constraint(equalTo: self.calendarCollectionView.bottomAnchor),
            self.separatorLineView.heightAnchor.constraint(equalToConstant: 1),
            self.separatorLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            self.separatorLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
        ])
        
        // numberOfVacationMarkLabel
        NSLayoutConstraint.activate([
            self.numberOfVacationMarkLabel.topAnchor.constraint(equalTo: self.separatorLineView.bottomAnchor, constant: 24),
            self.numberOfVacationMarkLabel.heightAnchor.constraint(equalToConstant: 21),
            self.numberOfVacationMarkLabel.leadingAnchor.constraint(equalTo: self.separatorLineView.leadingAnchor, constant: 5)
        ])
        
        // numberOfVacationLabel
        NSLayoutConstraint.activate([
            self.numberOfVacationLabel.topAnchor.constraint(equalTo: self.separatorLineView.bottomAnchor, constant: 24),
            self.numberOfVacationLabel.heightAnchor.constraint(equalToConstant: 21),
            self.numberOfVacationLabel.trailingAnchor.constraint(equalTo: self.separatorLineView.trailingAnchor, constant: -24)
        ])
        
        // vacationSettingButtonView
        NSLayoutConstraint.activate([
            self.vacationSettingButtonView.topAnchor.constraint(equalTo: self.numberOfVacationLabel.bottomAnchor, constant: 30),
            self.vacationSettingButtonView.heightAnchor.constraint(equalToConstant: 44),
            self.vacationSettingButtonView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.vacationSettingButtonView.widthAnchor.constraint(equalToConstant: 159)
        ])
        
        // morningVacationButtonView
        NSLayoutConstraint.activate([
            self.morningVacationButtonView.topAnchor.constraint(equalTo: self.vacationSettingButtonView.topAnchor),
            self.morningVacationButtonView.bottomAnchor.constraint(equalTo: self.vacationSettingButtonView.bottomAnchor),
            self.morningVacationButtonView.leadingAnchor.constraint(equalTo: self.vacationSettingButtonView.leadingAnchor),
            self.morningVacationButtonView.widthAnchor.constraint(equalToConstant: 77)
        ])
        
        // afternoonVacationButtonView
        NSLayoutConstraint.activate([
            self.afternoonVacationButtonView.topAnchor.constraint(equalTo: self.vacationSettingButtonView.topAnchor),
            self.afternoonVacationButtonView.bottomAnchor.constraint(equalTo: self.vacationSettingButtonView.bottomAnchor),
            self.afternoonVacationButtonView.leadingAnchor.constraint(equalTo: self.morningVacationButtonView.trailingAnchor, constant: 5),
            self.afternoonVacationButtonView.widthAnchor.constraint(equalToConstant: 77)
        ])
    }
}

// MARK: - Extension for methods added
extension VacationUsageViewController {
    func moveToPreviousMonth() {
        let startingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate)
        let endingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate)
        
        guard self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingVacationRangeYearMonth.year, month: startingVacationRangeYearMonth.month) else {
            
            return
        }
        
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month -= 1
        if month == 0 {
            year -= 1
            month = 12
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingVacationRangeYearMonth.year, month: startingVacationRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingVacationRangeYearMonth.year, month: endingVacationRangeYearMonth.month)
        
        //UIDevice.lightHaptic()
        
        self.morningVacationButtonView.isEnable = false
        self.morningVacationButtonView.isSelected = false
        self.afternoonVacationButtonView.isEnable = false
        self.afternoonVacationButtonView.isSelected = false
    }
    
    func moveToNextMonth() {
        let startingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate)
        let endingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate)
        
        guard self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingVacationRangeYearMonth.year, month: endingVacationRangeYearMonth.month) else {
            
            return
        }
        
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingVacationRangeYearMonth.year, month: startingVacationRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingVacationRangeYearMonth.year, month: endingVacationRangeYearMonth.month)
        
        //UIDevice.lightHaptic()
        
        self.morningVacationButtonView.isEnable = false
        self.morningVacationButtonView.isSelected = false
        self.afternoonVacationButtonView.isEnable = false
        self.afternoonVacationButtonView.isSelected = false
    }
}

// MARK: - Extension for selector methods
extension VacationUsageViewController {
    @objc func leftBarButtonItem(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func previousMonthSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.moveToPreviousMonth()
    }
    
    @objc func nextMonthSwipeGesure(_ sender: UISwipeGestureRecognizer) {
        self.moveToNextMonth()
    }
    
    @objc func perviousMonthButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.moveToPreviousMonth()
        
        /*
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month -= 1
        if month == 0 {
            year -= 1
            month = 12
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        let startingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate)
        let endingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate)
        
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingVacationRangeYearMonth.year, month: startingVacationRangeYearMonth.month)
        self.nextMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingVacationRangeYearMonth.year, month: endingVacationRangeYearMonth.month)
        
        UIDevice.lightHaptic()
        
        self.morningVacationButtonView.isEnable = false
        self.morningVacationButtonView.isSelected = false
        self.afternoonVacationButtonView.isEnable = false
        self.afternoonVacationButtonView.isSelected = false
        */
    }
    
    @objc func nextMonthButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.moveToNextMonth()
        
        /*
        self.selectedIndexOfYearMonthAndDay = nil
        
        let initialYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate)
        
        var year = initialYearMonth.year
        var month = initialYearMonth.month
        
        month += 1
        if month > 12 {
            year += 1
            month = 1
        }
        self.targetYearMonthDate = SupportingMethods.shared.makeDateWithYear(year, month: month)
        
        self.calendarCollectionView.reloadData()
        
        self.yearMonthLabel.text = "\(year)년 \(month)월"
        
        let startingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.startDate)
        let endingVacationRangeYearMonth = SupportingMethods.shared.getYearMonthAndDayOf(self.vacationScheduleDateRange.endDate)
        
        self.previousMonthButton.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(startingVacationRangeYearMonth.year, month: startingVacationRangeYearMonth.month)
        sender.isEnabled = self.targetYearMonthDate != SupportingMethods.shared.makeDateWithYear(endingVacationRangeYearMonth.year, month: endingVacationRangeYearMonth.month)
        
        UIDevice.lightHaptic()
        
        self.morningVacationButtonView.isEnable = false
        self.morningVacationButtonView.isSelected = false
        self.afternoonVacationButtonView.isEnable = false
        self.afternoonVacationButtonView.isSelected = false
        */
    }
    
    @objc func vacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        SupportingMethods.shared.turnCoverView(.on, on: self.view)
        
        if let buttonView = sender.superview as? VacationButtonView {
            buttonView.isSelected.toggle()
            
            var vacation: Vacation!
            
            if buttonView.tag == 1 {
                print("morning")
                
                if buttonView.isSelected {
                    if self.afternoonVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .fullDay)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .morning)
                    }
                    
                } else {
                    if self.afternoonVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .afternoon)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .none)
                    }
                }
                
            } else {
                print("afternoon")
                
                if buttonView.isSelected {
                    if self.morningVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .fullDay)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .afternoon)
                    }
                    
                } else {
                    if self.morningVacationButtonView.isSelected {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .morning)
                        
                    } else {
                        vacation = Vacation(date: SupportingMethods.shared.makeDateWithYear(self.selectedIndexOfYearMonthAndDay!.year, month: self.selectedIndexOfYearMonthAndDay!.month, andDay: self.selectedIndexOfYearMonthAndDay!.day), vacationType: .none)
                    }
                }
            }
            
            VacationModel.addVacation(vacation)
        }
    }
}

// MARK: - Extension for UICollectionViewDelegate, UICollectionViewDataSource
extension VacationUsageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // weekday of 1st - 1 + days of month -> full items
        return SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 1 + SupportingMethods.shared.getDaysOfMonthFor(self.targetYearMonthDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayOfVacationUsageCell", for: indexPath) as! CalendarDayOfVacationUsageCell
        
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        
        if day >= 1 {
            let isToday: Bool = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == self.todayDateComponents.year! &&
            SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == self.todayDateComponents.month! &&
            day == self.todayDateComponents.day!
            
            var isSelected = false
            if let selectedIndexOfYearMonthAndDay = self.selectedIndexOfYearMonthAndDay {
            isSelected = SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year == selectedIndexOfYearMonthAndDay.year &&
                SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month == selectedIndexOfYearMonthAndDay.month &&
                day == selectedIndexOfYearMonthAndDay.day
            }
            
            let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
            
            let isEnable = (dateOfDay >= self.vacationScheduleDateRange.startDate &&
                            dateOfDay <= self.vacationScheduleDateRange.endDate) && !(self.holidays.contains(SupportingMethods.shared.getWeekdayOfDate(dateOfDay))) &&
            !PublicHolidayModel.publicHolidays.contains {
                $0.dateId == Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: dateOfDay))
            }
            
            let vacation = VacationModel(date: dateOfDay).vacation
            
            item.setItem(dateOfDay,
                         day: day,
                         isToday: isToday,
                         isSelected: isSelected,
                         isEnable: isEnable,
                         vacationType: vacation == nil ?
                         VacationType.none : VacationType(rawValue: vacation!.vacationType))
            
        } else {
            item.setItem(nil)
        }
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CalendarHeaderOfVacationUsageView", for: indexPath) as! CalendarHeaderOfVacationUsageView
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.item - (SupportingMethods.shared.getFirstWeekdayFor(self.targetYearMonthDate) - 2)
        let dateOfDay = SupportingMethods.shared.makeDateWithYear(SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year, month: SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month, andDay: day)
        
        guard (dateOfDay >= self.vacationScheduleDateRange.startDate && dateOfDay <= self.vacationScheduleDateRange.endDate) && !(self.holidays.contains(SupportingMethods.shared.getWeekdayOfDate(dateOfDay))) &&
        !PublicHolidayModel.publicHolidays.contains(where: { $0.dateId == Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: dateOfDay)) }) else {
            return
        }
        
        UIDevice.lightHaptic()
        
        if let _ = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date).getScheduleOn(dateOfDay) {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "수정 불가", andMessage: "이미 정해진 스케쥴이 있습니다. 스케쥴을 수정하세요.",
                                               okAction: UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.selectedIndexOfYearMonthAndDay = nil
            
            self.morningVacationButtonView.isEnable = false
            self.afternoonVacationButtonView.isEnable = false
            
            self.morningVacationButtonView.isSelected = false
            self.afternoonVacationButtonView.isSelected = false
            
        } else {
            self.selectedIndexOfYearMonthAndDay = (SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).year,
                                                   SupportingMethods.shared.getYearMonthAndDayOf(self.targetYearMonthDate).month,
                                                   day)
            
            self.morningVacationButtonView.isEnable = true
            self.afternoonVacationButtonView.isEnable = true
            
            if let vacation = VacationModel(date: dateOfDay).vacation {
                switch VacationType(rawValue: vacation.vacationType)! {
                case .none:
                    self.morningVacationButtonView.isSelected = false
                    self.afternoonVacationButtonView.isSelected = false
                    
                case .morning:
                    self.morningVacationButtonView.isSelected = true
                    self.afternoonVacationButtonView.isSelected = false
                    
                case .afternoon:
                    self.morningVacationButtonView.isSelected = false
                    self.afternoonVacationButtonView.isSelected = true
                    
                case .fullDay:
                    self.morningVacationButtonView.isSelected = true
                    self.afternoonVacationButtonView.isSelected = true
                }
                
            } else {
                self.morningVacationButtonView.isSelected = false
                self.afternoonVacationButtonView.isSelected = false
            }
        }
        
        collectionView.reloadData()
    }
}
