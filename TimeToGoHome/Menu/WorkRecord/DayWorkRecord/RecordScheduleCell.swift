//
//  RecordScheduleCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/29.
//

import UIKit

class RecordScheduleCell: UITableViewCell {
    
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var scheduleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var timeTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var removeScheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var scheduleTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timeTypeLabelTopAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setViewFoundation()
        self.initializeObjects()
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - Extension for essential methods
extension RecordScheduleCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
            self.scheduleView
        ], to: baseView)
        
        SupportingMethods.shared.addSubviews([
            self.timeTypeLabel,
            self.removeScheduleButton,
            self.scheduleTypeLabel
        ], to: self.scheduleView)
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
        
        // scheduleView
        NSLayoutConstraint.activate([
            self.scheduleView.topAnchor.constraint(equalTo: self.baseView.topAnchor),
            self.scheduleView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: -10),
            self.scheduleView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 15),
            self.scheduleView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -15)
        ])
        
        // timeTypeLabel
        self.timeTypeLabelTopAnchor = self.timeTypeLabel.topAnchor.constraint(equalTo: self.scheduleView.topAnchor, constant: 16)
        self.timeTypeLabelTopAnchor.priority = UILayoutPriority(750)
        NSLayoutConstraint.activate([
            self.timeTypeLabelTopAnchor,
            self.timeTypeLabel.centerYAnchor.constraint(lessThanOrEqualTo: self.scheduleView.centerYAnchor),
            self.timeTypeLabel.leadingAnchor.constraint(equalTo: self.scheduleTypeLabel.trailingAnchor, constant: 5),
            self.timeTypeLabel.trailingAnchor.constraint(equalTo: self.scheduleView.trailingAnchor, constant: -20)
        ])
        
        // removeScheduleButton
        NSLayoutConstraint.activate([
            self.removeScheduleButton.leadingAnchor.constraint(equalTo: self.scheduleView.leadingAnchor, constant: 20),
            self.removeScheduleButton.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor)
        ])
        
        // scheduleTypeLabel
        NSLayoutConstraint.activate([
            self.scheduleTypeLabel.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor),
            self.scheduleTypeLabel.centerXAnchor.constraint(equalTo: self.scheduleView.centerXAnchor),
            self.scheduleTypeLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
}

// MARK: - Extension for methods added
extension RecordScheduleCell {
    func setCell(recordSchedule schedule: WorkScheduleRecordModel, isEditingMode: Bool, tag: Int) {
        self.tag = tag
        self.removeScheduleButton.tag = tag
        
        self.removeScheduleButton.isHidden = !isEditingMode
        
        if tag == 1, let morning = schedule.morning {
            self.timeTypeLabelTopAnchor.constant = 16
            self.timeTypeLabel.text = "오전"
            
            switch morning {
            case .work:
                self.scheduleView.backgroundColor = .Schedule.work
                self.timeTypeLabel.textColor = .white
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "근무"
                
            case .vacation:
                self.scheduleView.backgroundColor = .Schedule.vacation
                self.timeTypeLabel.textColor = .white
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴가"
                
            case .holiday:
                self.scheduleView.backgroundColor = .Schedule.holiday
                self.timeTypeLabel.textColor = .useRGB(red: 130, green: 130, blue: 130)
                self.scheduleTypeLabel.textColor = .useRGB(red: 130, green: 130, blue: 130)
                self.scheduleTypeLabel.text = "휴일"
            }
        }
        
        if tag == 2, let afternoon = schedule.afternoon {
            self.timeTypeLabelTopAnchor.constant = 16
            self.timeTypeLabel.text = "오후"
            
            switch afternoon {
            case .work:
                self.scheduleView.backgroundColor = .Schedule.work
                self.timeTypeLabel.textColor = .white
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "근무"
                
            case .vacation:
                self.scheduleView.backgroundColor = .Schedule.vacation
                self.timeTypeLabel.textColor = .white
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴가"
                
            case .holiday:
                self.scheduleView.backgroundColor = .Schedule.holiday
                self.timeTypeLabel.textColor = .useRGB(red: 130, green: 130, blue: 130)
                self.scheduleTypeLabel.textColor = .useRGB(red: 130, green: 130, blue: 130)
                self.scheduleTypeLabel.text = "휴일"
            }
        }
        
        if tag == 3, let overtime = schedule.overtime {
            self.timeTypeLabelTopAnchor.constant = 10
            self.timeTypeLabel.text = SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(overtime)
            self.scheduleView.backgroundColor = .Schedule.overtime
            self.timeTypeLabel.textColor = .white
            self.scheduleTypeLabel.textColor = .white
            self.scheduleTypeLabel.text = "추가 근무"
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.removeScheduleButton.addTarget(target, action: action, for: controlEvents)
    }
}
