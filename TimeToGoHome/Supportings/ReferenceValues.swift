//
//  ReferenceValues.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import Foundation

struct ReferenceValues {
    static let kakaoAuthKey: String = "KakaoAK fcc20fc42b0e0bba71cfae3b09107a38"
    
    static var initialSetting: [String:Any] = {
        if let initialSetting = SupportingMethods.shared.useAppSetting(for: .initialSetting) as? [String:Any] {
            return initialSetting
            
        } else {
            return [:]
        }
    }()
}


