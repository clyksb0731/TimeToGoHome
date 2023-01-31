//
//  CalendarDayOfScheduleRecordCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/30.
//

import UIKit

class CalendarDayOfScheduleRecordCell: UICollectionViewCell {
    
    lazy var baseView: UIView = {
        let view = UIView()
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
    
    lazy var todayMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .Calendar.todayMark
        label.text = "오늘"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLineView: UIView = {
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
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: - Extension for essential methods
extension CalendarDayOfScheduleRecordCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.backgroundColor = .white
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
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
        
        // baseView
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // dayLabel
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
            self.morningPointView.trailingAnchor.constraint(equalTo: self.baseView.centerXAnchor, constant: -4),
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
            self.overtimePointView.leadingAnchor.constraint(equalTo: self.baseView.centerXAnchor, constant: 4),
            self.overtimePointView.widthAnchor.constraint(equalToConstant: 4)
        ])
        
        // todayMarkLabel
        NSLayoutConstraint.activate([
            self.todayMarkLabel.topAnchor.constraint(equalTo: self.dayLabel.bottomAnchor),
            self.todayMarkLabel.heightAnchor.constraint(equalToConstant: 12),
            self.todayMarkLabel.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
            self.todayMarkLabel.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
        ])
        
        // bottomLineView
        NSLayoutConstraint.activate([
            self.bottomLineView.topAnchor.constraint(equalTo: self.todayMarkLabel.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 3),
            self.bottomLineView.centerXAnchor.constraint(equalTo: self.baseView.centerXAnchor),
            self.bottomLineView.widthAnchor.constraint(equalToConstant: 27)
        ])
    }
}

// MARK: - Extension for methods added
extension CalendarDayOfScheduleRecordCell {
    func setItem(_ date: Date?,
                 recordedSchedule: WorkScheduleRecordModel? = nil,
                 isToday: Bool = false,
                 isSelected: Bool = false,
                 isEnable: Bool = false) {
        if let date = date {
            self.date = date
            self.baseView.isHidden = false
            
            let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(date)
            
            self.dayLabel.text = String(yearMonthDay.day)
            self.dayLabel.textColor = isEnable ? .black : .useRGB(red: 185, green: 185, blue: 185)
            self.dayLabel.font = isSelected ?
                .systemFont(ofSize: 18, weight: .heavy) : .systemFont(ofSize: 18, weight: .medium)
            
            if isToday {
                self.todayMarkLabel.isHidden = false
                
                self.morningPointView.backgroundColor = .clear
                self.afternoonPointView.backgroundColor = .clear
                self.overtimePointView.backgroundColor = .clear
                
            } else {
                self.todayMarkLabel.isHidden = true
                
                if let recordedSchedule = recordedSchedule {
                    if recordedSchedule.morning == .holiday && recordedSchedule.afternoon == .holiday {
                        self.morningPointView.backgroundColor = .clear
                        self.afternoonPointView.backgroundColor = .clear
                        
                    } else {
                        if let morning = recordedSchedule.morning {
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
                        
                        if let afternoon = recordedSchedule.afternoon {
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
                    
                    self.overtimePointView.backgroundColor = recordedSchedule.overtime != nil ? .Record.overtime : .clear
                    
                } else {
                    self.morningPointView.backgroundColor = .clear
                    self.afternoonPointView.backgroundColor = .clear
                    self.overtimePointView.backgroundColor = .clear
                }
            }
            
            self.bottomLineView.isHidden = !isSelected
            
        } else {
            self.baseView.isHidden = true
            self.date = nil
        }
    }
}
