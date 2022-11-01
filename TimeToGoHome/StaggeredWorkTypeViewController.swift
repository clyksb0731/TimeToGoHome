//
//  StaggeredWorkTypeViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2022/04/04.
//

import UIKit

enum StaggeredMarkingViewType {
    case morningEarliest(CGPoint)
    case morningLatest(CGPoint)
    case lunchTime(CGPoint)
    case afternoonEarliest(CGPoint)
    case afternoonLatest(CGPoint)
}

enum WorkType: String {
    case staggered
    case normal
}

enum TimeRange: String {
    case earliestTime
    case latestTime
}

class StaggeredWorkTypeViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.tag = 1
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 674)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dismissButtonImage"), for: .normal)
        button.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "근무 형태"
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = UIColor.useRGB(red: 109, green: 114, blue: 120, alpha: 0.4)
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var staggeredTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("시차출퇴근형", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.useRGB(red: 78, green: 216, blue: 220)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var normalTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("일반형", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        button.layer.cornerRadius = 5
        button.backgroundColor = UIColor.useRGB(red: 78, green: 216, blue: 220)
        button.alpha = 0.5
        button.addTarget(self, action: #selector(workTypeButtons(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var momentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.text = "오전"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "빠른 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningEarliestAttendance7Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "7"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningEarliestAttendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningEarliestAttendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningEarliestAttendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningEarliestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 167, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let earliestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(morningEarliestAttendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(earliestAttendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningEarliestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let earliestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(morningEarliestAttendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(earliestAttendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    lazy var morningLatestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "늦은 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLatestAttendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLatestAttendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLatestAttendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLatestAttendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningLatestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 167, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let latestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(morningLatestAttendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(latestAttendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningLatestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let latestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(morningLatestAttendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(latestAttendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    lazy var lunchTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "점심 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTime11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTime12Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "12"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTime13Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "13"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTime14Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "14"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTime15Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "15"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var lunchTimeTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 245, blue: 156, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let lunchTimeTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(lunchTimeTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(lunchTimeTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var lunchTimeTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 205, blue: 167, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var lunchTimeTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 255, green: 208, blue: 121)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let lunchTimeTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(lunchTimeTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(lunchTimeTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    lazy var ignoringLunchTimeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ignoringLunchTimeButtonNormalImage"), for: .normal)
        button.setImage(UIImage(named: "ignoringLunchTimeButtonSelectedImage"), for: .selected)
        button.addTarget(self, action: #selector(ignoringLunchTimeButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var ignoringLunchTimeMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .useRGB(red: 221, green: 221, blue: 221)
        label.text = "반차 시 점심시간 무시"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        label.text = "오후 (오전 반차 시)"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonTimeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "빠른 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendance12Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "12"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendance13Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "13"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendance14Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "14"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendance15Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "15"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 176, green: 255, blue: 186, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonEarliestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(afternoonEarliestAttendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(afternoonEarliestAttendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarFourthHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarFifthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 187, green: 187, blue: 187, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonEarliestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonEarliestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(afternoonEarliestAttendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(afternoonEarliestAttendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "늦은 출근"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendance12Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "12"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendance13Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "13"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendance14Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "14"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendance15Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "15"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendance16Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "16"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonLatestAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 176, green: 255, blue: 186, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonLatestAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(afternoonLatestAttendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(afternoonLatestAttendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarFourthHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarFifthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceAreaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 187, green: 187, blue: 187, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonLatestAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonLatestAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(afternoonLatestAttendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(afternoonLatestAttendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    
    lazy var nextButtonView: UIView = {
        let view = UIView()
        view.layer.useSketchShadow(color: .black, alpha: 1, x: 0, y: 1, blur: 4, spread: 0)
        view.backgroundColor = UIColor.useRGB(red: 146, green: 243, blue: 205)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var nextButtonImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nextSelectedImage"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.addTarget(self, action: #selector(nextButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var workType: WorkType = .staggered
    
    var morningEarliestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var morningLatestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var lunchTimeAreaCenterXAnchorConstraint: NSLayoutConstraint!
    var lunchTimeTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var afternoonEarliestAttendaceAreaCenterXAnchorConstraint: NSLayoutConstraint!
    var afternoonEarliestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var afternoonLatestAttendaceAreaCenterXAnchorConstraint: NSLayoutConstraint!
    var afternoonLatestAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    
    var previousAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant: CGFloat = 12 + 23.25
    var previousAfternoonLatestAttendaceTimeBarMarkingViewConstraintConstant: CGFloat = 12 + 93

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeViews()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        self.nextButtonView.layer.shadowOpacity = self.scrollView.contentSize.height - self.scrollView.frame.height > 0 ? 1 : 0
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    deinit {
            print("----------------------------------- StaggeredWorkTypeViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension StaggeredWorkTypeViewController {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // Initialize views
    func initializeViews() {
        
    }
    
    // Set targets
    func setTargets() {
        
    }
    
    // Set gestures
    func setGestures() {
        
    }
    
    // Set delegates
    func setDelegates() {
        
    }
    
    // Set notificationCenters
    func setNotificationCenters() {
        
    }
    
    // Set subviews
    func setSubviews() {
        SupportingMethods.shared.addSubviews([
            self.scrollView,
            self.nextButtonView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
            self.dismissButton,
            self.titleLabel,
            self.staggeredTypeButton,
            self.normalTypeButton,
            self.momentLabel,
            self.morningLabel,
            self.morningTimeView,
            self.lunchTimeView,
            self.afternoonLabel,
            self.afternoonTimeView
        ], to: self.contentView)
        
        SupportingMethods.shared.addSubviews([
            self.morningEarliestAttendanceMarkLabel,
            self.morningEarliestAttendance7Label,
            self.morningEarliestAttendance8Label,
            self.morningEarliestAttendance9Label,
            self.morningEarliestAttendance10Label,
            self.morningEarliestAttendanceTimeBarView,
            self.morningLatestAttendanceMarkLabel,
            self.morningLatestAttendance8Label,
            self.morningLatestAttendance9Label,
            self.morningLatestAttendance10Label,
            self.morningLatestAttendance11Label,
            self.morningLatestAttendanceTimeBarView
        ], to: self.morningTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.morningEarliestAttendanceTimeBarFirstPointView,
            self.morningEarliestAttendanceTimeBarFirstHalfPointView,
            self.morningEarliestAttendanceTimeBarSecondPointView,
            self.morningEarliestAttendanceTimeBarSecondHalfPointView,
            self.morningEarliestAttendanceTimeBarThirdPointView,
            self.morningEarliestAttendanceTimeBarThirdHalfPointView,
            self.morningEarliestAttendanceTimeBarFourthPointView,
            self.morningEarliestAttendanceTimeBarMarkingView
        ], to: self.morningEarliestAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.morningLatestAttendanceTimeBarFirstPointView,
            self.morningLatestAttendanceTimeBarFirstHalfPointView,
            self.morningLatestAttendanceTimeBarSecondPointView,
            self.morningLatestAttendanceTimeBarSecondHalfPointView,
            self.morningLatestAttendanceTimeBarThirdPointView,
            self.morningLatestAttendanceTimeBarThirdHalfPointView,
            self.morningLatestAttendanceTimeBarFourthPointView,
            self.morningLatestAttendanceTimeBarMarkingView
        ], to: self.morningLatestAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.lunchTimeMarkLabel,
            self.lunchTime11Label,
            self.lunchTime12Label,
            self.lunchTime13Label,
            self.lunchTime14Label,
            self.lunchTime15Label,
            self.lunchTimeTimeBarView,
            self.ignoringLunchTimeButton,
            self.ignoringLunchTimeMarkLabel
        ], to: self.lunchTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.lunchTimeTimeBarFirstPointView,
            self.lunchTimeTimeBarFirstHalfPointView,
            self.lunchTimeTimeBarSecondPointView,
            self.lunchTimeTimeBarSecondHalfPointView,
            self.lunchTimeTimeBarThirdPointView,
            self.lunchTimeTimeBarThirdHalfPointView,
            self.lunchTimeTimeBarFourthPointView,
            self.lunchTimeAreaView,
            self.lunchTimeTimeBarMarkingView
        ], to: self.lunchTimeTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.afternoonEarliestAttendanceMarkLabel,
            self.afternoonEarliestAttendance11Label,
            self.afternoonEarliestAttendance12Label,
            self.afternoonEarliestAttendance13Label,
            self.afternoonEarliestAttendance14Label,
            self.afternoonEarliestAttendance15Label,
            self.afternoonEarliestAttendanceTimeBarView,
            self.afternoonLatestAttendanceMarkLabel,
            self.afternoonLatestAttendance12Label,
            self.afternoonLatestAttendance13Label,
            self.afternoonLatestAttendance14Label,
            self.afternoonLatestAttendance15Label,
            self.afternoonLatestAttendance16Label,
            self.afternoonLatestAttendanceTimeBarView
        ], to: self.afternoonTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.afternoonEarliestAttendanceTimeBarFirstPointView,
            self.afternoonEarliestAttendanceTimeBarFirstHalfPointView,
            self.afternoonEarliestAttendanceTimeBarSecondPointView,
            self.afternoonEarliestAttendanceTimeBarSecondHalfPointView,
            self.afternoonEarliestAttendanceTimeBarThirdPointView,
            self.afternoonEarliestAttendanceTimeBarThirdHalfPointView,
            self.afternoonEarliestAttendanceTimeBarFourthPointView,
            self.afternoonEarliestAttendanceTimeBarFourthHalfPointView,
            self.afternoonEarliestAttendanceTimeBarFifthPointView,
            self.afternoonEarliestAttendanceAreaView,
            self.afternoonEarliestAttendanceTimeBarMarkingView
        ], to: self.afternoonEarliestAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.afternoonLatestAttendanceTimeBarFirstPointView,
            self.afternoonLatestAttendanceTimeBarFirstHalfPointView,
            self.afternoonLatestAttendanceTimeBarSecondPointView,
            self.afternoonLatestAttendanceTimeBarSecondHalfPointView,
            self.afternoonLatestAttendanceTimeBarThirdPointView,
            self.afternoonLatestAttendanceTimeBarThirdHalfPointView,
            self.afternoonLatestAttendanceTimeBarFourthPointView,
            self.afternoonLatestAttendanceTimeBarFourthHalfPointView,
            self.afternoonLatestAttendanceTimeBarFifthPointView,
            self.afternoonLatestAttendanceAreaView,
            self.afternoonLatestAttendanceTimeBarMarkingView
        ], to: self.afternoonLatestAttendanceTimeBarView)
        
        
        SupportingMethods.shared.addSubviews([
            self.nextButtonImageView,
            self.nextButton
        ], to: self.nextButtonView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Content view layout
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: self.scrollView.contentSize.height),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
        
        // Dismiss button layout
        NSLayoutConstraint.activate([
            self.dismissButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.dismissButton.heightAnchor.constraint(equalToConstant: 44),
            self.dismissButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            self.dismissButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        // Title label layout
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 44),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 55),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 191)
        ])
        
        // Staggered type button layout
        NSLayoutConstraint.activate([
            self.staggeredTypeButton.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 32),
            self.staggeredTypeButton.heightAnchor.constraint(equalToConstant: 92),
            self.staggeredTypeButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -25),
            self.staggeredTypeButton.widthAnchor.constraint(equalToConstant: 92)
        ])
        
        // Normal type button layout
        NSLayoutConstraint.activate([
            self.normalTypeButton.topAnchor.constraint(equalTo: self.staggeredTypeButton.topAnchor),
            self.normalTypeButton.heightAnchor.constraint(equalToConstant: 92),
            self.normalTypeButton.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 25),
            self.normalTypeButton.widthAnchor.constraint(equalToConstant: 92)
        ])
        
        // Moment label layout
        NSLayoutConstraint.activate([
            self.momentLabel.topAnchor.constraint(equalTo: self.staggeredTypeButton.bottomAnchor, constant: 16),
            self.momentLabel.heightAnchor.constraint(equalToConstant: 38),
            self.momentLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.momentLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 110)
        ])
        
        // Morning label layout
        NSLayoutConstraint.activate([
            self.morningLabel.bottomAnchor.constraint(equalTo: self.morningTimeView.topAnchor, constant: -5),
            self.morningLabel.centerXAnchor.constraint(equalTo: self.morningTimeView.centerXAnchor),
        ])
        
        // MARK: Morning time view layout
        NSLayoutConstraint.activate([
            self.morningTimeView.topAnchor.constraint(equalTo: self.staggeredTypeButton.bottomAnchor, constant: 91),
            self.morningTimeView.heightAnchor.constraint(equalToConstant: 90),
            self.morningTimeView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.morningTimeView.widthAnchor.constraint(equalToConstant: 276)
        ])
        
        // Morning earliest attendance mark label layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceMarkLabel.topAnchor.constraint(equalTo: self.morningTimeView.topAnchor, constant: 10),
            self.morningEarliestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.morningEarliestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.morningEarliestAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Morning earliest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceMarkLabel.centerYAnchor),
            self.morningEarliestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.morningEarliestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor),
            self.morningEarliestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Morning earliest attendance 7 label layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendance7Label.bottomAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.topAnchor),
            self.morningEarliestAttendance7Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningEarliestAttendance7Label.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Morning earliest attendance 8 label layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendance8Label.bottomAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.topAnchor),
            self.morningEarliestAttendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningEarliestAttendance8Label.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Morning earliest attendance 9 label layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendance9Label.bottomAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.topAnchor),
            self.morningEarliestAttendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningEarliestAttendance9Label.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Morning earliest attendance 10 label layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendance10Label.bottomAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.topAnchor),
            self.morningEarliestAttendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningEarliestAttendance10Label.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Morning earliest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningEarliestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.morningEarliestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning earliest attendance time bar first half point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningEarliestAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.morningEarliestAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning earliest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningEarliestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.morningEarliestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning earliest attendance time bar second half point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningEarliestAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.morningEarliestAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning earliest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningEarliestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.morningEarliestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning earliest attendance time bar third half point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningEarliestAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.morningEarliestAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning earliest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningEarliestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.morningEarliestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning earliest attendance time bar marking view layout
        self.morningEarliestAttendaceTimeBarMarkingViewConstraint = self.morningEarliestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.leadingAnchor, constant: 12 + 46.5)
        NSLayoutConstraint.activate([
            self.morningEarliestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.morningEarliestAttendanceTimeBarView.centerYAnchor),
            self.morningEarliestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.morningEarliestAttendaceTimeBarMarkingViewConstraint,
            self.morningEarliestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Morning latest attendance mark label layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceMarkLabel.bottomAnchor.constraint(equalTo: self.morningTimeView.bottomAnchor),
            self.morningLatestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.morningLatestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.morningLatestAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Morning latest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceMarkLabel.centerYAnchor),
            self.morningLatestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.morningLatestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor),
            self.morningLatestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Morning latest attendance 8 label layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendance8Label.bottomAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.topAnchor),
            self.morningLatestAttendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningLatestAttendance8Label.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Morning latest attendance 9 label layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendance9Label.bottomAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.topAnchor),
            self.morningLatestAttendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningLatestAttendance9Label.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Morning latest attendance 10 label layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendance10Label.bottomAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.topAnchor),
            self.morningLatestAttendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningLatestAttendance10Label.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Morning latest attendance 11 label layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendance11Label.bottomAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.topAnchor),
            self.morningLatestAttendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningLatestAttendance11Label.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Morning latest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningLatestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.leadingAnchor, constant: 12 + 46.5),
            self.morningLatestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning latest attendance time bar first half point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningLatestAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.morningLatestAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning latest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningLatestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.morningLatestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning latest attendance time bar second half point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningLatestAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.morningLatestAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning latest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningLatestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.morningLatestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning latest attendance time bar third half point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningLatestAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.morningLatestAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Morning latest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningLatestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.morningLatestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Morning latest attendance time bar marking view layout
        self.morningLatestAttendaceTimeBarMarkingViewConstraint = self.morningLatestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.leadingAnchor, constant: 12 + 139.5) // 12 + 46.5 + 46.5 + 46.5
        NSLayoutConstraint.activate([
            self.morningLatestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.morningLatestAttendanceTimeBarView.centerYAnchor),
            self.morningLatestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.morningLatestAttendaceTimeBarMarkingViewConstraint,
            self.morningLatestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // MARK: Lunch time view layout
        NSLayoutConstraint.activate([
            self.lunchTimeView.topAnchor.constraint(equalTo: self.morningTimeView.bottomAnchor, constant: 32),
            self.lunchTimeView.heightAnchor.constraint(equalToConstant: 65),
            self.lunchTimeView.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.lunchTimeView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor)
        ])
        
        // Lunch time mark label layout
        NSLayoutConstraint.activate([
            self.lunchTimeMarkLabel.topAnchor.constraint(equalTo: self.lunchTimeView.topAnchor, constant: 10),
            self.lunchTimeMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.lunchTimeMarkLabel.leadingAnchor.constraint(equalTo: self.lunchTimeView.leadingAnchor),
            self.lunchTimeMarkLabel.trailingAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Lunch time time bar view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarView.centerYAnchor.constraint(equalTo: self.lunchTimeMarkLabel.centerYAnchor),
            self.lunchTimeTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.lunchTimeTimeBarView.trailingAnchor.constraint(equalTo: self.lunchTimeView.trailingAnchor),
            self.lunchTimeTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Lunch time 11 label layout
        NSLayoutConstraint.activate([
            self.lunchTime11Label.bottomAnchor.constraint(equalTo: self.lunchTimeTimeBarView.topAnchor),
            self.lunchTime11Label.heightAnchor.constraint(equalToConstant: 10),
            self.lunchTime11Label.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Lunch time 12 label layout
        NSLayoutConstraint.activate([
            self.lunchTime12Label.bottomAnchor.constraint(equalTo: self.lunchTimeTimeBarView.topAnchor),
            self.lunchTime12Label.heightAnchor.constraint(equalToConstant: 10),
            self.lunchTime12Label.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Lunch time 13 label layout
        NSLayoutConstraint.activate([
            self.lunchTime13Label.bottomAnchor.constraint(equalTo: self.lunchTimeTimeBarView.topAnchor),
            self.lunchTime13Label.heightAnchor.constraint(equalToConstant: 10),
            self.lunchTime13Label.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Lunch time 14 label layout
        NSLayoutConstraint.activate([
            self.lunchTime14Label.bottomAnchor.constraint(equalTo: self.lunchTimeTimeBarView.topAnchor),
            self.lunchTime14Label.heightAnchor.constraint(equalToConstant: 10),
            self.lunchTime14Label.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Lunch time 15 label layout
        NSLayoutConstraint.activate([
            self.lunchTime15Label.bottomAnchor.constraint(equalTo: self.lunchTimeTimeBarView.topAnchor),
            self.lunchTime15Label.heightAnchor.constraint(equalToConstant: 10),
            self.lunchTime15Label.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarFourthPointView.centerXAnchor, constant: 46.5)
        ])
        
        // Lunch time time bar first point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.lunchTimeTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: 12),
            self.lunchTimeTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Lunch time time bar first half point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.lunchTimeTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.lunchTimeTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Lunch time time bar second point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.lunchTimeTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.lunchTimeTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Lunch time time bar second half point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.lunchTimeTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.lunchTimeTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Lunch time time bar third point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.lunchTimeTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.lunchTimeTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Lunch time time bar third half point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.lunchTimeTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.lunchTimeTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Lunch time time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.lunchTimeTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.lunchTimeTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Lunch time area view layout
        self.lunchTimeAreaCenterXAnchorConstraint = self.lunchTimeAreaView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: 12 + 46.5 + 23.25)
        NSLayoutConstraint.activate([
            self.lunchTimeAreaView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeAreaView.heightAnchor.constraint(equalToConstant: 24),
            self.lunchTimeAreaCenterXAnchorConstraint,
            self.lunchTimeAreaView.widthAnchor.constraint(equalToConstant: 46.5)
        ])
        
        // Lunch time time bar marking view layout
        self.lunchTimeTimeBarMarkingViewConstraint = self.lunchTimeTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: 12 + 46.5)
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.lunchTimeTimeBarMarkingViewConstraint,
            self.lunchTimeTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Ignoring lunch time button layout
        NSLayoutConstraint.activate([
            self.ignoringLunchTimeButton.topAnchor.constraint(equalTo: self.lunchTimeTimeBarView.bottomAnchor, constant: 10),
            self.ignoringLunchTimeButton.heightAnchor.constraint(equalToConstant: 18),
            self.ignoringLunchTimeButton.leadingAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor),
            self.ignoringLunchTimeButton.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Ignoring lunch time mark label layout
        NSLayoutConstraint.activate([
            self.ignoringLunchTimeMarkLabel.centerYAnchor.constraint(equalTo: self.ignoringLunchTimeButton.centerYAnchor),
            self.ignoringLunchTimeMarkLabel.leadingAnchor.constraint(equalTo: self.ignoringLunchTimeButton.trailingAnchor, constant: 5),
            self.ignoringLunchTimeMarkLabel.widthAnchor.constraint(equalToConstant: 123)
        ])
        
        // Morning label layout
        NSLayoutConstraint.activate([
            self.afternoonLabel.bottomAnchor.constraint(equalTo: self.afternoonTimeView.topAnchor, constant: -5),
            self.afternoonLabel.centerXAnchor.constraint(equalTo: self.afternoonTimeView.centerXAnchor)
        ])
        
        // MARK: Afternoon time view layout
        NSLayoutConstraint.activate([
            self.afternoonTimeView.topAnchor.constraint(equalTo: self.lunchTimeView.bottomAnchor, constant: 53),
            self.afternoonTimeView.heightAnchor.constraint(equalToConstant: 90),
            self.afternoonTimeView.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.afternoonTimeView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor)
        ])
        
        // Afternoon earliest attendance mark label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceMarkLabel.topAnchor.constraint(equalTo: self.afternoonTimeView.topAnchor, constant: 10),
            self.afternoonEarliestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonEarliestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.afternoonTimeView.leadingAnchor),
            self.afternoonEarliestAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Afternoon earliest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceMarkLabel.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonEarliestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.afternoonTimeView.trailingAnchor),
            self.afternoonEarliestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Afternoon earliest attendance 11 label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendance11Label.bottomAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.topAnchor),
            self.afternoonEarliestAttendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonEarliestAttendance11Label.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Afternoon earliest attendance 12 label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendance12Label.bottomAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.topAnchor),
            self.afternoonEarliestAttendance12Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonEarliestAttendance12Label.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Afternoon earliest attendance 13 label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendance13Label.bottomAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.topAnchor),
            self.afternoonEarliestAttendance13Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonEarliestAttendance13Label.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Afternoon earliest attendance 14 label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendance14Label.bottomAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.topAnchor),
            self.afternoonEarliestAttendance14Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonEarliestAttendance14Label.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Afternoon earliest attendance 15 label layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendance15Label.bottomAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.topAnchor),
            self.afternoonEarliestAttendance15Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonEarliestAttendance15Label.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFifthPointView.centerXAnchor)
        ])
        
        // Afternoon earliest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonEarliestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.afternoonEarliestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance time bar first half point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonEarliestAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.afternoonEarliestAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon earliest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonEarliestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.afternoonEarliestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance time bar second half point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonEarliestAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.afternoonEarliestAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon earliest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonEarliestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.afternoonEarliestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance time bar third half point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonEarliestAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.afternoonEarliestAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon earliest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonEarliestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.afternoonEarliestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance time bar fourth half point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarFourthHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarFourthHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonEarliestAttendanceTimeBarFourthHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFourthPointView.centerXAnchor, constant: 23.25),
            self.afternoonEarliestAttendanceTimeBarFourthHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon earliest attendance time bar fifth point view layout
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarFifthPointView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarFifthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonEarliestAttendanceTimeBarFifthPointView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarFourthPointView.centerXAnchor, constant: 46.5),
            self.afternoonEarliestAttendanceTimeBarFifthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance area view layout
        self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint = self.afternoonEarliestAttendanceAreaView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.leadingAnchor, constant: 12 + 46.5 + 23.25)
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceAreaView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceAreaView.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint,
            self.afternoonEarliestAttendanceAreaView.widthAnchor.constraint(equalToConstant: 46.5)
        ])
        
        // Afternoon earliest attendance time bar marking view layout
        self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint = self.afternoonEarliestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.leadingAnchor, constant: 12 + 23.25)
        NSLayoutConstraint.activate([
            self.afternoonEarliestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.afternoonEarliestAttendanceTimeBarView.centerYAnchor),
            self.afternoonEarliestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint,
            self.afternoonEarliestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Afternoon latest attendance mark label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceMarkLabel.bottomAnchor.constraint(equalTo: self.afternoonTimeView.bottomAnchor),
            self.afternoonLatestAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonLatestAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.afternoonTimeView.leadingAnchor),
            self.afternoonLatestAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Afternoon latest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceMarkLabel.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonLatestAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.afternoonTimeView.trailingAnchor),
            self.afternoonLatestAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Afternoon latest attendance 12 label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendance12Label.bottomAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.topAnchor),
            self.afternoonLatestAttendance12Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonLatestAttendance12Label.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Afternoon latest attendance 13 label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendance13Label.bottomAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.topAnchor),
            self.afternoonLatestAttendance13Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonLatestAttendance13Label.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Afternoon latest attendance 14 label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendance14Label.bottomAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.topAnchor),
            self.afternoonLatestAttendance14Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonLatestAttendance14Label.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Afternoon latest attendance 15 label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendance15Label.bottomAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.topAnchor),
            self.afternoonLatestAttendance15Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonLatestAttendance15Label.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Afternoon latest attendance 16 label layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendance16Label.bottomAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.topAnchor),
            self.afternoonLatestAttendance16Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonLatestAttendance16Label.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFifthPointView.centerXAnchor)
        ])
        
        ////
        // Afternoon latest attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonLatestAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.afternoonLatestAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon earliest attendance time bar first half point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonLatestAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.afternoonLatestAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon latest attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonLatestAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.afternoonLatestAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon latest attendance time bar second half point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonLatestAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.afternoonLatestAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon latest attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonLatestAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.afternoonLatestAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon latest attendance time bar third half point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonLatestAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.afternoonLatestAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon latest attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonLatestAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.afternoonLatestAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon latest attendance time bar fourth half point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarFourthHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarFourthHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonLatestAttendanceTimeBarFourthHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFourthPointView.centerXAnchor, constant: 23.25),
            self.afternoonLatestAttendanceTimeBarFourthHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Afternoon latest attendance time bar fifth point view layout
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarFifthPointView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarFifthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonLatestAttendanceTimeBarFifthPointView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarFourthPointView.centerXAnchor, constant: 46.5),
            self.afternoonLatestAttendanceTimeBarFifthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Afternoon latest attendace area area view layout
        self.afternoonLatestAttendaceAreaCenterXAnchorConstraint = self.afternoonLatestAttendanceAreaView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.leadingAnchor, constant: 12 + 23.25)
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceAreaView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceAreaView.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonLatestAttendaceAreaCenterXAnchorConstraint,
            self.afternoonLatestAttendanceAreaView.widthAnchor.constraint(equalToConstant: 46.5)
        ])
        
        // Afternoon latest attendance time bar marking view layout
        self.afternoonLatestAttendaceTimeBarMarkingViewConstraint = self.afternoonLatestAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.leadingAnchor, constant: 12 + 93) // 12 + 46.5 + 46.5 + 46.5
        NSLayoutConstraint.activate([
            self.afternoonLatestAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.afternoonLatestAttendanceTimeBarView.centerYAnchor),
            self.afternoonLatestAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.afternoonLatestAttendaceTimeBarMarkingViewConstraint,
            self.afternoonLatestAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Next button view layout
        NSLayoutConstraint.activate([
            self.nextButtonView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.nextButtonView.heightAnchor.constraint(equalToConstant: UIWindow().safeAreaInsets.bottom + 60),
            self.nextButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.nextButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        // Next button label layout
        NSLayoutConstraint.activate([
            self.nextButtonImageView.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor, constant: 20.5),
            self.nextButtonImageView.heightAnchor.constraint(equalToConstant: 19),
            self.nextButtonImageView.centerXAnchor.constraint(equalTo: self.nextButtonView.centerXAnchor),
            self.nextButtonImageView.widthAnchor.constraint(equalToConstant: 27)
        ])
        
        // Next button layout
        NSLayoutConstraint.activate([
            self.nextButton.topAnchor.constraint(equalTo: self.nextButtonView.topAnchor),
            self.nextButton.bottomAnchor.constraint(equalTo: self.nextButtonView.bottomAnchor),
            self.nextButton.leadingAnchor.constraint(equalTo: self.nextButtonView.leadingAnchor),
            self.nextButton.trailingAnchor.constraint(equalTo: self.nextButtonView.trailingAnchor)
        ])
    }
}

