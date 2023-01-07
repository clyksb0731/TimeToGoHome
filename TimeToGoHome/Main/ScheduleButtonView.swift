//
//  ScheduleButtonView.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/03/25.
//

import UIKit

enum ThreeScheduleType {
    case work
    case vacation
    case holiday
}

enum TwoScheduleForVacationType {
    case work
    case vacation
}

enum TwoScheduleForHolidayType {
    case work
    case holiday
}

enum AddOvertimeOrFinishWorkType {
    case overtime(Date)
    case finishWork
}

enum ReplaceOvertimeOrFinishWorkType {
    case overtime(Date)
    case finishWork
}

enum ScheduleButtonViewType {
    case threeSchedules(ThreeScheduleType?)
    case twoScheduleForVacation(TwoScheduleForVacationType?)
    case twoScheduleForHoliday(TwoScheduleForHolidayType?)
    case addOvertime
    case addOvertimeOrFinishWork(AddOvertimeOrFinishWorkType?)
    case replaceOvertimeOrFinishWork(ReplaceOvertimeOrFinishWorkType?)
    case finishWorkWithOvertime(Date?)
    case finishWork
    case workFinished
    case noButton
}

protocol ScheduleButtonViewDelegate {
    func scheduleButtonView(_ scheduleButtonView: ScheduleButtonView, of type: ScheduleButtonViewType)
}

extension ScheduleButtonViewDelegate {
    func scheduleButtonView(_ scheduleButtonView: ScheduleButtonView, of type: ScheduleButtonViewType) { }
}

class ScheduleButtonView: UIView {
    lazy var threeSchedulesView: UIView = {
        let view = self.initializeThreeSchedules()
        
        return view
    }()
    
    lazy var twoScheduleForVacationView: UIView = {
        let view = self.initializeTwoScheduleForVacation()
        
        return view
    }()
    
    lazy var twoScheduleForHolidayView: UIView = {
        let view = self.initializeTwoScheduleForHoliday()
        
        return view
    }()
    
    lazy var addOvertimeView: UIView = {
        let view = self.initializeAddOvertime()
        
        return view
    }()
    
    lazy var addOvertimeOrFinishWorkView: UIView = {
        let view = self.initializeAddOvertimeOrFinishWork()
        
        return view
    }()
    
    lazy var replaceOvertimeOrFinishWorkView: UIView = {
        let view = self.initializeReplaceOvertimeOrFinishWork()
        
        return view
    }()
    
    lazy var finishWorkWithOvertimeView: UIView = {
        let view = self.initializeFinishWorkWithOvertime()
        
        return view
    }()
    
    lazy var finishWorkView: UIView = {
        let view = self.initializeFinishWork()
        
        return view
    }()
    
    lazy var workFinishedView: UIView = {
        let view = self.initializeWorkFinished()
        
        return view
    }()
    
    lazy var noButtonView: UIView = {
        let view = self.initializeNoButton()
        
        return view
    }()
    
    weak var threeSchedulesPageControl: UIPageControl?
    weak var twoScheduleForVacationPageControl: UIPageControl?
    weak var twoScheduleForHolidayPageControl: UIPageControl?
    weak var threeSchedulesScrollView: UIScrollView?
    weak var twoScheduleForVacationScrollView: UIScrollView?
    weak var twoScheduleForHolidayScrollView: UIScrollView?
    weak var addOvertimeOrFinishWorkOvertimeLabel: UILabel?
    weak var replaceOvertimeOrFinishWorkOvertimeLabel: UILabel?
    var addOvertimeOrFinishWorkTimer: Timer?
    var replaceOvertimeOrFinishWorkTimer: Timer?
    
    private(set) var width: CGFloat
    private(set) var schedule: WorkScheduleModel?
    
    var delegate: ScheduleButtonViewDelegate?
    
    var previousPointX: CGFloat = 0
    var isHaptic: Bool = false

    init(_ buttonViewType:ScheduleButtonViewType = .addOvertime, width: CGFloat, schedule: WorkScheduleModel? = nil) {
        self.width = width
        self.schedule = schedule
        
        super.init(frame: .zero)
        
        self.setViewFoundation()
        self.setSubviews()
        self.setLayouts()
        
        self.showScheduleButtonView(type: buttonViewType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension for essential methods
extension ScheduleButtonView {
    // MARK: Set schedule button view type
    func setScheduleButtonView(_ buttonViewType: ScheduleButtonViewType,
                                   with schedule: WorkScheduleModel? = nil) {
        self.schedule = schedule
        
        self.showScheduleButtonView(type: buttonViewType)
    }
    
    // MARK: Set view foundation
    func setViewFoundation() {
        self.backgroundColor = .white
    }
    
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.threeSchedulesView,
            self.twoScheduleForVacationView,
            self.twoScheduleForHolidayView,
            self.addOvertimeView,
            self.addOvertimeOrFinishWorkView,
            self.replaceOvertimeOrFinishWorkView,
            self.finishWorkWithOvertimeView,
            self.finishWorkView,
            self.workFinishedView,
            self.noButtonView
        ], to: self)
    }
    
