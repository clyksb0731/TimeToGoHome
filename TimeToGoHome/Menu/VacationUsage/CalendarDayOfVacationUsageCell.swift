//
//  CalendarDayOfVacationUsageCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/04.
//

import UIKit

class CalendarDayOfVacationUsageCell: UICollectionViewCell {
    lazy private var baseView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy private var morningVacationShapeView: UIView = {
        let halfView = UIView()
        halfView.backgroundColor = .Calendar.vacation
        halfView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.layer.borderColor = UIColor.Calendar.vacation.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(halfView)
        
        NSLayoutConstraint.activate([
            halfView.topAnchor.constraint(equalTo: view.topAnchor),
            halfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            halfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            halfView.trailingAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    lazy private var afternoonVacationShapeView: UIView = {
        let halfView = UIView()
        halfView.backgroundColor = .Calendar.vacation
        halfView.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.layer.borderColor = UIColor.Calendar.vacation.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(halfView)
        
        NSLayoutConstraint.activate([
            halfView.topAnchor.constraint(equalTo: view.topAnchor),
            halfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            halfView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            halfView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    lazy private var fullDayVacationShapeView: UIView = {
        let view = UIView()
        view.backgroundColor = .Calendar.vacation
        view.layer.cornerRadius = 14
        view.clipsToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningPointView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonPointView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimePointView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy private var todayMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .Calendar.todayMark
        label.text = "오늘"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy private var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .Calendar.selectedDayBottomLine
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) var date: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setViewFoundation()
        self.setSubview()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for essential methods
extension CalendarDayOfVacationUsageCell {
    func setViewFoundation() {
        self.backgroundColor = .white
    }
    
    func setSubview() {
        SupportingMethods.shared.addSubviews([
            self.baseView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
            self.morningVacationShapeView,
            self.afternoonVacationShapeView,
            self.fullDayVacationShapeView,
            self.dayLabel,
            self.morningPointView,
            self.afternoonPointView,
            self.overtimePointView,
            self.todayMarkLabel,
            self.bottomLineView
        ], to: self.baseView)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // baseView layout
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // morningVacationShapeView layout
        NSLayoutConstraint.activate([
            self.morningVacationShapeView.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 1),
            self.morningVacationShapeView.heightAnchor.constraint(equalToConstant: 28),
            self.morningVacationShapeView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.morningVacationShapeView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // afternoonVacationShapeView layout
        NSLayoutConstraint.activate([
            self.afternoonVacationShapeView.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 1),
            self.afternoonVacationShapeView.heightAnchor.constraint(equalToConstant: 28),
            self.afternoonVacationShapeView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.afternoonVacationShapeView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // fullDayVacationShapeView layout
        NSLayoutConstraint.activate([
            self.fullDayVacationShapeView.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 1),
            self.fullDayVacationShapeView.heightAnchor.constraint(equalToConstant: 28),
            self.fullDayVacationShapeView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.fullDayVacationShapeView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        // dayLabel layout
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: self.baseView.topAnchor),
            self.dayLabel.heightAnchor.constraint(equalToConstant: 30),
            self.dayLabel.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
            self.dayLabel.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
        ])
        
        // morningPointView
        NSLayoutConstraint.activate([
            self.morningPointView.centerYAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 6),
            self.morningPointView.heightAnchor.constraint(equalToConstant: 4),
            self.morningPointView.trailingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 15),
            self.morningPointView.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        // afternoonPointView
        NSLayoutConstraint.activate([
            self.afternoonPointView.centerYAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 6),
            self.afternoonPointView.heightAnchor.constraint(equalToConstant: 4),
            self.afternoonPointView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.afternoonPointView.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        // overtimePointView
        NSLayoutConstraint.activate([
            self.overtimePointView.centerYAnchor.constraint(equalTo: self.dayLabel.bottomAnchor, constant: 6),
            self.overtimePointView.heightAnchor.constraint(equalToConstant: 4),
            self.overtimePointView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 30),
            self.overtimePointView.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        // todayMarkLabel layout
        NSLayoutConstraint.activate([
            self.todayMarkLabel.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor),
            self.todayMarkLabel.heightAnchor.constraint(equalToConstant: 12),
            self.todayMarkLabel.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
            self.todayMarkLabel.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
        ])
        
        // bottomLineView layout
        NSLayoutConstraint.activate([
            self.bottomLineView.topAnchor.constraint(equalTo: self.todayMarkLabel.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 3),
            self.bottomLineView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.bottomLineView.widthAnchor.constraint(equalToConstant: 27)
        ])
    }
}

// MARK: - Extension for methods added
extension CalendarDayOfVacationUsageCell {
    func setItem(_ date: Date?,
                 day: Int = 0,
                 isToday: Bool = false,
                 isSelected: Bool = false,
                 isEnable: Bool = false,
                 vacationType: VacationType? = VacationType.none) {
        
        if let date = date {
            self.baseView.isHidden = false
            self.date = date
            
            self.dayLabel.text = "\(day)"
            self.dayLabel.textColor = isEnable ? .black : .useRGB(red: 185, green: 185, blue: 185)
            
            if let vacationType = vacationType {
                switch vacationType {
                case .none:
                    self.morningVacationShapeView.isHidden = true
                    self.afternoonVacationShapeView.isHidden = true
                    self.fullDayVacationShapeView.isHidden = true
                    
                case .morning:
                    self.morningVacationShapeView.isHidden = false
                    self.afternoonVacationShapeView.isHidden = true
                    self.fullDayVacationShapeView.isHidden = true
                    
                case .afternoon:
                    self.morningVacationShapeView.isHidden = true
                    self.afternoonVacationShapeView.isHidden = false
                    self.fullDayVacationShapeView.isHidden = true
                    
                case .fullDay:
                    self.morningVacationShapeView.isHidden = true
                    self.afternoonVacationShapeView.isHidden = true
                    self.fullDayVacationShapeView.isHidden = false
                }
                
            } else {
                self.morningVacationShapeView.isHidden = true
                self.afternoonVacationShapeView.isHidden = true
                self.fullDayVacationShapeView.isHidden = true
            }
            
            if isToday {
                self.todayMarkLabel.isHidden = false
                
                self.morningPointView.backgroundColor = .clear
                self.afternoonPointView.backgroundColor = .clear
                self.overtimePointView.backgroundColor = .clear
                
            } else {
                self.todayMarkLabel.isHidden = true
                
                if let joiningDate = ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as? Date {
                    let companyModel = CompanyModel(joiningDate: joiningDate)
                    if let schedule = companyModel.getScheduleOn(date) {
                        if schedule.morning == WorkTimeType.holiday.rawValue && schedule.afternoon == WorkTimeType.holiday.rawValue {
                            self.morningPointView.backgroundColor = .clear
                            self.afternoonPointView.backgroundColor = .clear
                            
                        } else {
                            if let morning = WorkTimeType(rawValue: schedule.morning) {
                                switch morning {
                                case .work:
                                    self.morningPointView.backgroundColor = .Record.work
                                    
                                case .vacation:
                                    self.morningPointView.backgroundColor = .Record.vacation
                                    
                                case .holiday:
                                    self.morningPointView.backgroundColor = .Record.holiday
                                }
                                
                            } else {
                                self.morningPointView.backgroundColor = .clear
                            }
                            
                            if let afternoon = WorkTimeType(rawValue: schedule.afternoon) {
                                switch afternoon {
                                case .work:
                                    self.afternoonPointView.backgroundColor = .Record.work
                                    
                                case .vacation:
                                    self.afternoonPointView.backgroundColor = .Record.vacation
                                    
                                case .holiday:
                                    self.afternoonPointView.backgroundColor = .Record.holiday
                                }
                                
                            } else {
                                self.afternoonPointView.backgroundColor = .clear
                            }
                        }
                        
                        self.overtimePointView.backgroundColor = schedule.overtime != nil ? .Record.overtime : .clear
                        
                    } else {
                        self.morningPointView.backgroundColor = .clear
                        self.afternoonPointView.backgroundColor = .clear
                        self.overtimePointView.backgroundColor = .clear
                    }
                }
            }
            
            self.bottomLineView.isHidden = !isSelected
            
        } else {
            self.baseView.isHidden = true
            self.date = nil
        }
    }
}
