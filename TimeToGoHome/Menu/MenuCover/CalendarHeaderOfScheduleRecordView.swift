//
//  CalendarHeaderOfScheduleRecordView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/30.
//

import UIKit

class CalendarHeaderOfScheduleRecordView: UICollectionReusableView {
    var sundayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 245, green: 140, blue: 140)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "일"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var mondayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "월"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var tuesdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "화"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var wednesdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "수"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var thursdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "목"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var fridayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "금"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var saturdayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 127, green: 185, blue: 255)
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "토"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setSubviews()
        self.setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for essential methods
extension CalendarHeaderOfScheduleRecordView {
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.sundayLabel,
            self.mondayLabel,
            self.tuesdayLabel,
            self.wednesdayLabel,
            self.thursdayLabel,
            self.fridayLabel,
            self.saturdayLabel
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // sundayLabel layout
        NSLayoutConstraint.activate([
            self.sundayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.sundayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.sundayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.sundayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // mondayLabel layout
        NSLayoutConstraint.activate([
            self.mondayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.mondayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.mondayLabel.leadingAnchor.constraint(equalTo: sundayLabel.trailingAnchor),
            self.mondayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // tuesdayLabel layout
        NSLayoutConstraint.activate([
            self.tuesdayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tuesdayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.tuesdayLabel.leadingAnchor.constraint(equalTo: mondayLabel.trailingAnchor),
            self.tuesdayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // wednesdayLabel layout
        NSLayoutConstraint.activate([
            self.wednesdayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.wednesdayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.wednesdayLabel.leadingAnchor.constraint(equalTo: tuesdayLabel.trailingAnchor),
            self.wednesdayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // thursdayLabel layout
        NSLayoutConstraint.activate([
            self.thursdayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.thursdayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.thursdayLabel.leadingAnchor.constraint(equalTo: wednesdayLabel.trailingAnchor),
            self.thursdayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // fridayLabel layout
        NSLayoutConstraint.activate([
            self.fridayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.fridayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.fridayLabel.leadingAnchor.constraint(equalTo: thursdayLabel.trailingAnchor),
            self.fridayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
        
        // saturdayLabel layout
        NSLayoutConstraint.activate([
            self.saturdayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.saturdayLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.saturdayLabel.leadingAnchor.constraint(equalTo: fridayLabel.trailingAnchor),
            self.saturdayLabel.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
}

// MARK: - Extension for methods added
extension CalendarHeaderOfScheduleRecordView {
    func setHeaderView() {
        
    }
}