    func setLayouts() {
        // threeSchedules view layout
        SupportingMethods.shared.makeConstraintsOf(self.threeSchedulesView, sameAs: self)
        
        // twoScheduleForVacation view layout
        SupportingMethods.shared.makeConstraintsOf(self.twoScheduleForVacationView, sameAs: self)
        
        // twoScheduleForHoliday view layout
        SupportingMethods.shared.makeConstraintsOf(self.twoScheduleForHolidayView, sameAs: self)
        
        // addOvertime view layout
        SupportingMethods.shared.makeConstraintsOf(self.addOvertimeView, sameAs: self)
        
        // addOvertimeOrFinishWork view layout
        SupportingMethods.shared.makeConstraintsOf(self.addOvertimeOrFinishWorkView, sameAs: self)
        
        // replaceOvertimeOrFinishWork view layout
        SupportingMethods.shared.makeConstraintsOf(self.replaceOvertimeOrFinishWorkView, sameAs: self)
        
        // finishWorkWithOvertime view layout
        SupportingMethods.shared.makeConstraintsOf(self.finishWorkWithOvertimeView, sameAs: self)
        
        // finishWork view layout
        SupportingMethods.shared.makeConstraintsOf(self.finishWorkView, sameAs: self)
        
        // workFinished view layout
        SupportingMethods.shared.makeConstraintsOf(self.workFinishedView, sameAs: self)
        
        // noButton view layout
        SupportingMethods.shared.makeConstraintsOf(self.noButtonView, sameAs: self)
    }
}

