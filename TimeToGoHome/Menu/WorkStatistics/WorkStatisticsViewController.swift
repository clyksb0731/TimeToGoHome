//
//  WorkStatisticsViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/12/04.
//

import UIKit
import Charts

class WorkStatisticsViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: ReferenceValues.keyWindow.screen.bounds.width,
                                        height: 16 + ReferenceValues.keyWindow.screen.bounds.width + 247) // 16 + width + 16 + 32 + 16 + 32 + 19 + 24 + 24 + 8 + 24 + 8 + 24 + 20
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var statisticsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.contentSize = CGSize(width: ReferenceValues.keyWindow.screen.bounds.width * 3,
                                        height: ReferenceValues.keyWindow.screen.bounds.width)
        scrollView.contentOffset = CGPoint(x: ReferenceValues.keyWindow.screen.bounds.width, y: 0)
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var statisticsContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var weekView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var noWorkStatisticsOfWeekImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noWorkStatistics"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var weekPieChartView: PieChartView = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        let todayTimeInterval = Int(self.today.timeIntervalSinceReferenceDate)
        let yesterday = Date(timeIntervalSinceReferenceDate: Double(todayTimeInterval - 86400))
        let statisticsValues = self.companyModel.calculateStatistics(.week, date: yesterday)
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: Double(statisticsValues?.regularWorkTime ?? 0), label: "정규 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.overtime ?? 0), label: "초과 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.vacation ?? 0), label: "휴가")
        ]
        let dataSet: PieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [
            .Schedule.work,
            .Schedule.overtime,
            .Schedule.vacation
        ]
        let data = PieChartData(dataSet: dataSet)
        
        let chartView = PieChartView()
        chartView.usePercentValuesEnabled = true
        chartView.data = data
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter)) // MARK: The 'setValueFormatter' must be called after inserting data into chartView's data
        chartView.data?.setValueTextColor(.white)
        chartView.holeColor = .clear
        chartView.isHidden = statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()
    
    lazy var monthView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var noWorkStatisticsOfMonthImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noWorkStatistics"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var monthPieChartView: PieChartView = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        let todayTimeInterval = Int(self.today.timeIntervalSinceReferenceDate)
        let yesterday = Date(timeIntervalSinceReferenceDate: Double(todayTimeInterval - 86400))
        let statisticsValues = self.companyModel.calculateStatistics(.month, date: yesterday)
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: Double(statisticsValues?.regularWorkTime ?? 0), label: "정규 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.overtime ?? 0), label: "초과 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.vacation ?? 0), label: "휴가")
        ]
        let dataSet: PieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [
            .Schedule.work,
            .Schedule.overtime,
            .Schedule.vacation
        ]
        let data = PieChartData(dataSet: dataSet)
        
        let chartView = PieChartView()
        chartView.usePercentValuesEnabled = true
        chartView.data = data
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter)) // MARK: The 'setValueFormatter' must be called after inserting data into chartView's data
        chartView.data?.setValueTextColor(.white)
        chartView.holeColor = .clear
        chartView.isHidden = statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()
    
    lazy var yearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var noWorkStatisticsOfYearImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noWorkStatistics"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var yearPieChartView: PieChartView = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        
        let todayTimeInterval = Int(self.today.timeIntervalSinceReferenceDate)
        let yesterday = Date(timeIntervalSinceReferenceDate: Double(todayTimeInterval - 86400))
        let statisticsValues = self.companyModel.calculateStatistics(.year, date: yesterday)
        
        let dataEntries: [PieChartDataEntry] = [
            PieChartDataEntry(value: Double(statisticsValues?.regularWorkTime ?? 0), label: "정규 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.overtime ?? 0), label: "초과 근무"),
            PieChartDataEntry(value: Double(statisticsValues?.vacation ?? 0), label: "휴가")
        ]
        let dataSet: PieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [
            .Schedule.work,
            .Schedule.overtime,
            .Schedule.vacation
        ]
        let data = PieChartData(dataSet: dataSet)
        
        let chartView = PieChartView()
        chartView.usePercentValuesEnabled = true
        chartView.data = data
        chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter)) // MARK: The 'setValueFormatter' must be called after inserting data into chartView's data
        chartView.data?.setValueTextColor(.white)
        chartView.holeColor = .clear
        chartView.isHidden = statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        return chartView
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["주", "월", "년"])
        segmentControl.selectedSegmentIndex = 1
        segmentControl.addTarget(self, action: #selector(statisticsSegmentControl(_:)), for: .valueChanged)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentControl
    }()
    
    lazy var periodLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .useRGB(red: 150, green: 150, blue: 150)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var informationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var regularWorkTimeMarkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Schedule.work
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var regularWorkTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var overtimeMarkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Schedule.overtime
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var overtimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var vacationMarkView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Schedule.vacation
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var vacationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    var today: Date = Date()
    var companyModel: CompanyModel
    
    init(companyModel: CompanyModel) {
        self.companyModel = companyModel
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
            print("----------------------------------- WorkStatisticsViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension WorkStatisticsViewController: EssentialViewMethods {
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "근무 통계"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backButtonItemImage"), style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    func initializeObjects() {
        self.determineInformationView(.month) // initial value
    }
    
    func setDelegates() {
        
    }
    
    func setGestures() {
        
    }
    
    func setNotificationCenters() {
        
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.scrollView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
            self.statisticsScrollView,
            self.segmentControl,
            self.periodLabel,
            self.informationView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.statisticsContentView
        ], to: self.statisticsScrollView)
        
        SupportingMethods.shared.addSubviews([
            self.weekView,
            self.monthView,
            self.yearView
        ], to: self.statisticsContentView)
        
        SupportingMethods.shared.addSubviews([
            self.noWorkStatisticsOfWeekImageView,
            self.weekPieChartView
        ], to: self.weekView)
        
        SupportingMethods.shared.addSubviews([
            self.noWorkStatisticsOfMonthImageView,
            self.monthPieChartView
        ], to: self.monthView)
        
        SupportingMethods.shared.addSubviews([
            self.noWorkStatisticsOfYearImageView,
            self.yearPieChartView
        ], to: self.yearView)
        
        SupportingMethods.shared.addSubviews([
            self.regularWorkTimeMarkView,
            self.regularWorkTimeLabel,
            self.overtimeMarkView,
            self.overtimeLabel,
            self.vacationMarkView,
            self.vacationLabel
        ], to: self.informationView)
    }
    
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // scrollView
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // contentView
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        // statisticsScrollView
        NSLayoutConstraint.activate([
            self.statisticsScrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.statisticsScrollView.heightAnchor.constraint(equalToConstant: ReferenceValues.keyWindow.screen.bounds.width),
            self.statisticsScrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.statisticsScrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        // statisticsContentView
        NSLayoutConstraint.activate([
            self.statisticsContentView.topAnchor.constraint(equalTo: self.statisticsScrollView.topAnchor),
            self.statisticsContentView.heightAnchor.constraint(equalTo: self.statisticsScrollView.heightAnchor),
            self.statisticsContentView.leadingAnchor.constraint(equalTo: self.statisticsScrollView.leadingAnchor),
            self.statisticsContentView.widthAnchor.constraint(equalToConstant: self.statisticsScrollView.contentSize.width)
        ])
        
        // weekView
        NSLayoutConstraint.activate([
            self.weekView.topAnchor.constraint(equalTo: self.statisticsContentView.topAnchor),
            self.weekView.heightAnchor.constraint(equalTo: self.statisticsContentView.heightAnchor),
            self.weekView.leadingAnchor.constraint(equalTo: self.statisticsContentView.leadingAnchor),
            self.weekView.widthAnchor.constraint(equalToConstant: ReferenceValues.keyWindow.screen.bounds.width)
        ])
        
        // noWorkStatisticsOfWeekImageView
        NSLayoutConstraint.activate([
            self.noWorkStatisticsOfWeekImageView.centerYAnchor.constraint(equalTo: self.weekView.centerYAnchor),
            self.noWorkStatisticsOfWeekImageView.heightAnchor.constraint(equalToConstant: 200),
            self.noWorkStatisticsOfWeekImageView.centerXAnchor.constraint(equalTo: self.weekView.centerXAnchor),
            self.noWorkStatisticsOfWeekImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // weekPieChartView
        SupportingMethods.shared.makeConstraintsOf(self.weekPieChartView, sameAs: self.weekView)
        
        // monthView
        NSLayoutConstraint.activate([
            self.monthView.topAnchor.constraint(equalTo: self.statisticsContentView.topAnchor),
            self.monthView.heightAnchor.constraint(equalTo: self.statisticsContentView.heightAnchor),
            self.monthView.leadingAnchor.constraint(equalTo: self.weekView.trailingAnchor),
            self.monthView.widthAnchor.constraint(equalToConstant: ReferenceValues.keyWindow.screen.bounds.width)
        ])
        
        // noWorkStatisticsOfMonthImageView
        NSLayoutConstraint.activate([
            self.noWorkStatisticsOfMonthImageView.centerYAnchor.constraint(equalTo: self.monthView.centerYAnchor),
            self.noWorkStatisticsOfMonthImageView.heightAnchor.constraint(equalToConstant: 200),
            self.noWorkStatisticsOfMonthImageView.centerXAnchor.constraint(equalTo: self.monthView.centerXAnchor),
            self.noWorkStatisticsOfMonthImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // monthPieChartView
        SupportingMethods.shared.makeConstraintsOf(self.monthPieChartView, sameAs: self.monthView)
        
        // yearView
        NSLayoutConstraint.activate([
            self.yearView.topAnchor.constraint(equalTo: self.statisticsContentView.topAnchor),
            self.yearView.heightAnchor.constraint(equalTo: self.statisticsContentView.heightAnchor),
            self.yearView.leadingAnchor.constraint(equalTo: self.monthView.trailingAnchor),
            self.yearView.widthAnchor.constraint(equalToConstant: ReferenceValues.keyWindow.screen.bounds.width)
        ])
        
        // noWorkStatisticsOfYearImageView
        NSLayoutConstraint.activate([
            self.noWorkStatisticsOfYearImageView.centerYAnchor.constraint(equalTo: self.yearView.centerYAnchor),
            self.noWorkStatisticsOfYearImageView.heightAnchor.constraint(equalToConstant: 200),
            self.noWorkStatisticsOfYearImageView.centerXAnchor.constraint(equalTo: self.yearView.centerXAnchor),
            self.noWorkStatisticsOfYearImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        // yearPieChartView
        SupportingMethods.shared.makeConstraintsOf(self.yearPieChartView, sameAs: self.yearView)
        
        // statisticsSegmentControl
        NSLayoutConstraint.activate([
            self.segmentControl.topAnchor.constraint(equalTo: self.statisticsScrollView.bottomAnchor, constant: 16),
            self.segmentControl.heightAnchor.constraint(equalToConstant: 32),
            self.segmentControl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            self.segmentControl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8)
        ])
        
        // periodLabel
        NSLayoutConstraint.activate([
            self.periodLabel.topAnchor.constraint(equalTo: self.segmentControl.bottomAnchor, constant: 32),
            self.periodLabel.heightAnchor.constraint(equalToConstant: 19),
            self.periodLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
        
        // informationView
        NSLayoutConstraint.activate([
            self.informationView.topAnchor.constraint(equalTo: self.periodLabel.bottomAnchor, constant: 24),
            self.informationView.heightAnchor.constraint(equalToConstant: 88),
            self.informationView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.informationView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        
        // regularWorkTimeMarkView
        NSLayoutConstraint.activate([
            self.regularWorkTimeMarkView.centerYAnchor.constraint(equalTo: self.regularWorkTimeLabel.centerYAnchor),
            self.regularWorkTimeMarkView.heightAnchor.constraint(equalToConstant: 16),
            self.regularWorkTimeMarkView.leadingAnchor.constraint(equalTo: self.informationView.leadingAnchor),
            self.regularWorkTimeMarkView.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        // regularWorkTimeLabel
        NSLayoutConstraint.activate([
            self.regularWorkTimeLabel.topAnchor.constraint(equalTo: self.informationView.topAnchor),
            self.regularWorkTimeLabel.heightAnchor.constraint(equalToConstant: 24),
            self.regularWorkTimeLabel.leadingAnchor.constraint(equalTo: self.regularWorkTimeMarkView.trailingAnchor, constant: 16)
        ])
        
        // overtimeMarkView
        NSLayoutConstraint.activate([
            self.overtimeMarkView.centerYAnchor.constraint(equalTo: self.overtimeLabel.centerYAnchor),
            self.overtimeMarkView.heightAnchor.constraint(equalToConstant: 16),
            self.overtimeMarkView.leadingAnchor.constraint(equalTo: self.informationView.leadingAnchor),
            self.overtimeMarkView.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        // overtimeLabel
        NSLayoutConstraint.activate([
            self.overtimeLabel.topAnchor.constraint(equalTo: self.regularWorkTimeLabel.bottomAnchor, constant: 8),
            self.overtimeLabel.heightAnchor.constraint(equalToConstant: 24),
            self.overtimeLabel.leadingAnchor.constraint(equalTo: self.overtimeMarkView.trailingAnchor, constant: 16)
        ])
        
        // vacationMarkView
        NSLayoutConstraint.activate([
            self.vacationMarkView.centerYAnchor.constraint(equalTo: self.vacationLabel.centerYAnchor),
            self.vacationMarkView.heightAnchor.constraint(equalToConstant: 16),
            self.vacationMarkView.leadingAnchor.constraint(equalTo: self.informationView.leadingAnchor),
            self.vacationMarkView.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        // vacationLabel
        NSLayoutConstraint.activate([
            self.vacationLabel.topAnchor.constraint(equalTo: self.overtimeLabel.bottomAnchor, constant: 8),
            self.vacationLabel.heightAnchor.constraint(equalToConstant: 24),
            self.vacationLabel.leadingAnchor.constraint(equalTo: self.vacationMarkView.trailingAnchor, constant: 16)
        ])
    }
}

// MARK: Extension for methods added
extension WorkStatisticsViewController {
    enum StatisticsInformationType {
        case regularWorkTime
        case overtime
        case vacation
    }
    
    func makeInformationAttributedString(_ type: StatisticsInformationType, minutes: Int?) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        let attributedText = NSMutableAttributedString()
        var firstAttributedString: NSAttributedString!
        var secondAttributedString: NSAttributedString!
        
        switch type {
        case .regularWorkTime:
            firstAttributedString = NSAttributedString(string: "정규 근무 시간: ", attributes: [
                .font:UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor:UIColor.black,
                .paragraphStyle:paragraphStyle
            ])
            
            if let minutes = minutes {
                secondAttributedString = NSAttributedString(string: "\(self.calculateRegularTimeToHours(minutes))시간", attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
            } else {
                secondAttributedString = NSAttributedString(string: "0시간", attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
            }
            
        case .overtime:
            firstAttributedString = NSAttributedString(string: "초과 근무 시간: ", attributes: [
                .font:UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor:UIColor.black,
                .paragraphStyle:paragraphStyle
            ])
            
            if let minutes = minutes {
                secondAttributedString = NSAttributedString(string: self.calculateOvertimeToHours(minutes), attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
                
            } else {
                secondAttributedString = NSAttributedString(string: "0시간", attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
            }
            
        case .vacation:
            firstAttributedString = NSAttributedString(string: "휴가 기간: ", attributes: [
                .font:UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor:UIColor.black,
                .paragraphStyle:paragraphStyle
            ])
            
            if let minutes = minutes {
                secondAttributedString = NSAttributedString(string: "\(self.calculateVacationTimeToDays(minutes))일", attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
                
            } else {
                secondAttributedString = NSAttributedString(string: "0일", attributes: [
                    .font:UIFont.systemFont(ofSize: 20, weight: .bold),
                    .foregroundColor:UIColor.black,
                    .paragraphStyle:paragraphStyle
                ])
            }
        }
        
        attributedText.append(firstAttributedString)
        attributedText.append(secondAttributedString)
        
        return attributedText
    }
    
    func calculateRegularTimeToHours(_ minutes: Int) -> Int {
        return minutes / 60
    }
    
    func calculateOvertimeToHours(_ minutes: Int) -> String {
        let hours = minutes / 60
        let minutesLeft = minutes % 60
        
        if hours > 0 {
            if minutesLeft == 0 {
                return "\(hours)시간"
                
            } else {
                return "\(hours)시간 \(minutesLeft)분"
            }
            
        } else {
            if minutesLeft == 0 {
                return "0시간"
                
            } else {
                return "\(minutesLeft)분"
            }
        }
    }
    
    func calculateVacationTimeToDays(_ minutes: Int) -> String {
        return minutes % 480 > 0 ? "\(minutes / 480).5" : "\(minutes / 480)"
    }
    
    func determineInformationView(_ period: CompanyModel.StatisticsPeriod) {
        let dateFormatter = SupportingMethods.shared.makeDateFormatter("yyyy년 M월 d일")
        
        let todayTimeInterval = Int(self.today.timeIntervalSinceReferenceDate)
        let yesterday = Date(timeIntervalSinceReferenceDate: Double(todayTimeInterval - 86400))
        
        switch period {
        case .week:
            let yesterdayInterval = Int(yesterday.timeIntervalSinceReferenceDate)
            let weekdayOfYesterday = SupportingMethods.shared.getWeekdayOfDate(yesterday)
            let sundayOfYesterdayWeek = Date(timeIntervalSinceReferenceDate: Double(yesterdayInterval - 86400 * (weekdayOfYesterday - 1)))
            
            let statisticsValues = self.companyModel.calculateStatistics(.week, date: yesterday)
            
            self.statisticsScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            if statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0) {
                self.weekPieChartView.isHidden = true
                self.noWorkStatisticsOfWeekImageView.isHidden = false
                self.periodLabel.text = "근무 내역이 없습니다."
                self.informationView.isHidden = true
                
            } else {
                self.weekPieChartView.isHidden = false
                self.noWorkStatisticsOfWeekImageView.isHidden = true
                
                self.periodLabel.text = "\(dateFormatter.string(from: sundayOfYesterdayWeek)) ~ 어제"
                
                self.informationView.isHidden = false
                self.regularWorkTimeLabel.attributedText = self.makeInformationAttributedString(.regularWorkTime, minutes: statisticsValues?.regularWorkTime)
                self.overtimeLabel.attributedText = self.makeInformationAttributedString(.overtime, minutes: statisticsValues?.overtime)
                self.vacationLabel.attributedText = self.makeInformationAttributedString(.vacation, minutes: statisticsValues?.vacation)
            }
            
        case .month:
            let yearMonthDayOfYesterday = SupportingMethods.shared.getYearMonthAndDayOf(yesterday)
            let theFirstDateOfYesterdayMonth = SupportingMethods.shared.makeDateWithYear(yearMonthDayOfYesterday.year, month: yearMonthDayOfYesterday.month)
            
            let statisticsValues = self.companyModel.calculateStatistics(.month, date: yesterday)
            
            self.statisticsScrollView.setContentOffset(CGPoint(x: ReferenceValues.keyWindow.screen.bounds.width, y: 0), animated: true)
            
            if statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0) {
                self.monthPieChartView.isHidden = true
                self.noWorkStatisticsOfMonthImageView.isHidden = false
                self.periodLabel.text = "근무 내역이 없습니다."
                self.informationView.isHidden = true
                
            } else {
                self.monthPieChartView.isHidden = false
                self.noWorkStatisticsOfMonthImageView.isHidden = true
                
                self.periodLabel.text = "\(dateFormatter.string(from: theFirstDateOfYesterdayMonth)) ~ 어제"
                
                self.informationView.isHidden = false
                self.regularWorkTimeLabel.attributedText = self.makeInformationAttributedString(.regularWorkTime, minutes: statisticsValues?.regularWorkTime)
                self.overtimeLabel.attributedText = self.makeInformationAttributedString(.overtime, minutes: statisticsValues?.overtime)
                self.vacationLabel.attributedText = self.makeInformationAttributedString(.vacation, minutes: statisticsValues?.vacation)
            }
            
        case .year:
            let yearMonthDayOfYesterday = SupportingMethods.shared.getYearMonthAndDayOf(yesterday)
            let theFirstDateOfYesterdayYear = SupportingMethods.shared.makeDateWithYear(yearMonthDayOfYesterday.year, month: 1)
            
            let statisticsValues = self.companyModel.calculateStatistics(.year, date: yesterday)
            
            self.statisticsScrollView.setContentOffset(CGPoint(x: ReferenceValues.keyWindow.screen.bounds.width * 2, y: 0), animated: true)
            
            if statisticsValues == nil || (statisticsValues?.regularWorkTime == 0 && statisticsValues?.overtime == 0 && statisticsValues?.vacation == 0) {
                self.yearPieChartView.isHidden = true
                self.noWorkStatisticsOfYearImageView.isHidden = false
                self.periodLabel.text = "근무 내역이 없습니다."
                self.informationView.isHidden = true
                
            } else {
                self.yearPieChartView.isHidden = false
                self.noWorkStatisticsOfYearImageView.isHidden = true
                self.periodLabel.text = "\(dateFormatter.string(from: theFirstDateOfYesterdayYear)) ~ 어제"
                
                self.informationView.isHidden = false
                self.regularWorkTimeLabel.attributedText = self.makeInformationAttributedString(.regularWorkTime, minutes: statisticsValues?.regularWorkTime)
                self.overtimeLabel.attributedText = self.makeInformationAttributedString(.overtime, minutes: statisticsValues?.overtime)
                self.vacationLabel.attributedText = self.makeInformationAttributedString(.vacation, minutes: statisticsValues?.vacation)
            }
        }
    }
}

// MARK: - Extension for selector methods
extension WorkStatisticsViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func statisticsSegmentControl(_ sender: UISegmentedControl) {
        print("selectedSegmentIndex: \(sender.selectedSegmentIndex)")
        
        if sender.selectedSegmentIndex == 0 {
            self.determineInformationView(.week)
        }
        
        if sender.selectedSegmentIndex == 1 {
            self.determineInformationView(.month)
        }
        
        if sender.selectedSegmentIndex == 2 {
            self.determineInformationView(.year)
        }
    }
}

// MARK: - Extension for UIScrollViewDelegate
extension WorkStatisticsViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
        
        if scrollView.contentOffset.x >= 0 && scrollView.contentOffset.x <= 1 {
            print("1")
        }
        
        if scrollView.contentOffset.x >= ReferenceValues.keyWindow.screen.bounds.width - 1 &&
            scrollView.contentOffset.x <= ReferenceValues.keyWindow.screen.bounds.width + 1 {
            print("2")
        }
        
        if scrollView.contentOffset.x >= ReferenceValues.keyWindow.screen.bounds.width * 2 - 1 &&
            scrollView.contentOffset.x <= ReferenceValues.keyWindow.screen.bounds.width * 2 + 1 {
            print("3")
        }
    }
}
