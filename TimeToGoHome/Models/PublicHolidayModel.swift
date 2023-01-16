//
//  PublicHolidayModel.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/16.
//

import Foundation
import Alamofire

enum PublicHolidayTag: String {
    case dateId = "locdate"
    case dateName
    case none
}

class PublicHolidayModel: NSObject {
    private(set) var publicHolidayRequest: DataRequest?
    private var succeededInParsing: (() -> ())?
    private var failedToParse: (() -> ())?
    
    private var tempPublicHolidays: [PublicHoliday] = []
    private(set) var publicHolidays: [PublicHoliday] = {
        guard let publicHolidays = SupportingMethods.shared.useAppSetting(for: .publicHolidays) as? [[String:Any]] else {
            return []
        }
        
        var elements: [PublicHoliday] = []
        for publicHoliday in publicHolidays {
            let dateId = publicHoliday["dateId"] as! Int
            let dateName = publicHoliday["dateName"] as! String
            
            var element = PublicHoliday(dateId: dateId, dateName: dateName)
            elements.append(element)
        }
        
        return elements
        
    }() {
        didSet {
            var tempArray: [[String:Any]] = []
            for publicHoliday in self.publicHolidays {
                var tempDic: [String:Any] = [:]
                tempDic.updateValue(publicHoliday.dateId, forKey: "dateId")
                tempDic.updateValue(publicHoliday.dateName, forKey: "dateName")
                
                tempArray.append(tempDic)
            }
            
            SupportingMethods.shared.setAppSetting(with: tempArray, for: .publicHolidays)
        }
    }
    
    private var isItem: Bool = false {
        didSet {
            if !self.isItem, let dateId = Int(self.dateId) , self.dateName != "" {
                let publicHoliday = PublicHoliday(dateId: dateId, dateName: self.dateName)
                
                self.tempPublicHolidays.append(publicHoliday)
            }
        }
    }
    
    private var currentTag: PublicHolidayTag = .none
    
    private var dateId: String = ""
    private var dateName: String = ""
    
    func publicHolidayRequest(forYear: Int, success: (() -> ())?, failure: (() -> ())?) {
        let url = "http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo"
        let yearMonthDay = SupportingMethods.shared.getYearMonthAndDayOf(Date())
        
        let parameters: Parameters = [
            "solYear":yearMonthDay.year, // 해당 년
            //"solMonth":String(format: "%02d", yearMonthDay.month), // 해당 월
            "numOfRows":30,
            "ServiceKey":ReferenceValues.dataGoKrKey
        ]
        
        self.publicHolidayRequest = AF.request(url, method: .get, parameters: parameters)
        
        self.publicHolidayRequest?.responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                print("publicHolidayRequest: \(String(data: response.data!, encoding: .utf8)!)")
                
                self.parseXml(data, success: success, failure: failure)
                
            case .failure(let error):
                print("publicHolidayRequest error: \(error.localizedDescription)")
                failure?()
            }
        })
    }
    
    func parseXml(_ xmlData: Data, success: (() -> ())?, failure: (() -> ())?) {
        let xmlParser = XMLParser(data: xmlData)
        xmlParser.delegate = self
        self.succeededInParsing = success
        self.failedToParse = failure
        
        DispatchQueue.global().async {
            if !xmlParser.parse() {
                DispatchQueue.main.async {
                    self.failedToParse?()
                }
            }
        }
    }
}

extension PublicHolidayModel: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            self.isItem = true
        }
        
        if self.isItem, elementName == "locdate" {
            self.currentTag = .dateId
        }
        
        if self.isItem, elementName == "dateName" {
            self.currentTag = .dateName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string.trimmingCharacters(in: .whitespacesAndNewlines))
        
        if self.isItem {
            switch self.currentTag {
            case .dateId:
                self.dateId += string.trimmingCharacters(in: .whitespacesAndNewlines)
                
            case .dateName:
                self.dateName += string.trimmingCharacters(in: .whitespacesAndNewlines)
                
            case .none:
                print("Nothing happens.")
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("\\\(elementName)")
        if elementName == "item" {
            self.isItem = false
        }
        
        if self.isItem, elementName == "locdate" {
            self.currentTag = .none
        }
        
        if self.isItem, elementName == "dateName" {
            self.currentTag = .none
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("parserDidEndDocument")
        
        DispatchQueue.main.async {
            self.publicHolidays = self.tempPublicHolidays
            self.tempPublicHolidays = []
            
            self.succeededInParsing?()
            self.succeededInParsing = nil
        }
    }
}

struct PublicHoliday {
    let dateId: Int
    let dateName: String
}
