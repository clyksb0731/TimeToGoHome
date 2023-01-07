//
//  WorkRecordCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/27.
//

import UIKit

class WorkRecordCell: UITableViewCell {
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningBar: UIView = {
        let view = UIView()
        view.backgroundColor = .Schedule.holiday
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonBar: UIView = {
        let view = UIView()
        view.backgroundColor = .Schedule.holiday
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimeBar: UIView = {
        let view = UIView()
        view.backgroundColor = .Schedule.overtime
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    var dateId: Int = 0
    
    var overtimeWidthAnchor: NSLayoutConstraint!

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
extension WorkRecordCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.dayLabel,
            self.morningBar,
            self.afternoonBar,
            self.overtimeBar,
            self.workTimeLabel,
            self.bottomLineView
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // dayLabel
        NSLayoutConstraint.activate([
            self.dayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            self.dayLabel.heightAnchor.constraint(equalToConstant: 20),
            self.dayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),
            self.dayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20)
        ])
        
        // morningBar
        NSLayoutConstraint.activate([
            self.morningBar.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.morningBar.heightAnchor.constraint(equalToConstant: 24),
            self.morningBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 80),
            self.morningBar.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        // afternoonBar
        NSLayoutConstraint.activate([
            self.afternoonBar.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.afternoonBar.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonBar.leadingAnchor.constraint(equalTo: self.morningBar.trailingAnchor, constant: 5),
            self.afternoonBar.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        // overtimeBar
        self.overtimeWidthAnchor = self.overtimeBar.widthAnchor.constraint(equalToConstant: 12)
        NSLayoutConstraint.activate([
            self.overtimeBar.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.overtimeBar.heightAnchor.constraint(equalToConstant: 24),
            self.overtimeBar.leadingAnchor.constraint(equalTo: self.afternoonBar.trailingAnchor, constant: 5),
            self.overtimeWidthAnchor
        ])
        
        // workTimeLabel
        NSLayoutConstraint.activate([
            self.workTimeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            self.workTimeLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            self.workTimeLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24)
        ])
        
        // bottomLineView
        NSLayoutConstraint.activate([
            self.bottomLineView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.bottomLineView.heightAnchor.constraint(equalToConstant: 0.5),
            self.bottomLineView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.bottomLineView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: Extension for methods added
extension WorkRecordCell {
    func setCell(dateId: Int, day: Int,
                 morning: WorkTimeType, afternoon: WorkTimeType, overtime: Int?) {
        self.dateId = dateId
        
        self.dayLabel.text = "\(day)일"
        
        var workTime: Int = 0
        // Morning Bar
        switch morning {
        case .work:
            self.morningBar.backgroundColor = .Schedule.work
            workTime += 3600 * 4
            
        case .vacation:
            self.morningBar.backgroundColor = .Schedule.vacation
            
        case .holiday:
            self.morningBar.backgroundColor = .Schedule.holiday
        }
        
        // Afternoon Bar
        switch afternoon {
        case .work:
            self.afternoonBar.backgroundColor = .Schedule.work
            workTime += 3600 * 4
            
        case .vacation:
            self.afternoonBar.backgroundColor = .Schedule.vacation
            
        case .holiday:
            self.afternoonBar.backgroundColor = .Schedule.holiday
        }
        
        if let overtime = overtime {
            workTime += overtime
            
            var overtimeMultiplier = 0
            if Double(overtime) / 3600 >= 0 {
                overtimeMultiplier = 1
            }
            if Double(overtime) / 3600 > 1 {
                overtimeMultiplier = 2
            }
            if Double(overtime) / 3600 > 2 {
                overtimeMultiplier = 3
            }
            if Double(overtime) / 3600 > 3 {
                overtimeMultiplier = 4
            }
            
            self.overtimeWidthAnchor.constant = 12 * CGFloat(overtimeMultiplier)
            self.overtimeBar.isHidden = false
            
        } else {
            self.overtimeWidthAnchor.constant = 12
            self.overtimeBar.isHidden = true
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        self.workTimeLabel.attributedText = SupportingMethods.shared.makeHourAndMinuteAttributedStringUsingSecond(workTime, withValueAttributes: [
            .font:UIFont.systemFont(ofSize: 13),
            .foregroundColor:UIColor.black,
            .paragraphStyle:paragraphStyle
        ], andWithMarkAttributes: [
            .font:UIFont.systemFont(ofSize: 13),
            .foregroundColor:UIColor.useRGB(red: 60, green: 60, blue: 67, alpha: 0.6),
            .paragraphStyle:paragraphStyle
        ])
    }
}
