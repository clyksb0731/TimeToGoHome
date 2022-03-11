//
//  SchedulingCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/11.
//

import UIKit

class SchedulingCell: UITableViewCell {
    lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var scheduleView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 235, green: 235, blue: 235)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var scheduleTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
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
extension SchedulingCell {
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
            self.scheduleView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: -7),
            self.scheduleView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: 5),
            self.scheduleView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: -5)
        ])
        
        // Schedule type label layout
        NSLayoutConstraint.activate([
            self.scheduleTypeLabel.centerYAnchor.constraint(equalTo: self.scheduleView.centerYAnchor),
            self.scheduleTypeLabel.centerXAnchor.constraint(equalTo: self.scheduleView.centerXAnchor)
        ])
    }
}

// MARK: - Methods added
extension SchedulingCell {
    func setCell(scheduleTypeText: String) {
        self.scheduleTypeLabel.text = scheduleType
    }
}
