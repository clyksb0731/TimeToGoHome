//
//  ScheduleTypeCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/11.
//

import UIKit

class ScheduleTypeCell: UITableViewCell {
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var scheduleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var timeTypeLabel: UILabel = { //meridianLabel
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var removeScheduleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var scheduleTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var timeTypeLabelTopAnchor: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setCellFoundation()
        self.initializeViews()
        self.setGestures()
        self.setNotificationCenters()
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

// MARK: Extension for essential methods
extension ScheduleTypeCell {
    // Set view foundation
    func setCellFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
            self.scheduleView
        ], to: self.baseView)
        
        SupportingMethods.shared.addSubviews([
            self.timeTypeLabel,
            self.removeScheduleButton,
            self.scheduleTypeLabel
        ], to: self.scheduleView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // Base view layout
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Schedule view layout
        NSLayoutConstraint.activate([
            self.scheduleView.topAnchor.constraint(equalTo: self.baseView.topAnchor),
            self.scheduleView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: -10),
            self.scheduleView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 10),
            self.scheduleView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -10)
        ])
        
        // Time type label layout
        self.timeTypeLabelTopAnchor = self.timeTypeLabel.topAnchor.constraint(equalTo: self.scheduleView.topAnchor, constant: 16)
        self.timeTypeLabelTopAnchor.priority = UILayoutPriority(750)
        NSLayoutConstraint.activate([
            self.timeTypeLabelTopAnchor,
            self.timeTypeLabel.centerYAnchor.constraint(lessThanOrEqualTo: self.scheduleView.centerYAnchor),
            self.timeTypeLabel.leadingAnchor.constraint(equalTo: self.scheduleTypeLabel.trailingAnchor, constant: 5),
            self.timeTypeLabel.trailingAnchor.constraint(equalTo: self.scheduleView.trailingAnchor, constant: -25)
        ])
        
        // Remove schedule button layout
        NSLayoutConstraint.activate([
            self.removeScheduleButton.leadingAnchor.constraint(equalTo: self.scheduleView.leadingAnchor, constant: 25),
            self.removeScheduleButton.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor)
        ])
        
        // Schedule type label layout
        NSLayoutConstraint.activate([
            self.scheduleTypeLabel.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor),
            self.scheduleTypeLabel.centerXAnchor.constraint(equalTo: self.scheduleView.centerXAnchor),
            self.scheduleTypeLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
}

// MARK: - Methods added
extension ScheduleTypeCell {
    func setCell(schedule: WorkScheduleModel, isEditingMode: Bool, tag: Int) {
        self.timeTypeLabelTopAnchor.constant = 16
        
        self.tag = tag
        self.removeScheduleButton.tag = tag
        
        if tag == 1, case .morning(let workTimeType) = schedule.morning {
            self.timeTypeLabel.text = "오전"
            self.removeScheduleButton.isHidden = !isEditingMode
            
            switch workTimeType {
            case .holiday:
                self.scheduleView.backgroundColor = .Schedule.holiday
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴일"
                
            case .work:
                self.scheduleView.backgroundColor = .Schedule.work
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "근무"
                
            case .vacation:
                self.scheduleView.backgroundColor = .Schedule.vacation
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴가"
            }
        }
        
        if tag == 2, case .afternoon(let workTimeType) = schedule.afternoon {
            self.timeTypeLabel.text = "오후"
            self.removeScheduleButton.isHidden = !isEditingMode
            
            switch workTimeType {
            case .holiday:
                self.scheduleView.backgroundColor = .Schedule.holiday
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴일"
                
            case .work:
                self.scheduleView.backgroundColor = .Schedule.work
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "근무"
                
            case .vacation:
                self.scheduleView.backgroundColor = .Schedule.vacation
                self.timeTypeLabel.textColor = .white
                self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
                self.scheduleTypeLabel.textColor = .white
                self.scheduleTypeLabel.text = "휴가"
            }
        }
        
        if tag == 3, case .overtime(let overtime) = schedule.overtime {
            self.timeTypeLabelTopAnchor.constant = 10
            self.timeTypeLabel.text = "\(SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(Int(overtime.timeIntervalSinceReferenceDate)-schedule.finishingRegularWorkTimeSecondsSinceReferenceDate!))"
            
            self.scheduleView.backgroundColor = .Schedule.overtime
            self.timeTypeLabel.textColor = .white
            self.removeScheduleButton.setImage(UIImage(named: "removeScheduleButtonWhiteImage"), for: .normal)
            self.scheduleTypeLabel.textColor = .white
            self.scheduleTypeLabel.text = "추가 근무"
            
            self.removeScheduleButton.isHidden = !isEditingMode
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.removeScheduleButton.addTarget(target, action: action, for: controlEvents)
    }
}
