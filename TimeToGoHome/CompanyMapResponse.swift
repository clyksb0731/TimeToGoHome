//
//  CompanyMapResponse.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import Foundation

struct CompanyMapResponse: Codable {
    var meta: Meta
    var documents: [Document]
    
    enum CodingKeys: String, CodingKey {
        case meta
        case documents
    }
    
    struct Meta: Codable {
        var totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
        }
    }

    struct Document: Codable {
        var address: Address? // 지번 주소 상세 정보, 아래 address 항목 구성 요소 참고
        var roadAddress: RoadAddress? // 도로명 주소 상세 정보, 아래 RoadAaddress 항목 구성 요소 참고
        
        enum CodingKeys: String, CodingKey {
            case address
            case roadAddress = "road_address"
        }
        
        struct Address: Codable {
            var addressName: String
            var stateOrCityName: String // 지역 1 Depth, 시도 단위
            var cityOrGuName: String // 지역 2 Depth, 구 단위
            var guOrDongName: String // 지역 3 Depth, 동 단위
            var mountainYN: String // 산 여부, Y 또는 N
            var mainAddressNumber: String // 지번 주번지
            var subAddressNumber: String // 지번 부번지. 없을 경우 ""
            //var zipCode: String // Deprecated 우편번호(6자리)
            
            enum CodingKeys: String, CodingKey {
                case addressName = "address_name"
                case stateOrCityName = "region_1depth_name"
                case cityOrGuName = "region_2depth_name"
                case guOrDongName = "region_3depth_name"
                case mountainYN = "mountain_yn"
                case mainAddressNumber = "main_address_no"
                case subAddressNumber = "sub_address_no"
                //case zipCode = "zip_code"
            }
        }
        
        struct RoadAddress: Codable {
            var addressName: String // 전체 도로명 주소
            var firstRegionName: String // 지역명1
            var secondRegionName: String // 지역명2
            var thirdRegionName: String // 지역명3
            var roadName: String // 도로명
            var undergroundYN: String // 지하 여부, Y 또는 N
            var mainBuildingNumber: String // 건물 본번
            var subBuildingNumber: String // 지번 부번지. 없을 경우 ""
            var buildingName: String // 건물 이름
            var zoneNumber: String // 우편번호(5자리)
            
            enum CodingKeys: String, CodingKey {
                case addressName = "address_name"
                case firstRegionName = "region_1depth_name"
                case secondRegionName = "region_2depth_name"
                case thirdRegionName = "region_3depth_name"
                case roadName = "road_name"
                case undergroundYN = "underground_yn"
                case mainBuildingNumber = "main_building_no"
                case subBuildingNumber = "sub_building_no"
                case buildingName = "building_name"
                case zoneNumber = "zone_no"
            }
        }
    }
}
