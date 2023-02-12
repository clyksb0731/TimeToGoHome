//
//  CareerViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/27.
//

import UIKit

class CareerViewController: UIViewController {
    
    lazy var careerTableView: UITableView = {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureToCell(_:)))
        longPressGesture.minimumPressDuration = 0.3
        
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.register(CareerCell.self, forCellReuseIdentifier: "CareerCell")
        tableView.register(CareerHeaderView.self, forHeaderFooterViewReuseIdentifier: "CareerHeaderView")
        tableView.separatorStyle = .none
        tableView.addGestureRecognizer(longPressGesture)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var companiesClassified: [(careerMark: String, companies: [Company])] = self.makeCompaniesClassifiedWithCompanies(self.companies)
    
    var companies: [Company] = CompanyModel.companies.sorted(by: { $0.dateId > $1.dateId }) {
        willSet {
            self.companiesClassified = self.makeCompaniesClassifiedWithCompanies(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setDelegates()
        self.setGestures()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SupportingMethods.shared.makeInstantViewWithText("길게 눌러 수정할 수 있습니다.", duration: 2.5, on: self.careerTableView, withPosition: .bottom(constant: -30))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CompanyModel.invalidateObserving()
        VacationModel.invalidateObserving()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- CareerViewController disposed -----------------------------------")
    }

}

// MARK: Extension for essential methods
extension CareerViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "경력 사항"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plusDataButtonImage"), style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    func initializeObjects() {
        CompanyModel.observe {
            self.companies = CompanyModel.companies.sorted(by: { $0.dateId > $1.dateId })
            
            self.careerTableView.reloadData()
            
        } update: {
            self.companies = CompanyModel.companies.sorted(by: { $0.dateId > $1.dateId })
            
            self.careerTableView.reloadData()
            
            self.makeLatestCompanySetting { isNeedToMakeVacations in
                if isNeedToMakeVacations {
                    if let schedules = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date).schedules {
                        VacationModel.addVacationFromSchedules(schedules) {
                            ReferenceValues.initialSetting.updateValue(15, forKey: InitialSetting.annualPaidHolidays.rawValue)
                            
                            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                            
                            SupportingMethods.shared.turnCoverView(.off, on: self.view)
                        }
                        
                    } else {
                        ReferenceValues.initialSetting.updateValue(15, forKey: InitialSetting.annualPaidHolidays.rawValue)
                        
                        SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                        
                        SupportingMethods.shared.turnCoverView(.off, on: self.view)
                    }
                    
                } else {
                    SupportingMethods.shared.turnCoverView(.off, on: self.view)
                }
            }
        }
        
        VacationModel.observe {
            // nothing
        } update: {
            ReferenceValues.initialSetting.updateValue(VacationModel.numberOfVacationsHold / 2 < 15 ? 15 : VacationModel.numberOfVacationsHold % 2 > 0 ? VacationModel.numberOfVacationsHold / 2 + 1 : VacationModel.numberOfVacationsHold / 2, forKey: InitialSetting.annualPaidHolidays.rawValue)
            
            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
            
            SupportingMethods.shared.turnCoverView(.off, on: self.view)
        }
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.careerTableView
        ], to: self.view)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // careerTableView
        NSLayoutConstraint.activate([
            self.careerTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.careerTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.careerTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.careerTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension CareerViewController {
    func makeCompaniesClassifiedWithCompanies(_ companies: [Company]) -> [(careerMark: String, companies: [Company])] {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        var currentCompany: Company?
        var oldCompanies: [Company] = []
        var companiesClassified: [(careerMark: String, companies: [Company])] = []
        
        for company in companies {
            if let leavingDate = company.leavingDate {
                if Int(dateFormatter.string(from: leavingDate))! < Int(dateFormatter.string(from: Date()))! {
                    oldCompanies.append(company)
                    
                } else {
                    currentCompany = company
                }
                
            } else {
                currentCompany = company
            }
        }
        
        if let currentCompany = currentCompany {
            companiesClassified.append((careerMark: "현재 회사", companies: [currentCompany]))
        }
        
        if !oldCompanies.isEmpty {
            companiesClassified.append((careerMark: "이전 회사", companies: oldCompanies))
        }
        
        return companiesClassified
    }
    
    func makeLatestCompanySetting(completion:((_ isNeedToMakeVacations: Bool) -> ())?) {
        if let lastCompany = CompanyModel.getLastCompany() {
            let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
            
            guard Int(dateFormatter.string(from: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date))! != lastCompany.dateId else {
                
                completion?(false)
                
                return
            }
            
            let joiningDate = dateFormatter.date(from: String(lastCompany.dateId))!
            
            ReferenceValues.initialSetting.updateValue(joiningDate, forKey: InitialSetting.joiningDate.rawValue)
            ReferenceValues.initialSetting.updateValue(lastCompany.name, forKey: InitialSetting.companyName.rawValue)
            
            // leaving date
            if let leavingDate = lastCompany.leavingDate {
                ReferenceValues.initialSetting.updateValue(leavingDate, forKey: InitialSetting.leavingDate.rawValue)
            } else {
                ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.leavingDate.rawValue)
            }
            
            // address
            if let address = lastCompany.address {
                ReferenceValues.initialSetting.updateValue(address, forKey: InitialSetting.companyAddress.rawValue)
            } else {
                ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.companyAddress.rawValue)
            }
            
            // latitude
            if let latitude = lastCompany.latitude {
                ReferenceValues.initialSetting.updateValue(latitude, forKey: InitialSetting.companyLatitude.rawValue)
            } else {
                ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.companyLatitude.rawValue)
            }
            
            // longitude
            if let longitude = lastCompany.longitude {
                ReferenceValues.initialSetting.updateValue(longitude, forKey: InitialSetting.companyLongitude.rawValue)
            } else {
                ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.companyLongitude.rawValue)
            }
            
            SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
            
            completion?(!lastCompany.schedules.isEmpty)
            
        } else {
            ReferenceValues.initialSetting = [:]
            SupportingMethods.shared.setAppSetting(with: nil, for: .initialSetting)
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "새 회사 설정", andMessage: "경력 사항이 없습니다.\n새로운 회사 설정이 필요합니다.", okAction: UIAlertAction(title: "확인", style: .default, handler: { action in
                
                let initialVC = InitialViewController()
                initialVC.modalPresentationStyle = .fullScreen
                self.present(initialVC, animated: true)
                
            }), cancelAction: nil, completion: nil)
            
            completion?(false)
        }
    }
}

