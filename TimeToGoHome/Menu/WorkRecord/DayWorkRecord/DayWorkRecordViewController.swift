//
//  DayWorkRecordViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/11/29.
//

import UIKit

class DayWorkRecordViewController: UIViewController {
    
    lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = !self.isEditingMode
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addScheduleView: UIView = {
        let view = UIView()
        view.backgroundColor = .record.scheduling
        view.layer.cornerRadius = 9
        let dashLayer = SupportingMethods.shared.makeDashLayer(dashColor: UIColor.record.schedulingDash, width: UIScreen.main.bounds.width - 10, height: 60, cornerRadius: 9)
        view.layer.addSublayer(dashLayer)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var addScheduleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var addScheduleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addScheduleButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var tableBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = self.recordedSchedule.count == 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var recordScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.register(RecordScheduleCell.self, forCellReuseIdentifier: "RecordScheduleCell")
        tableView.register(RecordSchedulingCell.self, forCellReuseIdentifier: "RecordSchedulingCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var changeScheduleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .useRGB(red: 109, green: 114, blue: 120)
        label.textAlignment = .center
        label.text = "항목을 길게 누르면 수정할 수 있습니다."
        label.isHidden = self.isEditingMode
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var recordedSchedule: WorkScheduleRecordModel {
        didSet {
            self.navigationItem.rightBarButtonItem?.isEnabled = self.recordedSchedule.count >= 2
        }
    }
    
    var companyModel: CompanyModel
    
    var recordScheduleTableViewHeightAncor: NSLayoutConstraint!
    
    var isEditingMode: Bool {
        didSet {
            self.navigationItem.rightBarButtonItem?.title = self.isEditingMode ? "완료" : "추가/제거"
            self.changeScheduleDescriptionLabel.isHidden = self.isEditingMode
            
            self.determineTableView()
            
            if !self.isEditingMode {
                self.recordedSchedule.updateDB(companyModel: self.companyModel)
            }
        }
    }
    
    init(recordedSchedule: WorkScheduleRecordModel, companyModel: CompanyModel) {
        self.recordedSchedule = recordedSchedule
        self.companyModel = companyModel
        
        self.isEditingMode = recordedSchedule.morning == nil
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
        print("----------------------------------------- DayWorkRecordViewController -----------------------------------------")
    }
    

}

// MARK: - Extension for essential methods
extension DayWorkRecordViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        let recordScheduleDate: Date! = SupportingMethods.shared.makeDateFormatter("yyyyMMdd").date(from: String(self.recordedSchedule.dateId))
        self.navigationItem.title = SupportingMethods.shared.makeDateFormatter("yyyy년 M월 d일").string(from: recordScheduleDate)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.isEditingMode ? "완료" : "추가/제거", style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem?.isEnabled = self.recordedSchedule.count >= 2
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
            self.emptyView,
            self.tableBaseView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.addScheduleView
        ], to: self.emptyView)
        
        SupportingMethods.shared.addSubviews([
            self.addScheduleImageView,
            self.addScheduleButton
        ], to: self.addScheduleView)
        
        SupportingMethods.shared.addSubviews([
            self.recordScheduleTableView,
            self.changeScheduleDescriptionLabel
        ], to: self.tableBaseView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // emptyView
        NSLayoutConstraint.activate([
            self.emptyView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.emptyView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            self.emptyView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.emptyView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // addScheduleView
        NSLayoutConstraint.activate([
            self.addScheduleView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            self.addScheduleView.heightAnchor.constraint(equalToConstant: 60),
            self.addScheduleView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5),
            self.addScheduleView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5)
        ])
        
        // addScheduleImageView
        NSLayoutConstraint.activate([
            self.addScheduleImageView.centerYAnchor.constraint(equalTo: self.addScheduleView.centerYAnchor),
            self.addScheduleImageView.heightAnchor.constraint(equalToConstant: 34),
            self.addScheduleImageView.centerXAnchor.constraint(equalTo: self.addScheduleView.centerXAnchor),
            self.addScheduleImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // addScheduleButton
        SupportingMethods.shared.makeSameBoundConstraints(self.addScheduleButton, self.addScheduleView)
        
        // tableBaseView
        NSLayoutConstraint.activate([
            self.tableBaseView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.tableBaseView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.tableBaseView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.tableBaseView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // recordScheduleTableView
        self.recordScheduleTableViewHeightAncor = self.recordScheduleTableView.heightAnchor.constraint(equalToConstant: self.calculateTableViewHeight())
        NSLayoutConstraint.activate([
            self.recordScheduleTableView.topAnchor.constraint(equalTo: self.tableBaseView.topAnchor, constant: 10),
            self.recordScheduleTableViewHeightAncor,
            self.recordScheduleTableView.leadingAnchor.constraint(equalTo: self.tableBaseView.leadingAnchor),
            self.recordScheduleTableView.trailingAnchor.constraint(equalTo: self.tableBaseView.trailingAnchor)
        ])
        
        // changeScheduleDescriptionLabel
        NSLayoutConstraint.activate([
            self.changeScheduleDescriptionLabel.topAnchor.constraint(equalTo: self.recordScheduleTableView.bottomAnchor, constant: 30),
            self.changeScheduleDescriptionLabel.heightAnchor.constraint(equalToConstant: 16),
            self.changeScheduleDescriptionLabel.centerXAnchor.constraint(equalTo: self.tableBaseView.centerXAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension DayWorkRecordViewController {
    func determineTableView() {
        self.recordScheduleTableViewHeightAncor.constant = self.calculateTableViewHeight()
        self.recordScheduleTableView.reloadData()
        
        self.tableBaseView.isHidden = self.recordedSchedule.count == 0
    }
    
    func calculateTableViewHeight() -> CGFloat {
        if self.recordedSchedule.count == 1 {
            return ReferenceValues.size.record.normalScheduleHeight + ReferenceValues.size.record.schedulingHeight
            
        } else if self.recordedSchedule.count == 2 {
            if self.isEditingMode {
                switch self.recordedSchedule.afternoon! {
                case .holiday:
                    return ReferenceValues.size.record.normalScheduleHeight * 2
                    
                case .vacation:
                    return ReferenceValues.size.record.normalScheduleHeight * 2
                    
                case .work:
                    return ReferenceValues.size.record.normalScheduleHeight * 2 + ReferenceValues.size.record.schedulingHeight
                }
                
            } else {
                return ReferenceValues.size.record.normalScheduleHeight * 2
            }
            
        } else if self.recordedSchedule.count == 3 {
            return ReferenceValues.size.record.normalScheduleHeight * 2 + ReferenceValues.size.record.overtimeScheduleHeight
            
        } else { // 0
            return ReferenceValues.size.record.schedulingHeight
        }
    }
}

// MARK: - Extension for selector methods
extension DayWorkRecordViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        self.isEditingMode.toggle()
    }
    
    @objc func addScheduleButton(_ sender: UIButton) {
        print("addRecordScheduleButton")
        
        if self.recordedSchedule.count == 1 {
            switch self.recordedSchedule.morning! {
            case .work:
                let menuCoverVC = MenuCoverViewController(.addNormalSchedule(.allButton), delegate: self)
                
                self.present(menuCoverVC, animated: false)
                
            case .vacation:
                let menuCoverVC = MenuCoverViewController(.addNormalSchedule(.vacation), delegate: self)
                
                self.present(menuCoverVC, animated: false)
                
            case .holiday:
                let menuCoverVC = MenuCoverViewController(.addNormalSchedule(.holiday), delegate: self)
                
                self.present(menuCoverVC, animated: false)
            }
            
        } else if self.recordedSchedule.count == 2 {
            let menuCoverVC = MenuCoverViewController(.overtime(self.recordedSchedule.overtime), delegate: self)
            
            self.present(menuCoverVC, animated: false)
            
        } else { // == 0
            let menuCoverVC = MenuCoverViewController(.addNormalSchedule(.allButton), delegate: self)
            
            self.present(menuCoverVC, animated: false)
        }
        
        self.determineTableView()
    }
    
    @objc func insertScheduleAtLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard !self.isEditingMode else { return }
        
        if let scheduleCell = gesture.view {
            if gesture.state == .began {
                UIDevice.heavyHaptic()
                
                if scheduleCell.tag == 1 {
                    print("Long Pressed for morning")
                    if self.recordedSchedule.overtime == nil {
                        var buttonType: NormalButtonType = .allButton
                        switch self.recordedSchedule.afternoon! {
                        case .work:
                            buttonType = .allButton
                            
                        case .vacation:
                            buttonType = .vacation
                            
                        case .holiday:
                            buttonType = .holiday
                        }
                        let menuCoverVC = MenuCoverViewController(.insertNormalSchedule(.morning(self.recordedSchedule.morning!), buttonType), delegate: self)
                        
                        self.present(menuCoverVC, animated: false)
                        
                    } else {
                        let alertVC = UIAlertController(title: "변경 불가", message: "추가근무 제거 후 변경해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true)
                    }
                    
                } else if scheduleCell.tag == 2 {
                    print("Long Pressed for afternoon")
                    if self.recordedSchedule.overtime == nil {
                        var buttonType: NormalButtonType = .allButton
                        switch self.recordedSchedule.morning! {
                        case .work:
                            buttonType = .allButton
                            
                        case .vacation:
                            buttonType = .vacation
                            
                        case .holiday:
                            buttonType = .holiday
                        }
                        let menuCoverVC = MenuCoverViewController(.insertNormalSchedule(.afternoon(self.recordedSchedule.afternoon!), buttonType), delegate: self)
                        
                        self.present(menuCoverVC, animated: false)
                        
                    } else {
                        let alertVC = UIAlertController(title: "변경 불가", message: "추가근무 제거 후 변경해 주세요.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alertVC.addAction(action)
                        self.present(alertVC, animated: true)
                    }
                    
                } else { // tag 3, overtime
                    print("Long Pressed for overtime")
                    let menuCoverVC = MenuCoverViewController(.overtime(self.recordedSchedule.overtime), delegate: self)
                    
                    self.present(menuCoverVC, animated: false)
                }
            }
        }
    }
    
    @objc func removeScheduleButton(_ sender: UIButton) {
        print("removeRecordScheduleButton")
        
        if sender.tag == 1 {
            self.recordedSchedule.morning = nil
        }
        
        if sender.tag == 2 {
            self.recordedSchedule.afternoon = nil
        }
        
        if sender.tag == 3 {
            self.recordedSchedule.overtime = nil
        }
        
        self.determineTableView()
    }
}

// MARK: - Extension for UITableViewDelegate, UITableViewDataSource
extension DayWorkRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.recordedSchedule.count == 1 {
            return 2
            
        } else if self.recordedSchedule.count == 2 {
            if self.isEditingMode {
                switch self.recordedSchedule.afternoon! {
                case .holiday:
                    return 2
                    
                case .vacation:
                    return 2
                    
                case .work:
                    return 3
                }
                
            } else {
                return 2
            }
            
        } else if self.recordedSchedule.count == 3 {
            return 3
            
        } else { // count == 0
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.recordedSchedule.count == 1 {
            if indexPath.row == 0 {
                return ReferenceValues.size.record.normalScheduleHeight
                
            } else { // row == 1
                return ReferenceValues.size.record.schedulingHeight
            }
            
        } else if self.recordedSchedule.count == 2 {
            if self.isEditingMode {
                if indexPath.row == 0 {
                    return ReferenceValues.size.record.normalScheduleHeight
                    
                } else if indexPath.row == 1 {
                    return ReferenceValues.size.record.normalScheduleHeight
                    
                } else { // row == 2
                    return ReferenceValues.size.record.schedulingHeight
                }
                
            } else {
                if indexPath.row == 0 {
                    return ReferenceValues.size.record.normalScheduleHeight
                    
                } else { // row == 1
                    return ReferenceValues.size.record.normalScheduleHeight
                }
            }
            
        } else if self.recordedSchedule.count == 3 {
            if indexPath.row == 0 {
                return ReferenceValues.size.record.normalScheduleHeight
                
            } else if indexPath.row == 1 {
                return ReferenceValues.size.record.normalScheduleHeight
                
            } else { // row == 2
                return ReferenceValues.size.record.overtimeScheduleHeight
            }
            
        } else { // count == 0
            return ReferenceValues.size.record.schedulingHeight
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.recordedSchedule.count == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: true, tag: 1)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                
                return cell
                
            } else { // row == 1
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordSchedulingCell", for: indexPath) as! RecordSchedulingCell
                cell.addTarget(self, action: #selector(addScheduleButton(_:)), for: .touchUpInside)
                
                return cell
            }
            
        } else if self.recordedSchedule.count == 2 {
            if self.isEditingMode {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                    cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: false, tag: 1)
                    
                    return cell
                    
                } else if indexPath.row == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                    cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: true, tag: 2)
                    cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                    
                    return cell
                    
                } else { // row == 2
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordSchedulingCell", for: indexPath) as! RecordSchedulingCell
                    cell.addTarget(self, action: #selector(addScheduleButton(_:)), for: .touchUpInside)
                    
                    return cell
                }
                
            } else {
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                    cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: false, tag: 1)
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(insertScheduleAtLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                    
                    return cell
                    
                } else { // row == 1
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                    cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: false, tag: 2)
                    let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(insertScheduleAtLongPressGesture(_:)))
                    longGesture.minimumPressDuration = 0.5
                    cell.addGestureRecognizer(longGesture)
                    
                    return cell
                }
            }
            
        } else if self.recordedSchedule.count == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: false, tag: 1)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(insertScheduleAtLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
                
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: false, tag: 2)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(insertScheduleAtLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
                
            } else { // row == 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecordScheduleCell", for: indexPath) as! RecordScheduleCell
                cell.setCell(recordSchedule: self.recordedSchedule, isEditingMode: self.isEditingMode, tag: 3)
                cell.addTarget(self, action: #selector(removeScheduleButton(_:)), for: .touchUpInside)
                let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(insertScheduleAtLongPressGesture(_:)))
                longGesture.minimumPressDuration = 0.5
                cell.addGestureRecognizer(longGesture)
                
                return cell
            }
            
        } else { // count == 0
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordSchedulingCell", for: indexPath) as! RecordSchedulingCell
            cell.addTarget(self, action: #selector(addScheduleButton(_:)), for: .touchUpInside)
            
            return cell
        }
    }
}

// MARK: - Extension for MenuCoverDelegate
extension DayWorkRecordViewController: MenuCoverDelegate {
    func menuCoverDidDetermineAddNormalSchedule(_ workTimeType: WorkTimeType) {
        if self.recordedSchedule.count == 0 {
            self.recordedSchedule.morning = workTimeType
            
        } else { // count == 1
            self.recordedSchedule.afternoon = workTimeType
        }
        
        self.determineTableView()
    }
    
    func menuCoverDidDetermineInsertNormalSchedule(_ scheduleType: RecordScheduleType) {
        switch scheduleType {
        case .morning(let workTimeType):
            self.recordedSchedule.morning = workTimeType
            
        case .afternoon(let workTimeType):
            self.recordedSchedule.afternoon = workTimeType
            
        default:
            break
        }
        
        self.determineTableView()
        
        self.recordedSchedule.updateDB(companyModel: self.companyModel)
    }
    
    func menuCoverDidDetermineOvertimeSeconds(_ overtimeSeconds: Int) {
        self.recordedSchedule.overtime = overtimeSeconds
        
        self.determineTableView()
        
        if !self.isEditingMode {
            self.recordedSchedule.updateDB(companyModel: self.companyModel)
        }
    }
}