// MARK: - Extension for methods added
extension StaggeredWorkTypeViewController {
    func locateMarkingBarViewFor(_ type: StaggeredMarkingViewType) {
        switch type {
        case .morningEarliest(let point): // MARK: morningEarliest
            if point.x <= 23.625 { // 12 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 12 // (07:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (07:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (08:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (08:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (09:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (09:30)
                
            } else { // > 10 + 23.25*5 + 23.25/2
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (10:00)
            }
            
            if self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant <= self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant {
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant + 23.25
            }
            
            UIView.animate(withDuration: 0.2) {
                self.morningEarliestAttendanceTimeBarView.layoutIfNeeded()
                self.morningLatestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.morningEarliestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.morningLatestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                }
            }
            
            self.showMomentLabelFor(.morningEarliest(CGPoint(x:self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant, y:point.y)), withAnimation: true)
            
        case .morningLatest(let point): // MARK: morningLatest
            if point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (08:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (08:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (09:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (09:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (10:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 174.75 // 12 + 23.25*7 (10:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = 198 // 12 + 23.25*8 (11:00)
            }
            
            if self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant >= self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant {
                self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
            }
            
            UIView.animate(withDuration: 0.2) {
                self.morningLatestAttendanceTimeBarView.layoutIfNeeded()
                self.morningEarliestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.morningLatestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.morningEarliestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                }
            }
            
            self.showMomentLabelFor(.morningLatest(CGPoint(x:self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant, y:point.y)), withAnimation: true)
            
        case .lunchTime(let point): // MARK: lunchTime
            if point.x <= 23.625 { // 12 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 12 // (11:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (11:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (12:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (12:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (13:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (13:30)
                
            } else { // > 10 + 23.25*5 + 23.25/2
                self.lunchTimeTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (14:00)
            }
            
            self.determineLunchTimeArea(self.lunchTimeTimeBarMarkingViewConstraint.constant)
            
            UIView.animate(withDuration: 0.2) {
                self.lunchTimeTimeBarView.layoutIfNeeded()
                self.afternoonEarliestAttendanceTimeBarView.layoutIfNeeded()
                self.afternoonLatestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.lunchTimeTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                    
                    self.previousAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant
                    self.previousAfternoonLatestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant
                }
            }
            
            self.showMomentLabelFor(.lunchTime(CGPoint(x:self.lunchTimeTimeBarMarkingViewConstraint.constant, y:point.y)), withAnimation: true)
            
        case .afternoonEarliest(let point): // MARK: afternoonEarliest
            let aheadOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            let endOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 12 // (11:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (11:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (12:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (12:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (13:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (13:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (14:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 174.75 // 12 + 23.25*7 (14:30)
                
            } else { // > 10 + 23.25*7 + 23.25/2
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = 198 // 12 + 23.25*8 (15:00)
            }
            
            if self.ignoringLunchTimeButton.isSelected {
                if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                    self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
                }
                
            } else {
                // After afternoonEarliest pan gesture
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.determinePointOfMovedMarkingViewCenterPoint(self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant, outOf: [aheadOfAfternoonEarliestAttendaceArea, endOfAfternoonEarliestAttendaceArea], about: self.previousAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant)!
                
                // After afternoonEarliest tap gesture
                if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                    
                    let tempAfternoonLatestAttendaceAreaCenterXAnchorConstraintConstant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
                    
                    if tempAfternoonLatestAttendaceAreaCenterXAnchorConstraintConstant >= self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25 &&
                        tempAfternoonLatestAttendaceAreaCenterXAnchorConstraintConstant < self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25 {
                        
                        self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
                        
                    } else {
                        self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
                    }
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.afternoonEarliestAttendanceTimeBarView.layoutIfNeeded()
                self.afternoonLatestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.afternoonEarliestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                    
                    self.previousAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant
                }
            }
            
