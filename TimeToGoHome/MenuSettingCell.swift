//
//  MenuSettingCell.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

enum MenuSettingCellType {
    case openVC
    case `switch`(Bool)
    case label(String)
    case button
}

class MenuSettingCell: UITableViewCell {
    
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
extension MenuSettingCell: EssentialCellHeaderMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        
    }
    
    func setLayouts() {
        
    }
}

// MARK: Extension for methods added
extension MenuSettingCell {
    func setCell(_ style: MenuSettingCellType, menuText text: String) {
        
    }
}
