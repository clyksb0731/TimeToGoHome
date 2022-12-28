//
//  RecordSchedulingCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/29.
//

import UIKit

class RecordSchedulingCell: UITableViewCell {
    lazy var addScheduleView: UIView = {
        let view = UIView()
        view.backgroundColor = .record.scheduling
        view.layer.cornerRadius = 9
        let dashLayer = SupportingMethods.shared.makeDashLayer(dashColor: UIColor.record.schedulingDash, width: UIScreen.main.bounds.width - 10, height: 60, cornerRadius: 9)
        view.layer.addSublayer(dashLayer)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addScheduleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var addScheduleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

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

}

// MARK: - Extension for essential methods
extension RecordSchedulingCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.addScheduleView
        ], to: self)
        
        SupportingMethods.shared.addSubviews([
            self.addScheduleImageView,
            self.addScheduleButton
        ], to: self.addScheduleView)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // addScheduleView
        NSLayoutConstraint.activate([
            self.addScheduleView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.addScheduleView.heightAnchor.constraint(equalToConstant: 60),
            self.addScheduleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            self.addScheduleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
        
        // addScheduleImageView
        NSLayoutConstraint.activate([
            self.addScheduleImageView.centerYAnchor.constraint(equalTo: self.addScheduleView.centerYAnchor),
            self.addScheduleImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addScheduleImageView.centerXAnchor.constraint(equalTo: self.addScheduleView.centerXAnchor),
            self.addScheduleImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // addScheduleButton
        SupportingMethods.shared.makeConstraintsOf(self.addScheduleButton, sameAs: self.addScheduleView)
    }
}

// MARK: - Extension for methods added
extension RecordSchedulingCell {
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        self.addScheduleButton.addTarget(target, action: action, for: controlEvents)
    }
}
