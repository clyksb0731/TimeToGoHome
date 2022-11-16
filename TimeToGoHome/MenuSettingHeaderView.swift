//
//  MenuSettingHeaderView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class MenuSettingHeaderView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
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
extension MenuSettingHeaderView: EssentialCellHeaderMethods {
    func setViewFoundation() {
        
    }
    
    func initializeObjects() {
        
    }
    
    func setSubviews() {
        
    }
    
    func setLayouts() {
        
    }
}
