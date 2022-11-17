//
//  CompanyLocationModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2021/11/26.
//

import Foundation
import Alamofire

struct CompanyLocationModel {
    private(set) var searchAddressWithTextReqeust: DataRequest?
    private(set) var findAddressWithCenterRequest: DataRequest?
    
    mutating func searchAddressWithTextReqeust(_ text: String, success: ((CompanyAddress) -> ())?, failure: (() -> ())?) {
        let url = "https://dapi.kakao.com/v2/local/search/address.json"
        
        let headers: HTTPHeaders = [
            "Authorization":ReferenceValues.kakaoAuthKey
        ]
        
        let parameters: Parameters = [
            "query":text, // 검색을 원하는 질의어
            "analyze":"similar",
            // similar: 입력한 건물명과 일부만 매칭될 경우에도 확장된 검색 결과 제공, 미지정 시 similar가 적용됨
            // exact: 주소의 정확한 건물명이 입력된 주소패턴일 경우에 한해, 입력한 건물명과 정확히 일치하는 검색 결과 제공
            "page":1, // 결과 페이지 번호: 1~45 사이의 값 (기본값: 1)
            "size":20 // 한페이지에 보여질 문서의 개수: 1~30 사이의 값(기본값: 10)
        ]
        
        self.searchAddressWithTextReqeust = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        self.searchAddressWithTextReqeust?.responseDecodable(of: CompanyAddress.self) { response in
            switch response.result {
            case .success(let decodedData):
                print("searchAddressWithTextReqeust succeeded: \(decodedData)")
                success?(decodedData)
                
            case .failure(let error):
                print("searchAddressWithTextReqeust error: \(error.localizedDescription)")
                failure?()
            }
        }
    }
    
    mutating func findAddressWithCenterRequest(latitude: String, longitude: String, success: ((CompanyMap) -> ())?, failure: (() -> ())?) {
        let url = "https://dapi.kakao.com/v2/local/geo/coord2address.json"
        
        let headers: HTTPHeaders = [
            "Authorization":ReferenceValues.kakaoAuthKey
        ]
        
        let parameters: Parameters = ["x":longitude, "y":latitude]
        
        self.findAddressWithCenterRequest = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        self.findAddressWithCenterRequest?.responseDecodable(of: CompanyMap.self) { response in
            switch response.result {
            case .success(let decodedData):
                print("findAddressWithCenterRequest succeeded: \(decodedData)")
                success?(decodedData)
                
            case .failure(let error):
                print("findAddressWithCenterRequest error: \(error.localizedDescription)")
            }
        }
    }
}

struct CompanyAddress: Codable {
    var documents: [Document]
    var meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case documents
        case meta
    }
    
    struct Document: Codable {
        var addressName: String // 전체 지번 주소 또는 전체 도로명 주소, 입력에 따라 결정됨
        var addressType: String // address_name의 값의 타입(Type)
                                //REGION(지명), ROAD(도로명), REGION_ADDR(지번 주소), ROAD_ADDR (도로명 주소) 중 하나
        var longitude: String // X 좌표값 (경도)
        var latitude: String // Y 좌표값 (위도)
        var address: Address? // 지번 주소 상세 정보, 아래 address 항목 구성 요소 참고
        var roadAddress: RoadAddress? // 도로명 주소 상세 정보, 아래 RoadAaddress 항목 구성 요소 참고
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case addressType = "address_type"
            case longitude = "x"
            case latitude = "y"
            case address
            case roadAddress = "road_address"
        }
        
        struct Address: Codable {
            var addressName: String // 전체 지번 주소
            var stateOrCityName: String // 지역 1 Depth, 시도 단위
            var cityOrGuName: String // 지역 2 Depth, 구 단위
            var guOrDongName: String // 지역 3 Depth, 동 단위
            var dongName: String // 지역 3 Depth, 행정동 명칭
            var hCode: String // 행정 코드
            var bCode: String // 법정 코드
            var mountainYN: String // 산 여부, Y 또는 N
            var mainAddressNumber: String // 지번 주번지
            var subAddressNumber: String // 지번 부번지. 없을 경우 ""
            //var zipCode: String // Deprecated 우편번호(6자리)
            var longitude: String // X 좌표값
            var latitude: String // Y 좌표값
            
            enum CodingKeys: String, CodingKey {
                case addressName = "address_name"
                case stateOrCityName = "region_1depth_name"
                case cityOrGuName = "region_2depth_name"
                case guOrDongName = "region_3depth_name"
                case dongName = "region_3depth_h_name"
                case hCode = "h_code"
                case bCode = "b_code"
                case mountainYN = "mountain_yn"
                case mainAddressNumber = "main_address_no"
                case subAddressNumber = "sub_address_no"
                //case zipCode = "zip_code"
                case longitude = "x"
                case latitude = "y"
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
            var longitude: String // X 좌표값
            var latitude: String // Y 좌표값
            
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
                case longitude = "x"
                case latitude = "y"
            }
        }
    }
    
    struct Meta: Codable {
        var totalCount: Int // 검색어에 검색된 문서 수
        var pageableCount: Int // total_count 중 노출 가능 문서 수 (최대값: 45?)
        var isEnd: Bool // 현재 페이지가 마지막 페이지인지 여부, 값이 false이면 page를 증가시켜 다음 페이지 요청 가능
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
}

struct CompanyMap: Codable {
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
