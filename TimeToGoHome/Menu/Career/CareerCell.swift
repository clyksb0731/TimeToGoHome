//
//  CareerCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/27.
//

import UIKit

class CareerCell: UITableViewCell {
    
    lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var careerPeriodMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .useRGB(red:60, green: 60, blue: 67, alpha: 0.6)
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "근무기간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var careerPeriodLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 60, green: 60, blue: 67, alpha: 0.29)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
extension CareerCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        //self.selectionStyle = .none
        self.contentView.isUserInteractionEnabled = true
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.companyLabel,
            self.careerPeriodMarkLabel,
            self.careerPeriodLabel,
            self.bottomLineView
        ], to: self)
    }
    
    func setLayouts() {
        let safeArea = self.safeAreaLayoutGuide
        
        // companyLabel
        NSLayoutConstraint.activate([
            self.companyLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            self.companyLabel.heightAnchor.constraint(equalToConstant: 22),
            self.companyLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.companyLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
        
        // careerPeriodMarkLabel
        NSLayoutConstraint.activate([
            self.careerPeriodMarkLabel.topAnchor.constraint(equalTo: self.companyLabel.bottomAnchor, constant: 4),
            self.careerPeriodMarkLabel.heightAnchor.constraint(equalToConstant: 20),
            self.careerPeriodMarkLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            self.careerPeriodMarkLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            self.careerPeriodMarkLabel.widthAnchor.constraint(equalToConstant: 57)
        ])
        
        // careerPeriodLabel
        NSLayoutConstraint.activate([
            self.careerPeriodLabel.centerYAnchor.constraint(equalTo: self.careerPeriodMarkLabel.centerYAnchor),
            self.careerPeriodLabel.heightAnchor.constraint(equalToConstant: 20),
            self.careerPeriodLabel.leadingAnchor.constraint(equalTo: self.careerPeriodMarkLabel.trailingAnchor, constant: 7),
            self.careerPeriodLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
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

// MARK: - Extension for methods added
extension CareerCell {
    func setCell(companyName: String, joiningDate: Date, leavingDate: Date?) {
        let dateIdFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyy. MM. dd")
        
        self.companyLabel.text = companyName
        
        if let leavingDate = leavingDate {
            if Int(dateIdFormatter.string(from: leavingDate))! < Int(dateIdFormatter.string(from: Date()))! {
                self.careerPeriodLabel.text = "\(dateFormatter.string(from: joiningDate)) ~ \(dateFormatter.string(from: leavingDate))"
                
            } else {
                self.careerPeriodLabel.text = "\(dateFormatter.string(from: joiningDate)) ~ 재직 중"
            }
            
        } else {
            self.careerPeriodLabel.text = "\(dateFormatter.string(from: joiningDate)) ~ 재직 중"
        }
    }
}
