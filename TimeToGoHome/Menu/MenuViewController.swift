//
//  MenuViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/16.
//

import UIKit

class MenuViewController: UIViewController {
    
    lazy var baseView: UIView = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(baseViewTapGesture(_:)))
        
        let view = UIView()
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var movingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var movingLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var movingBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var menuMarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.text = "메뉴"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var foldMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "foldMenuButton"), for: .normal)
        button.imageView?.contentMode = .center
        button.addTarget(self, action: #selector(foldMenuButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.register(MenuLargeCell.self, forCellReuseIdentifier: "MenuLargeCell")
        tableView.register(MenuHeaderView.self, forHeaderFooterViewReuseIdentifier: "MenuHeaderView")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    weak var mainVC: MainViewController?
    
    var leavingDate: Date?  {
        ReferenceValues.initialSetting[InitialSetting.leavingDate.rawValue] as? Date
    }
    
    var menuArray: [(header: String, items:[(menuStyle: MenuCellType, menuIconName: String, menuText: String)])] {
        [
            (header: "근무",
             items: [
                (menuStyle: .normal,
                 menuIconName: ReferenceValues.ImageName.Menu.workRecord,
                 menuText: "근무 내역"),
                
                (menuStyle: .normal,
                 menuIconName: ReferenceValues.ImageName.Menu.workStatistics,
                 menuText: "근무 통계")
             ]
            ),
            
            (header: "휴가",
             items: [
                (menuStyle: .normal,
                 menuIconName: ReferenceValues.ImageName.Menu.vacationUsage,
                 menuText: "휴가 일정")
             ]
            ),
            
            (header: "경력관리",
             items: [
                (menuStyle: .sideLabel(SupportingMethods.shared.makeDateFormatter("yyyy.M.d").string(from: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)),
                 menuIconName: ReferenceValues.ImageName.Menu.joiningDate,
                 menuText: "입사일"),
                
                (menuStyle: .normal,
                 menuIconName: ReferenceValues.ImageName.Menu.career,
                 menuText: "경력 사항"),
                
                (menuStyle: .button(.withoutAnything),
                 menuIconName: ReferenceValues.ImageName.Menu.leaveCompany,
                 menuText: "퇴직 처리")
             ]
            )
        ]
    }
    
    var movingViewleadingAnchor: NSLayoutConstraint!

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
        
        self.menuTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.unfoldMenu()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- MenuViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension MenuViewController: EssentialViewMethods {
    func setViewFoundation() {
        // Backgroud color
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        
//        // Navigation bar appearance
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithDefaultBackground()
//        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.titleTextAttributes = [
//            .foregroundColor : UIColor.black,
//            .font : UIFont.systemFont(ofSize: 17, weight: .semibold)
//        ]
//
//        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
//        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
//        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
//
//        self.navigationController?.setNavigationBarHidden(true, animated: true);
    }
    
    func initializeObjects() {
        
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.baseView,
            self.movingView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.movingLeftView,
            self.movingBaseView
        ], to: self.movingView)
        
        SupportingMethods.shared.addSubviews([
            self.menuMarkLabel,
            self.foldMenuButton,
            self.menuTableView
        ], to: self.movingBaseView)
    }
    
    func setLayouts() {
        // baseView
        NSLayoutConstraint.activate([
            self.baseView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.baseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.baseView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.baseView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        // movingView
        self.movingViewleadingAnchor = self.movingView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: -295)
        NSLayoutConstraint.activate([
            self.movingView.topAnchor.constraint(equalTo: self.baseView.topAnchor),
            self.movingView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor),
            self.movingViewleadingAnchor,
            self.movingView.widthAnchor.constraint(equalToConstant: 295)
        ])
        
        // movingLeftView
        NSLayoutConstraint.activate([
            self.movingLeftView.topAnchor.constraint(equalTo: self.movingView.topAnchor),
            self.movingLeftView.bottomAnchor.constraint(equalTo: self.movingView.bottomAnchor),
            self.movingLeftView.leadingAnchor.constraint(equalTo: self.movingView.leadingAnchor),
            self.movingLeftView.trailingAnchor.constraint(equalTo: self.movingView.centerXAnchor)
        ])
        
        //
        NSLayoutConstraint.activate([
            self.movingBaseView.topAnchor.constraint(equalTo: self.movingView.topAnchor),
            self.movingBaseView.bottomAnchor.constraint(equalTo: self.movingView.bottomAnchor),
            self.movingBaseView.leadingAnchor.constraint(equalTo: self.movingView.leadingAnchor),
            self.movingBaseView.trailingAnchor.constraint(equalTo: self.movingView.trailingAnchor)
        ])
        
        // menuMarkLabel
        NSLayoutConstraint.activate([
            self.menuMarkLabel.topAnchor.constraint(equalTo: self.movingBaseView.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.menuMarkLabel.heightAnchor.constraint(equalToConstant: 41),
            self.menuMarkLabel.leadingAnchor.constraint(equalTo: self.movingBaseView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        // foldMenuButton
        NSLayoutConstraint.activate([
            self.foldMenuButton.centerYAnchor.constraint(equalTo: self.menuMarkLabel.centerYAnchor),
            self.foldMenuButton.heightAnchor.constraint(equalToConstant: 41),
            self.foldMenuButton.trailingAnchor.constraint(equalTo: self.movingView.trailingAnchor),
            self.foldMenuButton.widthAnchor.constraint(equalToConstant: 72)
        ])
        
        // menuTableView
        NSLayoutConstraint.activate([
            self.menuTableView.topAnchor.constraint(equalTo: self.menuMarkLabel.bottomAnchor, constant: 32),
            self.menuTableView.bottomAnchor.constraint(equalTo: self.movingBaseView.bottomAnchor),
            self.menuTableView.leadingAnchor.constraint(equalTo: self.movingBaseView.leadingAnchor),
            self.menuTableView.trailingAnchor.constraint(equalTo: self.movingBaseView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension MenuViewController {
    func foldMenu(_ completion: (() -> ())? = nil) {
        self.movingView.isUserInteractionEnabled = false
        self.baseView.backgroundColor = .clear
        self.movingViewleadingAnchor.constant = -295
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
            
        } completion: { isFinished in
            self.dismiss(animated: false) {
                completion?()
            }
        }
    }
    
    func unfoldMenu() {
        self.movingView.isUserInteractionEnabled = false
        self.movingViewleadingAnchor.constant = 0
        
        UIView.animate(withDuration: 0.25) {
            self.baseView.backgroundColor = .useRGB(red: 0, green: 0, blue: 0, alpha: 0.2)
            self.view.layoutIfNeeded()
            
        } completion: { isFinished in
            self.movingView.isUserInteractionEnabled = true
        }
    }
}

// MARK: - Extension for Selector methods
extension MenuViewController {
    @objc func baseViewTapGesture(_ gesture: UITapGestureRecognizer) {
        self.foldMenu()
    }
    
    @objc func foldMenuButton(_ sender: UIButton) {
        self.foldMenu()
    }
    
    @objc func changeLeavingDate(_ sender: UIButton) {
        UIDevice.softHaptic()
        
        let menuCoverVC = MenuCoverViewController(.lastDateAtWork, delegate: self)
        
        self.present(menuCoverVC, animated: false)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MenuHeaderView") as! MenuHeaderView
        headerView.setHeaderView(categoryText: self.menuArray[section].header)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        }
        
        return 27
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            return nil
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if let leavingDate = self.leavingDate {
            let infoDateFormatter = SupportingMethods.shared.makeDateFormatter("yyyy.M.d")
            let orderingDateFormatter = SupportingMethods.shared.makeDateFormatter("yyyyMMdd")
            let leavingDateId = Int(orderingDateFormatter.string(from: leavingDate))!
            let todayDateId = Int(orderingDateFormatter.string(from: Date()))!
            
            if indexPath.section == 2 && indexPath.row == 2 {
                let menuLargeCell = tableView.dequeueReusableCell(withIdentifier: "MenuLargeCell", for: indexPath) as! MenuLargeCell
                if todayDateId > leavingDateId {
                    menuLargeCell.setCell(.button(.withSubText),
                                          iconName: ReferenceValues.ImageName.Menu.leaveCompany,
                                          itemText: "퇴직 취소",
                                          subTexts: (upperText: "마지막 근무일", lowerText: infoDateFormatter.string(from: leavingDate)))
                    
                } else {
                    menuLargeCell.setCell(.button(.withSubButton),
                                          iconName: ReferenceValues.ImageName.Menu.leaveCompany,
                                          itemText: "퇴직예정 취소",
                                          subTexts: (upperText: nil, lowerText: infoDateFormatter.string(from: leavingDate)),
                                          subUpperButtonTarget: (target: self, action: #selector(changeLeavingDate(_:)), for: .touchUpInside))
                }
                
                cell = menuLargeCell
                
            } else {
                let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
                menuCell.setCell(self.menuArray[indexPath.section].items[indexPath.row].menuStyle,
                                 iconName: self.menuArray[indexPath.section].items[indexPath.row].menuIconName,
                                 itemText: self.menuArray[indexPath.section].items[indexPath.row].menuText,
                                 isEnable: todayDateId <= leavingDateId ||
                                 (indexPath.section == 2 && indexPath.row == 0) ||
                                 (indexPath.section == 2 && indexPath.row == 1))
                
                cell = menuCell
            }
            
        } else {
            let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            menuCell.setCell(self.menuArray[indexPath.section].items[indexPath.row].menuStyle,
                             iconName: self.menuArray[indexPath.section].items[indexPath.row].menuIconName,
                             itemText: self.menuArray[indexPath.section].items[indexPath.row].menuText,
                             isEnable: true)
            
            cell = menuCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let today = Date()
        let todayDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: today))!
        
        if indexPath.section == 2 && indexPath.row == 1 {
            let careerVC = CareerViewController()

            self.mainVC?.navigationController?.pushViewController(careerVC, animated: true)
            self.foldMenu()
        }
        
        if indexPath.section == 2 && indexPath.row == 2 {
            if self.leavingDate != nil {
                SupportingMethods.shared.makeAlert(on: self, withTitle: "퇴직 취소", andMessage: "퇴직처리를 취소할까요?", okAction: UIAlertAction(title: "예", style: .default, handler: { action in
                    let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
                    companyModel.setLeavingDate(nil)
                    ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.leavingDate.rawValue)
                    
                    self.menuTableView.reloadData()
                    
                    self.mainVC?.schedule = .today
                    self.mainVC?.determineToday()
                    self.mainVC?.activateTimer()
                    
                }), cancelAction: UIAlertAction(title: "아니오", style: .cancel), completion: nil)
                
            } else {
                UIDevice.softHaptic()
                
                let menuCoverVC = MenuCoverViewController(.lastDateAtWork, delegate: self)
                
                self.present(menuCoverVC, animated: false)
            }
        }
       
        if let leavingDate = self.leavingDate {
            let leavingDateId = Int(SupportingMethods.shared.makeDateFormatter("yyyyMMdd").string(from: leavingDate))!
            if todayDateId > leavingDateId {
                return
            }
        }
        
        if indexPath.section == 0 && indexPath.row == 0 {
            let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
            let workRecordVC = WorkRecordViewController(companyModel: companyModel)
            
            self.mainVC?.navigationController?.pushViewController(workRecordVC, animated: true)
            self.foldMenu()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            // WorkStatisticsViewController
            
//            self.mainVC?.navigationController?.pushViewController(workRecordVC, animated: true)
//            self.foldMenu()
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            let vacationUsageVC = VacationUsageViewController()
            
            self.mainVC?.navigationController?.pushViewController(vacationUsageVC, animated: true)
            self.foldMenu()
        }
    }
}

// MARK: - Extension for MenuCoverDelegate
extension MenuViewController: MenuCoverDelegate {
    func menuCoverDidDetermineLastDate(_ date: Date) {
        let companyModel = CompanyModel(joiningDate: ReferenceValues.initialSetting[InitialSetting.joiningDate.rawValue] as! Date)
        
        let dateFormatted = SupportingMethods.shared.makeDateFormatter("yyyy년 M월 d일").string(from: date)
        
        if let schedules = companyModel.getSchedulesAfter(date), !schedules.isEmpty {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "퇴직 처리", andMessage: "\(dateFormatted) 이후에 기록된 일정이 있습니다. 퇴직 처리 시 해당 일정이 삭제됩니다. 퇴직 처리할까요?", okAction: UIAlertAction(title: "퇴직 처리", style: .default, handler: { _ in
                self.mainVC?.stopTimer()
                
                SupportingMethods.shared.turnOffAndRemoveLocalPush()
                SupportingMethods.shared.setAppSetting(with: nil, for: .isIgnoredLunchTimeToday)
                
                ReferenceValues.initialSetting.updateValue(date, forKey: InitialSetting.leavingDate.rawValue)
                SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                
                companyModel.setLeavingDate(date)
                companyModel.removeSchedules(schedules)
                
                self.menuTableView.reloadData()
                
                self.mainVC?.schedule = .today
                self.mainVC?.determineToday()
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
            
        } else {
            SupportingMethods.shared.makeAlert(on: self, withTitle: "퇴직 처리", andMessage: "\(dateFormatted)부로 퇴직 처리할까요?", okAction: UIAlertAction(title: "퇴직 처리", style: .default, handler: { _ in
                companyModel.setLeavingDate(date)
                
                ReferenceValues.initialSetting.updateValue(date, forKey: InitialSetting.leavingDate.rawValue)
                SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
                
                self.menuTableView.reloadData()
                
            }), cancelAction: UIAlertAction(title: "취소", style: .cancel), completion: nil)
        }
    }
}