            self.showMomentLabelFor(.afternoonEarliest(CGPoint(x:self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant, y:point.y)), withAnimation: true)
            
        case .afternoonLatest(let point): // MARK: afternoonLatest
            let aheadOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            let endOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 12 // (12:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (12:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (13:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (13:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (14:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (14:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (15:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 174.75 // 12 + 23.25*7 (15:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = 198 // 12 + 23.25*8 (16:00)
            }
            
            if self.ignoringLunchTimeButton.isSelected {
                if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                    self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant + 23.25
                }
                    
            } else {
                // After afternoonLatest pan gesture
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.determinePointOfMovedMarkingViewCenterPoint(self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant, outOf: [aheadOfAfternoonLatestAttendaceArea, endOfAfternoonLatestAttendaceArea], about: self.previousAfternoonLatestAttendaceTimeBarMarkingViewConstraintConstant)!
                
                // After afternoonLatest tap gesture
                if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                    
                    let tempAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant + 23.25
                    
                    if tempAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant < self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant + 23.25 &&
                        tempAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant >= self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25 {
                        
                        if self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25*2 < 12 {
                            self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant += 23.25
                            self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant + 23.25
                            
                        } else {
                            self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25*2
                        }
                        
                    } else {
                        self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant + 23.25
                    }
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.afternoonLatestAttendanceTimeBarView.layoutIfNeeded()
                self.afternoonEarliestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.afternoonLatestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                    
                    self.previousAfternoonLatestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant
                }
            }
            
            self.showMomentLabelFor(.afternoonLatest(CGPoint(x:self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant, y:point.y)), withAnimation: true)
        }
        
        UIDevice.softHaptic()
    }
    
    func moveMarkingBarViewTo(_ type: StaggeredMarkingViewType) {
        switch type {
        case .morningEarliest(let point):
            self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 151.5 ?
            151.5 : point.x
            
        case .morningLatest(let point):
            self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 + 46.5 ?
            12 + 46.5 : point.x > 198 ?
            198 : point.x
            
        case .lunchTime(let point):
            self.lunchTimeTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 151.5 ?
            151.5 : point.x
            
        case .afternoonEarliest(let point):
            self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 198 ?
            198 : point.x
            
        case .afternoonLatest(let point):
            self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 198 ?
            198 : point.x
        }
    }
    
    func determineLunchTimeArea(_ at: CGFloat) {
        self.lunchTimeAreaCenterXAnchorConstraint.constant = at + 23.25
        
        if self.ignoringLunchTimeButton.isSelected {
            self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant = at + 23.25
            self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant = at + 23.25 - 46.5
            
        } else {
            let previousAfternoonEarliestAttendanceBarMarkingCenterXPoint = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant
            var previousAfternoonLatestAttendanceBarMarkingCenterXPoint = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant
            let previousAtLunchTimePointOfAfternoonEarliestAttendaceArea = afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            let previousAtLunchTimePointOfAfternoonLatestAttendaceArea = afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            
            self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant = at + 23.25
            self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant = at + 23.25 - 46.5
            
            let currentAfternoonEarliestAttendaceAreaPoints = [
                afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25,
                afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
                ]
                                                                
            let currentAfternoonLatestAttendaceAreaPoints = [
                afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25,
                afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
                ]
            
            self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant =
            self.determinePointOfStandingMarkingViewCenterPoint(previousAfternoonEarliestAttendanceBarMarkingCenterXPoint, outOf: currentAfternoonEarliestAttendaceAreaPoints, in: [12,198], from: previousAtLunchTimePointOfAfternoonEarliestAttendaceArea)!
            
            if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                previousAfternoonLatestAttendanceBarMarkingCenterXPoint = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
            }
            
            self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.determinePointOfStandingMarkingViewCenterPoint(previousAfternoonLatestAttendanceBarMarkingCenterXPoint, outOf: currentAfternoonLatestAttendaceAreaPoints, in: [12,198], from: previousAtLunchTimePointOfAfternoonLatestAttendaceArea)!
        }
    }
    
    func determinePointOfStandingMarkingViewCenterPoint(_ markingViewCenterPoint: CGFloat, outOf lunchTimeAreaViewPoints: [CGFloat], in barViewPoints: [CGFloat], from previousAtLunchPoint: CGFloat) -> CGFloat? {
        guard lunchTimeAreaViewPoints.count == 2 && barViewPoints.count == 2 else {
            return nil
        }
        
        if markingViewCenterPoint >= lunchTimeAreaViewPoints[0] &&
            markingViewCenterPoint < lunchTimeAreaViewPoints[1] {
            if markingViewCenterPoint <= previousAtLunchPoint { // right -> left
                if lunchTimeAreaViewPoints[0] <= barViewPoints[0] {
                    if lunchTimeAreaViewPoints[1] < barViewPoints[0] {
                        return barViewPoints[0]
                        
                    } else { // lunchTimeAreaViewPoints[1] >= barViewPoints[0]
                        return lunchTimeAreaViewPoints[1]
                    }
                    
                } else { // lunchTimeAreaViewPoints[0] > barViewPoints[0]
                    return lunchTimeAreaViewPoints[0] - 23.25
                }
                
            } else { // left -> right
                if lunchTimeAreaViewPoints[1] <= barViewPoints[1] {
                    return lunchTimeAreaViewPoints[1]
                    
                } else { // lunchTimeAreaViewPoints[1] > barViewPoints[1]
                    if lunchTimeAreaViewPoints[0] > barViewPoints[1] {
                        return barViewPoints[1]
                        
                    } else { // lunchTimeAreaViewPoints[0] <= barViewPoints[1]
                        return lunchTimeAreaViewPoints[0] - 23.25
                    }
                    
                }
            }
            
        } else {
            return markingViewCenterPoint
        }
    }
    
    func determinePointOfMovedMarkingViewCenterPoint(_ markingViewCenterPoint: CGFloat, outOf lunchTimeAreaViewPoints: [CGFloat], about previousMarkingViewCenterPoint: CGFloat) -> CGFloat? {
        guard lunchTimeAreaViewPoints.count == 2 else {
            return nil
        }
        
        if markingViewCenterPoint >= lunchTimeAreaViewPoints[0] && markingViewCenterPoint < lunchTimeAreaViewPoints[1] {
            return previousMarkingViewCenterPoint
            
        } else {
            return markingViewCenterPoint
        }
    }
    
    func showMomentLabelFor(_ type: StaggeredMarkingViewType, withAnimation animation: Bool) {
        self.momentLabel.layer.removeAllAnimations()
        
        switch type {
        case .morningEarliest(let point):
            self.momentLabel.backgroundColor = .useRGB(red: 167, green: 255, blue: 254, alpha: 0.5)
            self.momentLabel.alpha = 1
            self.momentLabel.isHidden = false
            
            if animation {
                UIView.animate(withDuration: 1.0) {
                    self.momentLabel.alpha = 0
                    
                } completion: { finished in
                    if finished {
                        self.momentLabel.isHidden = true
                        self.momentLabel.alpha = 1
                    }
                }
            }
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.momentLabel.text = "07:00" // (07:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.momentLabel.text = "07:30" // (07:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.momentLabel.text = "08:00" // (08:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.momentLabel.text = "08:30" // (08:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.momentLabel.text = "09:00" // (09:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.momentLabel.text = "09:30" // (09:30)
                
            } else { // > 10 + 23.25*5 + 23.25/2
                self.momentLabel.text = "10:00" // (10:00)
            }
            
        case .morningLatest(let point):
            self.momentLabel.backgroundColor = .useRGB(red: 167, green: 255, blue: 254, alpha: 0.5)
            self.momentLabel.alpha = 1
            self.momentLabel.isHidden = false
            
            if animation {
                UIView.animate(withDuration: 1.0) {
                    self.momentLabel.alpha = 0
                    
                } completion: { finished in
                    if finished {
                        self.momentLabel.isHidden = true
                        self.momentLabel.alpha = 1
                    }
                }
            }
            
            if point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.momentLabel.text = "08:00" // (08:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.momentLabel.text = "08:30" // (08:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.momentLabel.text = "09:00" // (09:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.momentLabel.text = "09:30" // (09:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.momentLabel.text = "10:00" // (10:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "10:30" // (10:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "11:00" // (11:00)
            }
            
        case .lunchTime(let point):
            self.momentLabel.backgroundColor = .useRGB(red: 255, green: 245, blue: 156, alpha: 0.5)
            self.momentLabel.alpha = 1
            self.momentLabel.isHidden = false
            
            if animation {
                UIView.animate(withDuration: 1.0) {
                    self.momentLabel.alpha = 0
                    
                } completion: { finished in
                    if finished {
                        self.momentLabel.isHidden = true
                        self.momentLabel.alpha = 1
                    }
                }
            }
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.momentLabel.text = "11:00" // (11:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.momentLabel.text = "11:30" // (11:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.momentLabel.text = "12:00" // (12:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.momentLabel.text = "12:30" // (12:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.momentLabel.text = "13:00" // (13:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.momentLabel.text = "13:30" // (13:30)
                
            } else { // > 10 + 23.25*5 + 23.25/2
                self.momentLabel.text = "14:00" // (14:00)
            }
            
        case .afternoonEarliest(let point):
            self.momentLabel.backgroundColor = .useRGB(red: 176, green: 255, blue: 186, alpha: 0.5)
            self.momentLabel.alpha = 1
            self.momentLabel.isHidden = false
            
            if animation {
                UIView.animate(withDuration: 1.0) {
                    self.momentLabel.alpha = 0
                    
                } completion: { finished in
                    if finished {
                        self.momentLabel.isHidden = true
                        self.momentLabel.alpha = 1
                    }
                }
            }
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.momentLabel.text = "11:00" // (11:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.momentLabel.text = "11:30" // (11:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.momentLabel.text = "12:00" // (12:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.momentLabel.text = "12:30" // (12:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.momentLabel.text = "13:00" // (13:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.momentLabel.text = "13:30" // (13:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.momentLabel.text = "14:00" // (14:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "14:30" // (14:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "15:00" // (15:00)
            }
            
        case .afternoonLatest(let point):
            self.momentLabel.backgroundColor = .useRGB(red: 176, green: 255, blue: 186, alpha: 0.5)
            self.momentLabel.alpha = 1
            self.momentLabel.isHidden = false
            
            if animation {
                UIView.animate(withDuration: 1.0) {
                    self.momentLabel.alpha = 0
                    
                } completion: { finished in
                    if finished {
                        self.momentLabel.isHidden = true
                        self.momentLabel.alpha = 1
                    }
                }
            }
            
            if point.x <= 23.625 { // 12 + 23.25/2
                self.momentLabel.text = "12:00" // (12:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.momentLabel.text = "12:30" // (12:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.momentLabel.text = "13:00" // (13:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.momentLabel.text = "13:30" // (13:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.momentLabel.text = "14:00" // (14:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.momentLabel.text = "14:30" // (14:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.momentLabel.text = "15:00" // (15:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "15:30" // (15:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.momentLabel.text = "16:00" // (16:00)
            }
        }
    }
    
    func determineMorningAttendanceTimeValue() -> (earliestTime: Double, latestTime: Double)? {
        guard let earliestTime = self.getMorningAttendaceTimeValue(self.morningEarliestAttendaceTimeBarMarkingViewConstraint.constant),
           let latestTime = self.getMorningAttendaceTimeValue(self.morningLatestAttendaceTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return (earliestTime, latestTime)
    }
    
    func determineLunchTimeValue() -> Double? {
        guard let lunchTime = self.getLunchTimeValue(self.lunchTimeTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return lunchTime
    }
    
    func determineAfternoonAttendanceTimeValue() -> (earliestTime: Double, latestTime: Double)? {
        guard let earliestTime = self.getAfternoonEarliestAttendaceTimeValue(self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant),
           let latestTime = self.getAfternoonLatestAttendaceTimeValue(self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return (earliestTime, latestTime)
    }
    
    func getMorningAttendaceTimeValue(_ from: CGFloat) -> Double? {
        switch from {
        case 12:
            return 7.0
            
        case 35.25:
            return 7.5
            
        case 58.5:
            return 8.0
            
        case 81.75:
            return 8.5
            
        case 105:
            return 9.0
            
        case 128.25:
            return 9.5
            
        case 151.5:
            return 10.0
            
        case 174.75:
            return 10.5
            
        case 198:
            return 11.0
            
        default:
            return nil
        }
    }
    
    func getLunchTimeValue(_ from: CGFloat) -> Double? {
        switch from {
        case 12:
            return 11.0
            
        case 35.25:
            return 11.5
            
        case 58.5:
            return 12.0
            
        case 81.75:
            return 12.5
            
        case 105:
            return 13.0
            
        case 128.25:
            return 13.5
            
        case 151.5:
            return 14.0
            
        default:
            return nil
        }
    }
    
    func getAfternoonEarliestAttendaceTimeValue(_ from: CGFloat) -> Double? {
        switch from {
        case 12:
            return 11.0
            
        case 35.25:
            return 11.5
            
        case 58.5:
            return 12.0
            
        case 81.75:
            return 12.5
            
        case 105:
            return 13.0
            
        case 128.25:
            return 13.5
            
        case 151.5:
            return 14.0
            
        case 174.75:
            return 14.5
            
        case 198:
            return 15.0
            
        default:
            return nil
        }
    }
    
    func getAfternoonLatestAttendaceTimeValue(_ from: CGFloat) -> Double? {
        switch from {
        case 12:
            return 12.0
            
        case 35.25:
            return 12.5
            
        case 58.5:
            return 13.0
            
        case 81.75:
            return 13.5
            
        case 105:
            return 14.0
            
        case 128.25:
            return 14.5
            
        case 151.5:
            return 15.0
            
        case 174.75:
            return 15.5
            
        case 198:
            return 16.0
            
        default:
            return nil
        }
    }
}

// MARK: - Extension for Selector methods
extension StaggeredWorkTypeViewController {
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func workTypeButtons(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.tabBarController?.selectedIndex = 1
        
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
    @objc func ignoringLunchTimeButton(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        sender.isSelected.toggle()
        
        if sender.isSelected {
            self.ignoringLunchTimeMarkLabel.textColor = .black
            
            self.afternoonEarliestAttendanceAreaView.isHidden = true
            self.afternoonLatestAttendanceAreaView.isHidden = true
            
        } else {
            self.ignoringLunchTimeMarkLabel.textColor = .useRGB(red: 221, green: 221, blue: 221)
            
            self.afternoonEarliestAttendanceAreaView.isHidden = false
            self.afternoonLatestAttendanceAreaView.isHidden = false
            
            // Prevent touching
            self.afternoonEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
            self.afternoonLatestAttendanceTimeBarView.isUserInteractionEnabled = false
            self.nextButton.isUserInteractionEnabled = false
            
            let aheadPointOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            let endOfPointOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            let aheadPointOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25
            let endOfPointOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant >= aheadPointOfAfternoonEarliestAttendaceArea && self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant < endOfPointOfAfternoonEarliestAttendaceArea {
                self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant = endOfPointOfAfternoonEarliestAttendaceArea
            }
            
            if self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant >= aheadPointOfAfternoonLatestAttendaceArea &&
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant < endOfPointOfAfternoonLatestAttendaceArea {
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = endOfPointOfAfternoonLatestAttendaceArea
            }
            
            if self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant > 23.25 {
                self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant - 23.25
            }
            
            UIView.animate(withDuration: 0.2) {
                self.afternoonEarliestAttendanceTimeBarView.layoutIfNeeded()
                self.afternoonLatestAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.afternoonEarliestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.afternoonLatestAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.nextButton.isUserInteractionEnabled = true
                    
                    self.previousAfternoonEarliestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonEarliestAttendaceTimeBarMarkingViewConstraint.constant
                    self.previousAfternoonLatestAttendaceTimeBarMarkingViewConstraintConstant = self.afternoonLatestAttendaceTimeBarMarkingViewConstraint.constant
                }
            }
        }
    }
    
    @objc func morningEarliestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("earliestAttendanceTimeBarView point: \(point)")
        
        self.morningEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
        self.morningLatestAttendanceTimeBarView.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.morningEarliest(point))
        //self.showMomentLabelFor(.morningEarliest(point), withAnimation: true)
    }
    
    @objc func morningEarliestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("earliestAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.morningLatestAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.morningEarliest(point))
            self.showMomentLabelFor(.morningEarliest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.morningEarliest(point))
            self.showMomentLabelFor(.morningEarliest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.showMomentLabelFor(.morningEarliest(point), withAnimation: false)
            self.locateMarkingBarViewFor(.morningEarliest(point))
        }
    }
    
    @objc func morningLatestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("latestAttendanceTimeBarView point: \(point)")
        
        self.morningLatestAttendanceTimeBarView.isUserInteractionEnabled = false
        self.morningEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.morningLatest(point))
        //self.showMomentLabelFor(.morningLatest(point), withAnimation: true)
    }
    
    @objc func morningLatestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("leavingAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.morningEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.morningLatest(point))
            self.showMomentLabelFor(.morningLatest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.morningLatest(point))
            self.showMomentLabelFor(.morningLatest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.showMomentLabelFor(.morningLatest(point), withAnimation: false)
            self.locateMarkingBarViewFor(.morningLatest(point))
        }
    }
    
    @objc func lunchTimeTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("lunchTimeTimeBarView point: \(point)")
        
        self.lunchTimeTimeBarView.isUserInteractionEnabled = false
        self.nextButton.isUserInteractionEnabled = false
        
        self.locateMarkingBarViewFor(.lunchTime(point))
        //self.showMomentLabelFor(.lunchTime(point), withAnimation: true)
    }
    
    @objc func lunchTimeTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("lunchTimeTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.lunchTimeTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.lunchTime(point))
            self.showMomentLabelFor(.lunchTime(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.lunchTime(point))
            self.showMomentLabelFor(.lunchTime(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.showMomentLabelFor(.lunchTime(point), withAnimation: false)
            self.locateMarkingBarViewFor(.lunchTime(point))
        }
    }
    
    @objc func afternoonEarliestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("afternoonEarliestAttendanceTimeBarView point: \(point)")
        
        if self.ignoringLunchTimeButton.isSelected {
            self.locateMarkingBarViewFor(.afternoonEarliest(point))
            
        } else {
            let aheadPointOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant - 23.25 - 23.25/2
            let endOfPointOfAfternoonEarliestAttendaceArea = self.afternoonEarliestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            if point.x <= aheadPointOfAfternoonEarliestAttendaceArea ||
                point.x >= endOfPointOfAfternoonEarliestAttendaceArea {
                self.afternoonEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
                self.nextButton.isUserInteractionEnabled = false
                
                self.locateMarkingBarViewFor(.afternoonEarliest(point))
                //self.showMomentLabelFor(.afternoonEarliest(point), withAnimation: true)
            }
        }
    }
    
    @objc func afternoonEarliestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("afternoonEarliestAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.afternoonEarliestAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.afternoonEarliest(point))
            self.showMomentLabelFor(.afternoonEarliest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.afternoonEarliest(point))
            self.showMomentLabelFor(.afternoonEarliest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.showMomentLabelFor(.afternoonEarliest(point), withAnimation: false)
            self.locateMarkingBarViewFor(.afternoonEarliest(point))
        }
    }
    
    @objc func afternoonLatestAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("afternoonLatestAttendanceTimeBarView point: \(point)")
        
        if self.ignoringLunchTimeButton.isSelected {
            self.locateMarkingBarViewFor(.afternoonLatest(point))
            
        } else {
            let aheadPointOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant - 23.25 - 23.25/2
            let endOfPointOfAfternoonLatestAttendaceArea = self.afternoonLatestAttendaceAreaCenterXAnchorConstraint.constant + 23.25
            
            if point.x <= aheadPointOfAfternoonLatestAttendaceArea ||
                point.x >= endOfPointOfAfternoonLatestAttendaceArea {
                self.afternoonLatestAttendanceTimeBarView.isUserInteractionEnabled = false
                self.nextButton.isUserInteractionEnabled = false
                
                self.locateMarkingBarViewFor(.afternoonLatest(point))
                //self.showMomentLabelFor(.afternoonLatest(point), withAnimation: true)
            }
        }
    }
    
    @objc func afternoonLatestAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("afternoonLatestAttendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            self.afternoonLatestAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.afternoonLatest(point))
            self.showMomentLabelFor(.afternoonLatest(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.afternoonLatest(point))
            self.showMomentLabelFor(.afternoonLatest(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.showMomentLabelFor(.afternoonLatest(point), withAnimation: false)
            self.locateMarkingBarViewFor(.afternoonLatest(point))
        }
    }
    
    @objc func nextButton(_ sender: UIButton) {
        guard let morningAttendanceTimeRange = self.determineMorningAttendanceTimeValue(),
              let lunchTime = self.determineLunchTimeValue(),
              let afternoonAttendanceTimeRange = self.determineAfternoonAttendanceTimeValue() else {
                  return
        }
        
        print("Work type is staggered work type")
        print("Morning Attendance Time Range: \(morningAttendanceTimeRange.earliestTime) ~ \(morningAttendanceTimeRange.latestTime)")
        print("Lunch Time: \(lunchTime)")
        print("Is ignore lunch time for half vacation: \(self.ignoringLunchTimeButton.isSelected ? "Yes" : "No")")
        print("Afternoon Attendance Time Range: \(afternoonAttendanceTimeRange.earliestTime) ~ \(afternoonAttendanceTimeRange.latestTime)")
        
        // Work type
        ReferenceValues.initialSetting.updateValue(WorkType.staggered.rawValue, forKey: InitialSetting.workType.rawValue)
        
        // Morning attendance time range
        ReferenceValues.initialSetting.updateValue(
            [TimeRange.earliestTime.rawValue:morningAttendanceTimeRange.earliestTime,
             TimeRange.latestTime.rawValue:morningAttendanceTimeRange.latestTime], forKey: InitialSetting.morningStartingworkTimeValueRange.rawValue)
        
        // Lunch time
        ReferenceValues.initialSetting.updateValue(lunchTime, forKey: InitialSetting.lunchTimeValue.rawValue)
        
        // Afternoon attendance time
        ReferenceValues.initialSetting.updateValue(
            [TimeRange.earliestTime.rawValue:afternoonAttendanceTimeRange.earliestTime,
             TimeRange.latestTime.rawValue:afternoonAttendanceTimeRange.latestTime], forKey: InitialSetting.afternoonStartingworkTimeValueRange.rawValue)
        
        // Is ignore lunch time for half vacation
        ReferenceValues.initialSetting.updateValue(self.ignoringLunchTimeButton.isSelected, forKey: InitialSetting.isIgnoredLunchTimeForHalfVacation.rawValue)
        
        // Day Off VC
        let dayOffVC = DayOffViewController()
        dayOffVC.modalPresentationStyle = .fullScreen

        self.present(dayOffVC, animated: true, completion: nil)
    }
}

// MARK: Extension for UIScrollViewDelegate
extension StaggeredWorkTypeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            self.nextButtonView.layer.shadowOpacity =
            scrollView.contentSize.height - scrollView.frame.height > scrollView.contentOffset.y ? 1 : 0
        }
    }
}
