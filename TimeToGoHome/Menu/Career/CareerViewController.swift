//
//  CareerViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/27.
//

import UIKit

class CareerViewController: UIViewController {
    
    lazy var careerTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.register(CareerCell.self, forCellReuseIdentifier: "CareerCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var companies: [Company] = CompanyModel.companies.sorted(by: { $0.dateId > $1.dateId })
    
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
    
}

// MARK: - Extension for selector methods
extension CareerViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        CompanyModel.invalidateObserving()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let menuCoverVC = MenuCoverViewController(.careerManagement(nil), delegate: self)
        
        self.present(menuCoverVC, animated: false)
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension CareerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareerCell", for: indexPath) as! CareerCell
        cell.setCell(companyName: self.companies[indexPath.row].name,
                     joiningDate: SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.companies[indexPath.row].dateId))!,
                     leavingDate: self.companies[indexPath.row].leavingDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let joiningDate = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.companies[indexPath.row].dateId))!
        let menuCoverVC = MenuCoverViewController(.careerManagement(CompanyModel(joiningDate: joiningDate)), delegate: self)
        
        self.present(menuCoverVC, animated: false)
    }
}

// MARK: - Extension for MenuCoverDelegate
extension CareerViewController: MenuCoverDelegate {
    func menuCoverDidDetermineCompany(_ company:String, joiningDate: Date, leavingDate: Date?, ofCompanyModel companyModel: CompanyModel?) {
        if let companyModel = companyModel { // When this company exists
            if let leavingDate = leavingDate { // Old company
                
            } else { // Current company
                
            }
            
        } else { // When this company doesn't exist
            
        }
        
        //CompanyModel.addCompany(Company(joiningDate: joiningDate, leavingDate: leavingDate, name: company))
    }
}