// MARK: - Extension for methods added
extension ScheduleButtonView {
    func initializeThreeSchedules() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = .black
            pageControl.pageIndicatorTintColor = .gray
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = 3
            pageControl.isEnabled = false
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            return pageControl
        }()
        self.threeSchedulesPageControl = pageControl
        
        let scrollView:UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.tag = 1
            scrollView.bounces = false
            scrollView.contentSize = CGSize(width: self.width * 3, height: 75) // height: due to button's shadow
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            return scrollView
        }()
        self.threeSchedulesScrollView = scrollView
        
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let workTimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.work
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addWorkTimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let workTimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let workTimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(threeSchedulesWorkTimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let vacationTimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.vacation
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addvacationTimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let vacationTimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "휴가"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let vacationTimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(threeSchedulesVacationButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let holidayButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.holiday
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addHolidayButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleGrayButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let holidayButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.useRGB(red: 130, green: 130, blue: 130).cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .useRGB(red: 130, green: 130, blue: 130)
            label.textAlignment = .center
            label.text = "휴일"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let holidayButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(threeSchedulesHolidayButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            scrollView,
            pageControl
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            contentView
        ], to: scrollView)
        
        SupportingMethods.shared.addSubviews([
            workTimeButtonView,
            vacationTimeButtonView,
            holidayButtonView
        ], to: contentView)
        
        SupportingMethods.shared.addSubviews([
            addWorkTimeButtonImageView,
            workTimeButtonViewLabel,
            workTimeButton
        ], to: workTimeButtonView)
        
        SupportingMethods.shared.addSubviews([
            addvacationTimeButtonImageView,
            vacationTimeButtonViewLabel,
            vacationTimeButton
        ], to: vacationTimeButtonView)
        
        SupportingMethods.shared.addSubviews([
            addHolidayButtonImageView,
            holidayButtonViewLabel,
            holidayButton
        ], to: holidayButtonView)
        
        // MARK: Layouts
        // Page control layout
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: returnView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: returnView.centerXAnchor)
        ])
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 75),
            scrollView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width)
        ])
        
        // Work time button view layout
        NSLayoutConstraint.activate([
            workTimeButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            workTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            workTimeButtonView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.width/2),
            workTimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add work time button image view layout
        NSLayoutConstraint.activate([
            addWorkTimeButtonImageView.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            addWorkTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addWorkTimeButtonImageView.centerXAnchor.constraint(equalTo: workTimeButtonView.centerXAnchor),
            addWorkTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Work time button view label layout
        NSLayoutConstraint.activate([
            workTimeButtonViewLabel.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            workTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            workTimeButtonViewLabel.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor, constant: -34),
            workTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Work time button layout
        NSLayoutConstraint.activate([
            workTimeButton.topAnchor.constraint(equalTo: workTimeButtonView.topAnchor),
            workTimeButton.bottomAnchor.constraint(equalTo: workTimeButtonView.bottomAnchor),
            workTimeButton.leadingAnchor.constraint(equalTo: workTimeButtonView.leadingAnchor),
            workTimeButton.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor)
        ])
        
        // Vacation time button view layout
        NSLayoutConstraint.activate([
            vacationTimeButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vacationTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            vacationTimeButtonView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vacationTimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add vacation time button image view layout
        NSLayoutConstraint.activate([
            addvacationTimeButtonImageView.centerYAnchor.constraint(equalTo: vacationTimeButtonView.centerYAnchor),
            addvacationTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addvacationTimeButtonImageView.centerXAnchor.constraint(equalTo: vacationTimeButtonView.centerXAnchor),
            addvacationTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Vacation time button view label layout
        NSLayoutConstraint.activate([
            vacationTimeButtonViewLabel.centerYAnchor.constraint(equalTo: vacationTimeButtonView.centerYAnchor),
            vacationTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            vacationTimeButtonViewLabel.trailingAnchor.constraint(equalTo: vacationTimeButtonView.trailingAnchor, constant: -34),
            vacationTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Vacation time button layout
        NSLayoutConstraint.activate([
            vacationTimeButton.topAnchor.constraint(equalTo: vacationTimeButtonView.topAnchor),
            vacationTimeButton.bottomAnchor.constraint(equalTo: vacationTimeButtonView.bottomAnchor),
            vacationTimeButton.leadingAnchor.constraint(equalTo: vacationTimeButtonView.leadingAnchor),
            vacationTimeButton.trailingAnchor.constraint(equalTo: vacationTimeButtonView.trailingAnchor)
        ])
        
        // Holiday button view layout
        NSLayoutConstraint.activate([
            holidayButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            holidayButtonView.heightAnchor.constraint(equalToConstant: 70),
            holidayButtonView.centerXAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(self.width/2)),
            holidayButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add holiday button image view layout
        NSLayoutConstraint.activate([
            addHolidayButtonImageView.centerYAnchor.constraint(equalTo: holidayButtonView.centerYAnchor),
            addHolidayButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addHolidayButtonImageView.centerXAnchor.constraint(equalTo: holidayButtonView.centerXAnchor),
            addHolidayButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Holiday button view label layout
        NSLayoutConstraint.activate([
            holidayButtonViewLabel.centerYAnchor.constraint(equalTo: holidayButtonView.centerYAnchor),
            holidayButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            holidayButtonViewLabel.trailingAnchor.constraint(equalTo: holidayButtonView.trailingAnchor, constant: -34),
            holidayButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Holiday button layout
        NSLayoutConstraint.activate([
            holidayButton.topAnchor.constraint(equalTo: holidayButtonView.topAnchor),
            holidayButton.bottomAnchor.constraint(equalTo: holidayButtonView.bottomAnchor),
            holidayButton.leadingAnchor.constraint(equalTo: holidayButtonView.leadingAnchor),
            holidayButton.trailingAnchor.constraint(equalTo: holidayButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeTwoScheduleForVacation() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = .black
            pageControl.pageIndicatorTintColor = .gray
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = 2
            pageControl.isEnabled = false
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            return pageControl
        }()
        self.twoScheduleForVacationPageControl = pageControl
        
        let scrollView:UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.tag = 2
            scrollView.bounces = false
            scrollView.contentSize = CGSize(width: self.width * 2, height: 75) // height: due to button's shadow
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            return scrollView
        }()
        self.twoScheduleForVacationScrollView = scrollView
        
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let workTimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.work
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addWorkTimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let workTimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let workTimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(twoScheduleForVacationWorkTimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let vacationTimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.vacation
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addvacationTimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let vacationTimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "휴가"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let vacationTimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(twoScheduleForVacationVacationButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            scrollView,
            pageControl
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            contentView
        ], to: scrollView)
        
        SupportingMethods.shared.addSubviews([
            workTimeButtonView,
            vacationTimeButtonView,
        ], to: contentView)
        
        SupportingMethods.shared.addSubviews([
            addWorkTimeButtonImageView,
            workTimeButtonViewLabel,
            workTimeButton
        ], to: workTimeButtonView)
        
        SupportingMethods.shared.addSubviews([
            addvacationTimeButtonImageView,
            vacationTimeButtonViewLabel,
            vacationTimeButton
        ], to: vacationTimeButtonView)
        
        // MARK: Layouts
        // Page control layout
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: returnView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: returnView.centerXAnchor)
        ])
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 75),
            scrollView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width)
        ])
        
        // Work time button view layout
        NSLayoutConstraint.activate([
            workTimeButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            workTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            workTimeButtonView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.width/2),
            workTimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add work time button image view layout
        NSLayoutConstraint.activate([
            addWorkTimeButtonImageView.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            addWorkTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addWorkTimeButtonImageView.centerXAnchor.constraint(equalTo: workTimeButtonView.centerXAnchor),
            addWorkTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Work time button view label layout
        NSLayoutConstraint.activate([
            workTimeButtonViewLabel.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            workTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            workTimeButtonViewLabel.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor, constant: -34),
            workTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Work time button layout
        NSLayoutConstraint.activate([
            workTimeButton.topAnchor.constraint(equalTo: workTimeButtonView.topAnchor),
            workTimeButton.bottomAnchor.constraint(equalTo: workTimeButtonView.bottomAnchor),
            workTimeButton.leadingAnchor.constraint(equalTo: workTimeButtonView.leadingAnchor),
            workTimeButton.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor)
        ])
        
        // Vacation time button view layout
        NSLayoutConstraint.activate([
            vacationTimeButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            vacationTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            vacationTimeButtonView.centerXAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(self.width/2)),
            vacationTimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add vacation time button image view layout
        NSLayoutConstraint.activate([
            addvacationTimeButtonImageView.centerYAnchor.constraint(equalTo: vacationTimeButtonView.centerYAnchor),
            addvacationTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addvacationTimeButtonImageView.centerXAnchor.constraint(equalTo: vacationTimeButtonView.centerXAnchor),
            addvacationTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Vacation time button view label layout
        NSLayoutConstraint.activate([
            vacationTimeButtonViewLabel.centerYAnchor.constraint(equalTo: vacationTimeButtonView.centerYAnchor),
            vacationTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            vacationTimeButtonViewLabel.trailingAnchor.constraint(equalTo: vacationTimeButtonView.trailingAnchor, constant: -34),
            vacationTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Vacation time button layout
        NSLayoutConstraint.activate([
            vacationTimeButton.topAnchor.constraint(equalTo: vacationTimeButtonView.topAnchor),
            vacationTimeButton.bottomAnchor.constraint(equalTo: vacationTimeButtonView.bottomAnchor),
            vacationTimeButton.leadingAnchor.constraint(equalTo: vacationTimeButtonView.leadingAnchor),
            vacationTimeButton.trailingAnchor.constraint(equalTo: vacationTimeButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeTwoScheduleForHoliday() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.currentPage = 0
            pageControl.currentPageIndicatorTintColor = .black
            pageControl.pageIndicatorTintColor = .gray
            pageControl.hidesForSinglePage = true
            pageControl.numberOfPages = 2
            pageControl.isEnabled = false
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            return pageControl
        }()
        self.twoScheduleForHolidayPageControl = pageControl
        
        let scrollView:UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.tag = 3
            scrollView.bounces = false
            scrollView.contentSize = CGSize(width: self.width * 2, height: 75) // height: due to button's shadow
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            return scrollView
        }()
        self.twoScheduleForHolidayScrollView = scrollView
        
        let contentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let workTimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.work
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addWorkTimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let workTimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let workTimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(twoScheduleForHolidayWorkTimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let holidayButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.holiday
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addHolidayButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleGrayButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let holidayButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.useRGB(red: 130, green: 130, blue: 130).cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .useRGB(red: 130, green: 130, blue: 130)
            label.textAlignment = .center
            label.text = "휴일"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let holidayButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(twoScheduleForHolidayHolidayButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            scrollView,
            pageControl
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            contentView
        ], to: scrollView)
        
        SupportingMethods.shared.addSubviews([
            workTimeButtonView,
            holidayButtonView
        ], to: contentView)
        
        SupportingMethods.shared.addSubviews([
            addWorkTimeButtonImageView,
            workTimeButtonViewLabel,
            workTimeButton
        ], to: workTimeButtonView)
        
        SupportingMethods.shared.addSubviews([
            addHolidayButtonImageView,
            holidayButtonViewLabel,
            holidayButton
        ], to: holidayButtonView)
        
        // MARK: Layouts
        // Page control layout
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: returnView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: returnView.centerXAnchor)
        ])
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 75),
            scrollView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: returnView.trailingAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width)
        ])
        
        // Work time button view layout
        NSLayoutConstraint.activate([
            workTimeButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            workTimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            workTimeButtonView.centerXAnchor.constraint(equalTo: contentView.leadingAnchor, constant: self.width/2),
            workTimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add work time button image view layout
        NSLayoutConstraint.activate([
            addWorkTimeButtonImageView.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            addWorkTimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addWorkTimeButtonImageView.centerXAnchor.constraint(equalTo: workTimeButtonView.centerXAnchor),
            addWorkTimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Work time button view label layout
        NSLayoutConstraint.activate([
            workTimeButtonViewLabel.centerYAnchor.constraint(equalTo: workTimeButtonView.centerYAnchor),
            workTimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            workTimeButtonViewLabel.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor, constant: -34),
            workTimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Work time button layout
        NSLayoutConstraint.activate([
            workTimeButton.topAnchor.constraint(equalTo: workTimeButtonView.topAnchor),
            workTimeButton.bottomAnchor.constraint(equalTo: workTimeButtonView.bottomAnchor),
            workTimeButton.leadingAnchor.constraint(equalTo: workTimeButtonView.leadingAnchor),
            workTimeButton.trailingAnchor.constraint(equalTo: workTimeButtonView.trailingAnchor)
        ])
        
        // Holiday button view layout
        NSLayoutConstraint.activate([
            holidayButtonView.topAnchor.constraint(equalTo: contentView.topAnchor),
            holidayButtonView.heightAnchor.constraint(equalToConstant: 70),
            holidayButtonView.centerXAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(self.width/2)),
            holidayButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add holiday button image view layout
        NSLayoutConstraint.activate([
            addHolidayButtonImageView.centerYAnchor.constraint(equalTo: holidayButtonView.centerYAnchor),
            addHolidayButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addHolidayButtonImageView.centerXAnchor.constraint(equalTo: holidayButtonView.centerXAnchor),
            addHolidayButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Holiday button view label layout
        NSLayoutConstraint.activate([
            holidayButtonViewLabel.centerYAnchor.constraint(equalTo: holidayButtonView.centerYAnchor),
            holidayButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            holidayButtonViewLabel.trailingAnchor.constraint(equalTo: holidayButtonView.trailingAnchor, constant: -34),
            holidayButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Holiday button layout
        NSLayoutConstraint.activate([
            holidayButton.topAnchor.constraint(equalTo: holidayButtonView.topAnchor),
            holidayButton.bottomAnchor.constraint(equalTo: holidayButtonView.bottomAnchor),
            holidayButton.leadingAnchor.constraint(equalTo: holidayButtonView.leadingAnchor),
            holidayButton.trailingAnchor.constraint(equalTo: holidayButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeAddOvertime() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let overtimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.overtime
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addOvertimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let overtimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "추가 근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let overtimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(addOvertimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            overtimeButtonView
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            addOvertimeButtonImageView,
            overtimeButtonViewLabel,
            overtimeButton
        ], to: overtimeButtonView)
        
        // MARK: Layouts
        // Overtime button view layout
        NSLayoutConstraint.activate([
            overtimeButtonView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            overtimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            overtimeButtonView.centerXAnchor.constraint(equalTo: returnView.centerXAnchor),
            overtimeButtonView.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        // Add overtime button image view layout
        NSLayoutConstraint.activate([
            addOvertimeButtonImageView.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            addOvertimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addOvertimeButtonImageView.centerXAnchor.constraint(equalTo: overtimeButtonView.centerXAnchor),
            addOvertimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Overtime button view label layout
        NSLayoutConstraint.activate([
            overtimeButtonViewLabel.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            overtimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            overtimeButtonViewLabel.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor, constant: -34),
            overtimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 61)
        ])
        
        // Overtime button layout
        NSLayoutConstraint.activate([
            overtimeButton.topAnchor.constraint(equalTo: overtimeButtonView.topAnchor),
            overtimeButton.bottomAnchor.constraint(equalTo: overtimeButtonView.bottomAnchor),
            overtimeButton.leadingAnchor.constraint(equalTo: overtimeButtonView.leadingAnchor),
            overtimeButton.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeAddOvertimeOrFinishWork() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let overtimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.overtime
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addOvertimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "addScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let overtimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "추가 근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let overtimeLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            label.textColor = .red
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        self.addOvertimeOrFinishWorkOvertimeLabel = overtimeLabel
        
        let overtimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(addOvertimeOrFinishWorkOvertimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let finishWorkButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .Schedule.finishWork
            button.layer.cornerRadius = 15
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.titleLabel?.numberOfLines = 0
            button.setTitle("업무\n종료", for: .normal)
            button.addTarget(self, action: #selector(addOvertimeOrFinishWorkFinishWorkButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            overtimeButtonView,
            finishWorkButton
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            addOvertimeButtonImageView,
            overtimeButtonViewLabel,
            overtimeLabel,
            overtimeButton
        ], to: overtimeButtonView)
        
        // MARK: Layouts
        // Finish work button view layout
        NSLayoutConstraint.activate([
            finishWorkButton.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            finishWorkButton.heightAnchor.constraint(equalToConstant: 70),
            finishWorkButton.trailingAnchor.constraint(equalTo: returnView.trailingAnchor, constant: -20),
            finishWorkButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // Overtime button view layout
        NSLayoutConstraint.activate([
            overtimeButtonView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            overtimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            overtimeButtonView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: 20),
            overtimeButtonView.trailingAnchor.constraint(equalTo: finishWorkButton.leadingAnchor, constant: -15),
        ])
        
        // Add overtime button image view layout
        NSLayoutConstraint.activate([
            addOvertimeButtonImageView.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            addOvertimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addOvertimeButtonImageView.centerXAnchor.constraint(equalTo: overtimeButtonView.centerXAnchor),
            addOvertimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Overtime button view label layout
        NSLayoutConstraint.activate([
            overtimeButtonViewLabel.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            overtimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            overtimeButtonViewLabel.leadingAnchor.constraint(equalTo: overtimeButtonView.leadingAnchor, constant: 20),
            overtimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 51)
        ])
        
        // Overtime label layout
        NSLayoutConstraint.activate([
            overtimeLabel.topAnchor.constraint(equalTo: overtimeButtonView.topAnchor, constant: 10),
            overtimeLabel.heightAnchor.constraint(equalToConstant: 22),
            overtimeLabel.leadingAnchor.constraint(equalTo: addOvertimeButtonImageView.trailingAnchor, constant: 5),
            overtimeLabel.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor, constant: -20)
        ])
        
        // Overtime button layout
        NSLayoutConstraint.activate([
            overtimeButton.topAnchor.constraint(equalTo: overtimeButtonView.topAnchor),
            overtimeButton.bottomAnchor.constraint(equalTo: overtimeButtonView.bottomAnchor),
            overtimeButton.leadingAnchor.constraint(equalTo: overtimeButtonView.leadingAnchor),
            overtimeButton.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeReplaceOvertimeOrFinishWork() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let overtimeButtonView: UIView = {
            let view = UIView()
            view.backgroundColor = .Schedule.overtime
            view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
            view.layer.cornerRadius = 15
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let addOvertimeButtonImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "replaceScheduleWhiteButtonImage"))
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            return imageView
        }()
        
        let overtimeButtonViewLabel: UILabel = {
            let label = UILabel()
            label.layer.cornerRadius = 7
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 1
            label.font = .systemFont(ofSize: 10)
            label.textColor = .white
            label.textAlignment = .center
            label.text = "추가 근무"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        let overtimeLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            label.textColor = .red
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        self.replaceOvertimeOrFinishWorkOvertimeLabel = overtimeLabel
        
        let overtimeButton: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(replaceOvertimeOrFinishWorkOvertimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        let finishWorkButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .Schedule.finishWork
            button.layer.cornerRadius = 15
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.titleLabel?.numberOfLines = 0
            button.setTitle("업무\n종료", for: .normal)
            button.addTarget(self, action: #selector(replaceOvertimeOrFinishWorkFinishWorkButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            overtimeButtonView,
            finishWorkButton
        ], to: returnView)
        
        SupportingMethods.shared.addSubviews([
            addOvertimeButtonImageView,
            overtimeButtonViewLabel,
            overtimeLabel,
            overtimeButton
        ], to: overtimeButtonView)
        
        // MARK: Layouts
        // Finish work button view layout
        NSLayoutConstraint.activate([
            finishWorkButton.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            finishWorkButton.heightAnchor.constraint(equalToConstant: 70),
            finishWorkButton.trailingAnchor.constraint(equalTo: returnView.trailingAnchor, constant: -20),
            finishWorkButton.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // Overtime button view layout
        NSLayoutConstraint.activate([
            overtimeButtonView.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            overtimeButtonView.heightAnchor.constraint(equalToConstant: 70),
            overtimeButtonView.leadingAnchor.constraint(equalTo: returnView.leadingAnchor, constant: 20),
            overtimeButtonView.trailingAnchor.constraint(equalTo: finishWorkButton.leadingAnchor, constant: -15),
        ])
        
        // Add overtime button image view layout
        NSLayoutConstraint.activate([
            addOvertimeButtonImageView.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            addOvertimeButtonImageView.heightAnchor.constraint(equalToConstant: 34),
            addOvertimeButtonImageView.centerXAnchor.constraint(equalTo: overtimeButtonView.centerXAnchor),
            addOvertimeButtonImageView.widthAnchor.constraint(equalToConstant: 34)
        ])
        
        // Overtime button view label layout
        NSLayoutConstraint.activate([
            overtimeButtonViewLabel.centerYAnchor.constraint(equalTo: overtimeButtonView.centerYAnchor),
            overtimeButtonViewLabel.heightAnchor.constraint(equalToConstant: 21),
            overtimeButtonViewLabel.leadingAnchor.constraint(equalTo: overtimeButtonView.leadingAnchor, constant: 20),
            overtimeButtonViewLabel.widthAnchor.constraint(equalToConstant: 51)
        ])
        
        // Overtime label layout
        NSLayoutConstraint.activate([
            overtimeLabel.topAnchor.constraint(equalTo: overtimeButtonView.topAnchor, constant: 10),
            overtimeLabel.heightAnchor.constraint(equalToConstant: 22),
            overtimeLabel.leadingAnchor.constraint(equalTo: addOvertimeButtonImageView.trailingAnchor, constant: 5),
            overtimeLabel.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor, constant: -20)
        ])
        
        // Overtime button layout
        NSLayoutConstraint.activate([
            overtimeButton.topAnchor.constraint(equalTo: overtimeButtonView.topAnchor),
            overtimeButton.bottomAnchor.constraint(equalTo: overtimeButtonView.bottomAnchor),
            overtimeButton.leadingAnchor.constraint(equalTo: overtimeButtonView.leadingAnchor),
            overtimeButton.trailingAnchor.constraint(equalTo: overtimeButtonView.trailingAnchor)
        ])
        
        return returnView
    }
    
    func initializeFinishWorkWithOvertime() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let finishWorkButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .Schedule.finishWork
            button.layer.cornerRadius = 15
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.setTitle("지금 업무 종료", for: .normal)
            button.addTarget(self, action: #selector(finishWorkWithOvertimeButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            finishWorkButton
        ], to: returnView)
        
        // MARK: Layouts
        // Finish work button layout
        NSLayoutConstraint.activate([
            finishWorkButton.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            finishWorkButton.heightAnchor.constraint(equalToConstant: 70),
            finishWorkButton.centerXAnchor.constraint(equalTo: returnView.centerXAnchor),
            finishWorkButton.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        return returnView
    }
    
    func initializeFinishWork() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let finishWorkButton: UIButton = {
            let button = UIButton()
            button.backgroundColor = .Schedule.finishWork
            button.layer.cornerRadius = 15
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
            button.setTitle("업무 종료", for: .normal)
            button.addTarget(self, action: #selector(finishWorkButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            finishWorkButton
        ], to: returnView)
        
        // MARK: Layouts
        // Finish work button layout
        NSLayoutConstraint.activate([
            finishWorkButton.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            finishWorkButton.heightAnchor.constraint(equalToConstant: 70),
            finishWorkButton.centerXAnchor.constraint(equalTo: returnView.centerXAnchor),
            finishWorkButton.widthAnchor.constraint(equalToConstant: self.width - 40)
        ])
        
        return returnView
    }
    
    func initializeWorkFinished() -> UIView {
        // MARK: Initialize
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let workFinishedLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 30, weight: .bold)
            label.textAlignment = .center
            label.textColor = .useRGB(red: 242, green: 242, blue: 242)
            label.text = "업무 종료"
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        
        // MARK: Subviews
        SupportingMethods.shared.addSubviews([
            workFinishedLabel
        ], to: returnView)
        
        // MARK: Layouts
        // Work finished label layout
        NSLayoutConstraint.activate([
            workFinishedLabel.bottomAnchor.constraint(equalTo: returnView.bottomAnchor, constant: -31),
            workFinishedLabel.heightAnchor.constraint(equalToConstant: 70),
            workFinishedLabel.centerXAnchor.constraint(equalTo: returnView.centerXAnchor),
            workFinishedLabel.widthAnchor.constraint(equalToConstant: 127)
        ])
        
        return returnView
    }
    
    func initializeNoButton() -> UIView {
        let returnView:UIView = {
            let view = UIView()
            view.isHidden = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        // MARK: Initialize
        
        // MARK: Subviews
        
        // MARK: Layouts
        
        return returnView
    }
    
    // MARK: Show ScheduleButtonView depending on type
    func showScheduleButtonView(type buttonViewType: ScheduleButtonViewType) {
        switch buttonViewType {
        case .threeSchedules:
            guard self.threeSchedulesView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = false
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .twoScheduleForVacation:
            guard self.twoScheduleForVacationView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = false
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .twoScheduleForHoliday:
            guard self.twoScheduleForHolidayView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = false
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .addOvertime:
            guard self.addOvertimeView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = false
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .addOvertimeOrFinishWork:
            guard self.addOvertimeOrFinishWorkView.isHidden else {
                return
            }
            
            self.resetView()
            
            // MARK: addOvertimeOrFinishWork Timer
            self.addOvertimeOrFinishWorkTimer = self.makeTimerForButtonState(type: buttonViewType)
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = false
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .replaceOvertimeOrFinishWork:
            guard self.replaceOvertimeOrFinishWorkView.isHidden else {
                return
            }
            
            self.resetView()
            
            // MARK: replaceOvertimeOrFinishWork Timer
            self.replaceOvertimeOrFinishWorkTimer = self.makeTimerForButtonState(type: buttonViewType)
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = false
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .finishWorkWithOvertime:
            guard self.finishWorkWithOvertimeView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = false
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .finishWork:
            guard self.finishWorkView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = false
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = true
            
        case .workFinished:
            guard self.workFinishedView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = false
            self.noButtonView.isHidden = true
            
        case .noButton:
            guard self.noButtonView.isHidden else {
                return
            }
            
            self.resetView()
            
            self.threeSchedulesView.isHidden = true
            self.twoScheduleForVacationView.isHidden = true
            self.twoScheduleForHolidayView.isHidden = true
            self.addOvertimeView.isHidden = true
            self.addOvertimeOrFinishWorkView.isHidden = true
            self.replaceOvertimeOrFinishWorkView.isHidden = true
            self.finishWorkWithOvertimeView.isHidden = true
            self.finishWorkView.isHidden = true
            self.workFinishedView.isHidden = true
            self.noButtonView.isHidden = false
        }
    }
    
    func makeTimerForButtonState(type buttonViewType: ScheduleButtonViewType) -> Timer? {
        guard let overtime = self.calculateOvertime() else {
            return nil
        }
        
        var timer: Timer?
        
        if case .addOvertimeOrFinishWork = buttonViewType {
            self.addOvertimeOrFinishWorkOvertimeLabel?.text = "\(SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(overtime))"
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(addOvertimeOrFinishWorkTimer(_:)), userInfo: nil, repeats: true)
        }
        
        if case .replaceOvertimeOrFinishWork = buttonViewType {
            self.replaceOvertimeOrFinishWorkOvertimeLabel?.text = "\(SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(overtime))"
            
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(replaceOvertimeOrFinishWorkTimer(_:)), userInfo: nil, repeats: true)
        }
        
        return timer
    }
    
    func calculateOvertime() -> Int? {
        guard let schedule = self.schedule, let startingWorkTime = schedule.startingWorkTimeSecondsSinceReferenceDate else {
            return nil
        }
        
        var timeScheduled = 0
        if case .morning(let workType) = schedule.morning, case .work = workType,
           case .afternoon(let workType) = schedule.afternoon, case .work = workType {
            // FIXME: App Setting of rest times as default
            timeScheduled = WorkScheduleModel.secondsOfWorkTime + WorkScheduleModel.secondsOfLunchTime + WorkScheduleModel.secondsOfWorkTime + 0 // launch + dinner time setting
            
        } else {
            // FIXME: App Setting of rest times as default
            timeScheduled = WorkScheduleModel.secondsOfWorkTime + 0 // dinner time setting
        }
        
        return SupportingMethods.getCurrentTimeSeconds() - (timeScheduled + startingWorkTime)
    }
    
    func resetView() {
        if self.addOvertimeOrFinishWorkTimer != nil, self.addOvertimeOrFinishWorkTimer!.isValid {
            self.addOvertimeOrFinishWorkTimer?.invalidate()
        }
        
        if self.replaceOvertimeOrFinishWorkTimer != nil, self.replaceOvertimeOrFinishWorkTimer!.isValid {
            self.replaceOvertimeOrFinishWorkTimer?.invalidate()
        }
        
        self.threeSchedulesScrollView?.delegate = nil
        if let threeSchedulesScrollView = self.threeSchedulesScrollView,  threeSchedulesScrollView.contentOffset.x != 0 {
            threeSchedulesScrollView.setContentOffset(
                CGPoint(x:0, y:threeSchedulesScrollView.contentOffset.y), animated: false)
        }
        self.threeSchedulesScrollView?.delegate = self
        
        self.twoScheduleForVacationScrollView?.delegate = nil
        if let twoScheduleForVacationScrollView = self.twoScheduleForVacationScrollView, twoScheduleForVacationScrollView.contentOffset.x != 0 {
            twoScheduleForVacationScrollView.setContentOffset(
                CGPoint(x:0, y:twoScheduleForVacationScrollView.contentOffset.y), animated: false)
        }
        self.twoScheduleForVacationScrollView?.delegate = self
        
        self.twoScheduleForHolidayScrollView?.delegate = nil
        if let twoScheduleForHolidayScrollView = self.twoScheduleForHolidayScrollView, twoScheduleForHolidayScrollView.contentOffset.x != 0 {
            twoScheduleForHolidayScrollView.setContentOffset(
                CGPoint(x:0, y:twoScheduleForHolidayScrollView.contentOffset.y), animated: false)
        }
        self.twoScheduleForHolidayScrollView?.delegate = self
        
        self.threeSchedulesPageControl?.currentPage = 0
        self.twoScheduleForVacationPageControl?.currentPage = 0
        self.twoScheduleForHolidayPageControl?.currentPage = 0
        
        self.previousPointX = 0
        self.isHaptic = false
    }
}

// MARK: - Extension for selector methods
extension ScheduleButtonView {
    // MARK: Schedule buttons
    // threeSchedules - work
    @objc func threeSchedulesWorkTimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .threeSchedules(.work))
    }
    
    @objc func threeSchedulesVacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .threeSchedules(.vacation))
    }
    
    @objc func threeSchedulesHolidayButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .threeSchedules(.holiday))
    }
    
    // twoScheduleForVacation
    @objc func twoScheduleForVacationWorkTimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .twoScheduleForVacation(.work))
    }
    
    @objc func twoScheduleForVacationVacationButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .twoScheduleForVacation(.vacation))
    }
    
    // twoScheduleForHoliday
    @objc func twoScheduleForHolidayWorkTimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .twoScheduleForHoliday(.work))
    }
    
    @objc func twoScheduleForHolidayHolidayButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .twoScheduleForHoliday(.holiday))
    }
    
    // addOvertime
    @objc func addOvertimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .addOvertime)
    }
    
    // addOvertimeOrFinishWork - overtime
    @objc func addOvertimeOrFinishWorkOvertimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .addOvertimeOrFinishWork(.overtime(Date())))
    }
    
    // addOvertimeOrFinishWork - finishWork
    @objc func addOvertimeOrFinishWorkFinishWorkButton(_ sender: UIButton) {
        self.delegate?.scheduleButtonView(self, of: .addOvertimeOrFinishWork(.finishWork))
    }
    
    // replaceOvertimeOrFinishWork - overtime
    @objc func replaceOvertimeOrFinishWorkOvertimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.delegate?.scheduleButtonView(self, of: .replaceOvertimeOrFinishWork(.overtime(Date())))
    }
    
    // replaceOvertimeOrFinishWork - finishWork
    @objc func replaceOvertimeOrFinishWorkFinishWorkButton(_ sender: UIButton) {
        self.delegate?.scheduleButtonView(self, of: .replaceOvertimeOrFinishWork(.finishWork))
    }
    
    // finishWorkWithOvertime
    @objc func finishWorkWithOvertimeButton(_ sender: UIButton) {
        self.delegate?.scheduleButtonView(self, of: .finishWorkWithOvertime(Date()))
        
        // MARK: For test
        //let testTempDate = SupportingMethods.makeTempTimeDate(hour: 17, minute: 3, second: 0)
        //self.delegate?.scheduleButtonView(self, of: .finishWorkWithOvertime(testTempDate))
    }
    
    // finishWork
    @objc func finishWorkButton(_ sender: UIButton) {
        self.delegate?.scheduleButtonView(self, of: .finishWork)
    }
    
    // MARK: Timers
    // addOvertimeOrFinishWork timer
    @objc func addOvertimeOrFinishWorkTimer(_ timer: Timer) {
        if self.addOvertimeOrFinishWorkOvertimeLabel?.textColor == .yellow {
            self.addOvertimeOrFinishWorkOvertimeLabel?.textColor = .red
            
        } else {
            self.addOvertimeOrFinishWorkOvertimeLabel?.textColor = .yellow
        }
        
        self.addOvertimeOrFinishWorkOvertimeLabel?.text = "\(SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(self.calculateOvertime()!))"
    }
    
    // replaceOvertimeOrFinishWork timer
    @objc func replaceOvertimeOrFinishWorkTimer(_ timer: Timer) {
        if self.replaceOvertimeOrFinishWorkOvertimeLabel?.textColor == .yellow {
            self.replaceOvertimeOrFinishWorkOvertimeLabel?.textColor = .red
            
        } else {
            self.replaceOvertimeOrFinishWorkOvertimeLabel?.textColor = .yellow
        }
        
        self.replaceOvertimeOrFinishWorkOvertimeLabel?.text = "\(SupportingMethods.shared.determineAdditionalHourAndMinuteUsingSecond(self.calculateOvertime()!))"
    }
}

// MARK: - Extension for UIScrollViewDelegate
extension ScheduleButtonView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll: \(scrollView.contentOffset.x)")
        
        let centerXPoint: CGFloat = scrollView.frame.width / 2
        //print("CneterXPoint: \(centerXPoint)")
        
        if scrollView.tag == 1 {
            if self.previousPointX >= 0 && self.previousPointX < centerXPoint {
                if scrollView.contentOffset.x >= centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.threeSchedulesPageControl?.currentPage = 1
                    
                } else {
                    self.isHaptic = false
                    
                    self.threeSchedulesPageControl?.currentPage = 0
                }
                
            } else if self.previousPointX >= scrollView.frame.width && self.previousPointX < scrollView.frame.width + centerXPoint {
                if scrollView.contentOffset.x >= scrollView.frame.width + centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.threeSchedulesPageControl?.currentPage = 2
                    
                } else {
                    if scrollView.contentOffset.x < centerXPoint {
                        if !self.isHaptic {
                            UIDevice.softHaptic()
                            self.isHaptic = true
                        }
                        
                        self.threeSchedulesPageControl?.currentPage = 0
                        
                    } else {
                        self.isHaptic = false
                        
                        self.threeSchedulesPageControl?.currentPage = 1
                    }
                }
                
            } else {
                if scrollView.contentOffset.x < scrollView.frame.width + centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.threeSchedulesPageControl?.currentPage = 1
                    
                } else {
                    self.isHaptic = false
                    
                    self.threeSchedulesPageControl?.currentPage = 2
                }
            }
        }
        
        if scrollView.tag == 2 {
            if self.previousPointX >= 0 && self.previousPointX < centerXPoint {
                if scrollView.contentOffset.x >= centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.twoScheduleForVacationPageControl?.currentPage = 1
                    
                } else {
                    self.isHaptic = false
                    
                    self.twoScheduleForVacationPageControl?.currentPage = 0
                }
                
            } else {
                if scrollView.contentOffset.x < centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.twoScheduleForVacationPageControl?.currentPage = 0
                    
                } else {
                    self.isHaptic = false
                    
                    self.twoScheduleForVacationPageControl?.currentPage = 1
                }
            }
        }
        
        if scrollView.tag == 3 {
            if self.previousPointX >= 0 && self.previousPointX < centerXPoint {
                if scrollView.contentOffset.x >= centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.twoScheduleForHolidayPageControl?.currentPage = 1
                    
                } else {
                    self.isHaptic = false
                    
                    self.twoScheduleForHolidayPageControl?.currentPage = 0
                }
                
            } else {
                if scrollView.contentOffset.x < centerXPoint {
                    if !self.isHaptic {
                        UIDevice.softHaptic()
                        self.isHaptic = true
                    }
                    
                    self.twoScheduleForHolidayPageControl?.currentPage = 0
                    
                } else {
                    self.isHaptic = false
                    
                    self.twoScheduleForHolidayPageControl?.currentPage = 1
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //print("scrollViewDidEndScrollingAnimation: \(scrollView.contentOffset.x)")
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        //print("scrollViewWillBeginDecelerating: \(scrollView.contentOffset.x)")
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("scrollViewDidEndDecelerating: \(scrollView.contentOffset.x)")
        
        self.isHaptic = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //print("scrollViewWillBeginDragging: \(scrollView.contentOffset.x)")
        
        self.previousPointX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            //print("scrollViewDidEndDragging willDecelerate: \(scrollView.contentOffset.x)")
            
        } else {
            //print("scrollViewDidEndDragging willNotDecelerate: \(scrollView.contentOffset.x)")
        }
    }
}