// MARK: - Extension for selector methods
extension CareerViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let menuCoverVC = MenuCoverViewController(.careerManagement(nil), delegate: self)
        
        self.present(menuCoverVC, animated: false)
    }
    
    @objc func longPressGestureToCell(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.careerTableView)
            if let indexPath = self.careerTableView.indexPathForRow(at: touchPoint) {
                UIDevice.heavyHaptic()
                
                let joiningDate = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.companiesClassified[indexPath.section].companies[indexPath.row].dateId))!
                let menuCoverVC = MenuCoverViewController(.careerManagement(CompanyModel(joiningDate: joiningDate)), delegate: self)
                
                self.present(menuCoverVC, animated: false)
            }
        }
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension CareerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.companiesClassified.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CareerHeaderView") as! CareerHeaderView
        headerView.setHeaderView(mark: self.companiesClassified[section].careerMark)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companiesClassified[section].companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerCell", for: indexPath) as! CareerCell
        cell.setCell(companyName: self.companiesClassified[indexPath.section].companies[indexPath.row].name,
                     joiningDate: SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.companiesClassified[indexPath.section].companies[indexPath.row].dateId))!,
                     leavingDate: self.companiesClassified[indexPath.section].companies[indexPath.row].leavingDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let joiningDate = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.companiesClassified[indexPath.section].companies[indexPath.row].dateId))!
        
        let workRecordVC = WorkRecordViewController(companyModel: CompanyModel(joiningDate: joiningDate))
        
        self.navigationController?.pushViewController(workRecordVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
        let leavingDate = self.companiesClassified[indexPath.section].companies[indexPath.row].leavingDate
        
        guard leavingDate != nil && Int(dateFormatter.string(from: leavingDate!))! < Int(dateFormatter.string(from: Date()))! else {
            return nil
        }
        
        let action = UIContextualAction(style: .destructive, title: "삭제") { action, view, completionHandler in
            UIDevice.lightHaptic()
            
            SupportingMethods.shared.makeAlert(on: self, withTitle: "회사 삭제", andMessage: "\(self.companiesClassified[indexPath.section].companies[indexPath.row].name) 회사를 삭제할까요?", okAction: UIAlertAction(title: "삭제", style: .destructive, handler: { action in
                
                SupportingMethods.shared.turnCoverView(.on, on: self.view)
                
                CompanyModel.removeCompany(self.companiesClassified[indexPath.section].companies[indexPath.row])
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
            
            completionHandler(true)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [action])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

// MARK: - Extension for MenuCoverDelegate
extension CareerViewController: MenuCoverDelegate {
    func menuCoverDidDetermineCompanyName(_ name:String, joiningDate: Date, leavingDate: Date?, ofCompanyModel companyModel: CompanyModel?) {
        let joiningDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: joiningDate))!
        
        if let companyModel = companyModel { // When this company exists
            if companyModel.company?.dateId == joiningDateId {
                companyModel.update(leavingDate: leavingDate, companyName: name)
                
            } else {
                CompanyModel.replaceCompany(companyModel.company!, withJoiningDate: joiningDate, leavingDate: leavingDate, name: name)
            }
            
            if let lastCompany = CompanyModel.getLastCompany() {
                let joiningDate = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(lastCompany.dateId))!
                ReferenceValues.initialSetting.updateValue(joiningDate, forKey: InitialSetting.joiningDate.rawValue)
                SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
            }
            
        } else { // When this company doesn't exist
            CompanyModel.addCompany(Company(joiningDate: joiningDate, leavingDate: leavingDate, name: name))
        }
    }
}
