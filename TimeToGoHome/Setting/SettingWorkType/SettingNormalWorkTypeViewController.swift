//
//  SettingNormalWorkTypeViewController.swift
//  TimeToGoHome
//
//  Created by Yongseok Choi on 2023/01/08.
//

import UIKit

class SettingNormalWorkTypeViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.tag = 1
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: ReferenceValues.keyWindow.screen.bounds.width, height: 514 + 20)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        button.alpha = 0.5
        button.addTarget(self, action: #selector(workTypeButtons(_:)), for: .touchUpInside)
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
    
    lazy var morningAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendance7Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "7"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendance8Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "8"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendance9Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "9"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendance10Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "10"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var morningAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 167, green: 255, blue: 254, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let attendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(attendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(attendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarFourthHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarFifthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var morningAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 217, blue: 228)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Attendance time bar marking view
        let attendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(attendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(attendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    lazy var leavingMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "퇴근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leaving16Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "16"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leaving17Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "17"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leaving18Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "18"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leaving19Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "19"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leaving20Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "20"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var leavingTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 242, green: 234, blue: 227, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var leavingTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 166, green: 166, blue: 166)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
    
//    lazy var ignoringLunchTimeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "ignoringLunchTimeButtonNormalImage"), for: .normal)
//        button.setImage(UIImage(named: "ignoringLunchTimeButtonSelectedImage"), for: .selected)
//        button.addTarget(self, action: #selector(ignoringLunchTimeButton(_:)), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    lazy var ignoringLunchTimeMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeOfNormalWorkType.rawValue] as? Bool == true ? .black : .useRGB(red: 221, green: 221, blue: 221)
        label.text = "반차 시 점심시간 무시"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var ignoreLunchSwitch: YSBlueSwitch = {
        let switchButton = YSBlueSwitch(ReferenceValues.initialSetting[InitialSetting.isIgnoredLunchTimeOfNormalWorkType.rawValue] as? Bool == true)
        switchButton.addTarget(self, action: #selector(ignoreLunchSwitch(_:)), for: .valueChanged)
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        return switchButton
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
    
    lazy var afternoonAttendanceMarkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "출근 시간"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance11Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "11"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance12Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "12"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance13Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "13"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance14Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "14"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance15Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "15"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendance16Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 9)
        label.text = "16"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var afternoonAttendanceTimeBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 176, green: 255, blue: 186, alpha: 0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonAttendanceTimeBarViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(afternoonAttendanceTimeBarViewTapGesture(_:)))
        view.addGestureRecognizer(afternoonAttendanceTimeBarViewTapGesture)
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFirstPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFirstHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarSecondPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarSecondHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarThirdPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarThirdHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFourthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFourthHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFifthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarFifthHalfPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarSixthPointView: UIView = {
        let view = UIView()
        view.backgroundColor = .useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var afternoonAttendanceTimeBarMarkingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.useRGB(red: 110, green: 228, blue: 159)
        view.layer.cornerRadius = 9
        view.layer.useSketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 4, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let afternoonAttendanceTimeBarMarkingViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(afternoonAttendanceTimeBarMarkingViewPanGesture(_:)))
        view.addGestureRecognizer(afternoonAttendanceTimeBarMarkingViewPanGesture)
        
        return view
    }()
    
    weak var mainVC: MainViewController?
    
    var morningAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var morningLeavingTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var lunchTimeAreaCenterXAnchorConstraint: NSLayoutConstraint!
    var lunchTimeTimeBarMarkingViewConstraint: NSLayoutConstraint!
    var afternoonAttendaceTimeBarMarkingViewConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewFoundation()
        self.initializeObjects()
        self.setTargets()
        self.setGestures()
        self.setDelegates()
        self.setNotificationCenters()
        self.setSubviews()
        self.setLayouts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.determineInitialValues()
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
            print("----------------------------------- SettingNormalWorkTypeViewController disposed -----------------------------------")
    }
}

// MARK: - Extension for essential methods
extension SettingNormalWorkTypeViewController: EssentialViewMethods {
    // Set view foundation
    func setViewFoundation() {
        self.view.backgroundColor = .white
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.black,
            .font : UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        
        self.navigationController?.setNavigationBarHidden(false, animated: true);
        
        self.navigationItem.title = "근무 형태"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(leftBarButtonItem(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(rightBarButtonItem(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // Initialize views
    func initializeObjects() {
        
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
            self.scrollView
        ], to: self.view)
        
        SupportingMethods.shared.addSubviews([
            self.contentView
        ], to: self.scrollView)
        
        SupportingMethods.shared.addSubviews([
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
            self.morningAttendanceMarkLabel,
            self.morningAttendance7Label,
            self.morningAttendance8Label,
            self.morningAttendance9Label,
            self.morningAttendance10Label,
            self.morningAttendance11Label,
            self.morningAttendanceTimeBarView,
            self.leavingMarkLabel,
            self.leaving16Label,
            self.leaving17Label,
            self.leaving18Label,
            self.leaving19Label,
            self.leaving20Label,
            self.leavingTimeBarView
        ], to: self.morningTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.morningAttendanceTimeBarFirstPointView,
            self.morningAttendanceTimeBarFirstHalfPointView,
            self.morningAttendanceTimeBarSecondPointView,
            self.morningAttendanceTimeBarSecondHalfPointView,
            self.morningAttendanceTimeBarThirdPointView,
            self.morningAttendanceTimeBarThirdHalfPointView,
            self.morningAttendanceTimeBarFourthPointView,
            self.morningAttendanceTimeBarFourthHalfPointView,
            self.morningAttendanceTimeBarFifthPointView,
            self.morningAttendanceTimeBarMarkingView
        ], to: self.morningAttendanceTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.leavingTimeBarMarkingView
        ], to: self.leavingTimeBarView)
        
        SupportingMethods.shared.addSubviews([
            self.lunchTimeMarkLabel,
            self.lunchTime11Label,
            self.lunchTime12Label,
            self.lunchTime13Label,
            self.lunchTime14Label,
            self.lunchTime15Label,
            self.lunchTimeTimeBarView,
            self.ignoringLunchTimeMarkLabel,
            self.ignoreLunchSwitch
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
            self.afternoonAttendanceMarkLabel,
            self.afternoonAttendance11Label,
            self.afternoonAttendance12Label,
            self.afternoonAttendance13Label,
            self.afternoonAttendance14Label,
            self.afternoonAttendance15Label,
            self.afternoonAttendance16Label,
            self.afternoonAttendanceTimeBarView,
        ], to: self.afternoonTimeView)
        
        SupportingMethods.shared.addSubviews([
            self.afternoonAttendanceTimeBarFirstPointView,
            self.afternoonAttendanceTimeBarFirstHalfPointView,
            self.afternoonAttendanceTimeBarSecondPointView,
            self.afternoonAttendanceTimeBarSecondHalfPointView,
            self.afternoonAttendanceTimeBarThirdPointView,
            self.afternoonAttendanceTimeBarThirdHalfPointView,
            self.afternoonAttendanceTimeBarFourthPointView,
            self.afternoonAttendanceTimeBarFourthHalfPointView,
            self.afternoonAttendanceTimeBarFifthPointView,
            self.afternoonAttendanceTimeBarFifthHalfPointView,
            self.afternoonAttendanceTimeBarSixthPointView,
            self.afternoonAttendanceTimeBarMarkingView
        ], to: self.afternoonAttendanceTimeBarView)
    }
    
    // Set layouts
    func setLayouts() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        // Scroll view layout
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
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
        
        // Staggered type button layout
        NSLayoutConstraint.activate([
            self.staggeredTypeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            self.staggeredTypeButton.heightAnchor.constraint(equalToConstant: 92),
            self.staggeredTypeButton.trailingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: -50),
            self.staggeredTypeButton.widthAnchor.constraint(equalToConstant: 92)
        ])
        
        // Normal type button layout
        NSLayoutConstraint.activate([
            self.normalTypeButton.topAnchor.constraint(equalTo: self.staggeredTypeButton.topAnchor),
            self.normalTypeButton.heightAnchor.constraint(equalToConstant: 92),
            self.normalTypeButton.leadingAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 50),
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
        
        // Attendance mark label layout
        NSLayoutConstraint.activate([
            self.morningAttendanceMarkLabel.topAnchor.constraint(equalTo: self.morningTimeView.topAnchor, constant: 10),
            self.morningAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.morningAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.morningAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Attendance time bar view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarView.centerYAnchor.constraint(equalTo: self.morningAttendanceMarkLabel.centerYAnchor),
            self.morningAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.morningAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor),
            self.morningAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Attendance 7 label layout
        NSLayoutConstraint.activate([
            self.morningAttendance7Label.bottomAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.topAnchor),
            self.morningAttendance7Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningAttendance7Label.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFirstPointView.centerXAnchor)
        ])
        
        // Attendance 8 label layout
        NSLayoutConstraint.activate([
            self.morningAttendance8Label.bottomAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.topAnchor),
            self.morningAttendance8Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningAttendance8Label.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarSecondPointView.centerXAnchor)
        ])
        
        // Attendance 9 label layout
        NSLayoutConstraint.activate([
            self.morningAttendance9Label.bottomAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.topAnchor),
            self.morningAttendance9Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningAttendance9Label.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarThirdPointView.centerXAnchor)
        ])
        
        // Attendance 10 label layout
        NSLayoutConstraint.activate([
            self.morningAttendance10Label.bottomAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.topAnchor),
            self.morningAttendance10Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningAttendance10Label.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFourthPointView.centerXAnchor)
        ])
        
        // Attendance 11 label layout
        NSLayoutConstraint.activate([
            self.morningAttendance11Label.bottomAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.topAnchor),
            self.morningAttendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.morningAttendance11Label.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFifthPointView.centerXAnchor)
        ])
        
        // Attendance time bar first point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.morningAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar first half point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFirstPointView.centerXAnchor, constant: 23.25),
            self.morningAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Attendance time bar second point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFirstPointView.centerXAnchor, constant: 46.5),
            self.morningAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar second half point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarSecondPointView.centerXAnchor, constant: 23.25),
            self.morningAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Attendance time bar third point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarSecondPointView.centerXAnchor, constant: 46.5),
            self.morningAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar third half point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarThirdPointView.centerXAnchor, constant: 23.25),
            self.morningAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Attendance time bar fourth point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarThirdPointView.centerXAnchor, constant: 46.5),
            self.morningAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar fourth half point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarFourthHalfPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarFourthHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.morningAttendanceTimeBarFourthHalfPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFourthPointView.centerXAnchor, constant: 23.25),
            self.morningAttendanceTimeBarFourthHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // Attendance time bar fifth point view layout
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarFifthPointView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarFifthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.morningAttendanceTimeBarFifthPointView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarFourthPointView.centerXAnchor, constant: 46.5),
            self.morningAttendanceTimeBarFifthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar marking view layout
        self.morningAttendaceTimeBarMarkingViewConstraint = self.morningAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.leadingAnchor, constant: 105) // 12 + 93
        NSLayoutConstraint.activate([
            self.morningAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.morningAttendanceTimeBarView.centerYAnchor),
            self.morningAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.morningAttendaceTimeBarMarkingViewConstraint,
            self.morningAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // Leaving mark label layout
        NSLayoutConstraint.activate([
            self.leavingMarkLabel.bottomAnchor.constraint(equalTo: self.morningTimeView.bottomAnchor),
            self.leavingMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.leavingMarkLabel.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.leavingMarkLabel.trailingAnchor.constraint(equalTo: self.leavingTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Latest attendance time bar view layout
        NSLayoutConstraint.activate([
            self.leavingTimeBarView.centerYAnchor.constraint(equalTo: self.leavingMarkLabel.centerYAnchor),
            self.leavingTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.leavingTimeBarView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor),
            self.leavingTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Leaving 16 label layout
        NSLayoutConstraint.activate([
            self.leaving16Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving16Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving16Label.centerXAnchor.constraint(equalTo: self.leavingTimeBarView.leadingAnchor, constant: 12)
        ])
        
        // Leaving 17 label layout
        NSLayoutConstraint.activate([
            self.leaving17Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving17Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving17Label.centerXAnchor.constraint(equalTo: self.leaving16Label.centerXAnchor, constant: 46.5)
        ])
        
        // Leaving 18 label layout
        NSLayoutConstraint.activate([
            self.leaving18Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving18Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving18Label.centerXAnchor.constraint(equalTo: self.leaving17Label.centerXAnchor, constant: 46.5)
        ])
        
        // Leaving 19 label layout
        NSLayoutConstraint.activate([
            self.leaving19Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving19Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving19Label.centerXAnchor.constraint(equalTo: self.leaving18Label.centerXAnchor, constant: 46.5)
        ])
        
        // Leaving 20 label layout
        NSLayoutConstraint.activate([
            self.leaving20Label.bottomAnchor.constraint(equalTo: self.leavingTimeBarView.topAnchor),
            self.leaving20Label.heightAnchor.constraint(equalToConstant: 10),
            self.leaving20Label.centerXAnchor.constraint(equalTo: self.leaving19Label.centerXAnchor, constant: 46.5)
        ])
        
        // Leaving time bar marking view layout
        self.morningLeavingTimeBarMarkingViewConstraint = self.leavingTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.leavingTimeBarView.leadingAnchor, constant: 105) // 12 + 93
        NSLayoutConstraint.activate([
            self.leavingTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.leavingTimeBarView.centerYAnchor),
            self.leavingTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.morningLeavingTimeBarMarkingViewConstraint,
            self.leavingTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        // MARK: Lunch time view layout
        NSLayoutConstraint.activate([
            self.lunchTimeView.topAnchor.constraint(equalTo: self.morningTimeView.bottomAnchor, constant: 32),
            self.lunchTimeView.heightAnchor.constraint(equalToConstant: 81),
            self.lunchTimeView.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.lunchTimeView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor)
        ])
        
        // Lunch time mark label layout
        NSLayoutConstraint.activate([
            self.lunchTimeMarkLabel.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.lunchTimeMarkLabel.leadingAnchor.constraint(equalTo: self.lunchTimeView.leadingAnchor),
            self.lunchTimeMarkLabel.trailingAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Lunch time time bar view layout
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarView.topAnchor.constraint(equalTo: self.lunchTimeView.topAnchor, constant: 13),
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
        self.lunchTimeAreaCenterXAnchorConstraint = self.lunchTimeAreaView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: 81.75) // 12 + 46.5 + 23.25
        NSLayoutConstraint.activate([
            self.lunchTimeAreaView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeAreaView.heightAnchor.constraint(equalToConstant: 24),
            self.lunchTimeAreaCenterXAnchorConstraint,
            self.lunchTimeAreaView.widthAnchor.constraint(equalToConstant: 46.5)
        ])
        
        // Lunch time time bar marking view layout
        self.lunchTimeTimeBarMarkingViewConstraint = self.lunchTimeTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor, constant: 58.5) // 12 + 46.5
        NSLayoutConstraint.activate([
            self.lunchTimeTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.lunchTimeTimeBarView.centerYAnchor),
            self.lunchTimeTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.lunchTimeTimeBarMarkingViewConstraint,
            self.lunchTimeTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
        
//        // Ignoring lunch time button layout
//        NSLayoutConstraint.activate([
//            self.ignoringLunchTimeButton.topAnchor.constraint(equalTo: self.lunchTimeTimeBarView.bottomAnchor, constant: 10),
//            self.ignoringLunchTimeButton.heightAnchor.constraint(equalToConstant: 18),
//            self.ignoringLunchTimeButton.leadingAnchor.constraint(equalTo: self.lunchTimeTimeBarView.leadingAnchor),
//            self.ignoringLunchTimeButton.widthAnchor.constraint(equalToConstant: 18)
//        ])
        
        // Ignoring lunch time mark label layout
        NSLayoutConstraint.activate([
            self.ignoringLunchTimeMarkLabel.centerYAnchor.constraint(equalTo: self.ignoreLunchSwitch.centerYAnchor),
            self.ignoringLunchTimeMarkLabel.trailingAnchor.constraint(equalTo: self.ignoreLunchSwitch.leadingAnchor, constant: -16),
            self.ignoringLunchTimeMarkLabel.widthAnchor.constraint(equalToConstant: 123)
        ])
        
        // ignoreLunchSwitch
        NSLayoutConstraint.activate([
            self.ignoreLunchSwitch.topAnchor.constraint(equalTo: self.lunchTimeTimeBarView.bottomAnchor, constant: 16),
            self.ignoreLunchSwitch.trailingAnchor.constraint(equalTo: self.lunchTimeView.trailingAnchor)
        ])
        
        // Afternoon label layout
        NSLayoutConstraint.activate([
            self.afternoonLabel.bottomAnchor.constraint(equalTo: self.afternoonTimeView.topAnchor, constant: -5),
            self.afternoonLabel.centerXAnchor.constraint(equalTo: self.afternoonTimeView.centerXAnchor),
        ])
        
        // MARK: Afternoon time view layout
        NSLayoutConstraint.activate([
            self.afternoonTimeView.topAnchor.constraint(equalTo: self.lunchTimeView.bottomAnchor, constant: 61),
            self.afternoonTimeView.heightAnchor.constraint(equalToConstant: 37),
            self.afternoonTimeView.leadingAnchor.constraint(equalTo: self.morningTimeView.leadingAnchor),
            self.afternoonTimeView.trailingAnchor.constraint(equalTo: self.morningTimeView.trailingAnchor)
        ])
        
        // Attendance mark label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendanceMarkLabel.centerYAnchor.constraint(equalTo: self.afternoonTimeView.centerYAnchor),
            self.afternoonAttendanceMarkLabel.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonAttendanceMarkLabel.leadingAnchor.constraint(equalTo: self.afternoonTimeView.leadingAnchor),
            self.afternoonAttendanceMarkLabel.trailingAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.leadingAnchor, constant: -5)
        ])
        
        // Attendance time bar view layout
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarView.topAnchor.constraint(equalTo: self.afternoonTimeView.topAnchor, constant: 13),
            self.afternoonAttendanceTimeBarView.heightAnchor.constraint(equalToConstant: 24),
            self.afternoonAttendanceTimeBarView.trailingAnchor.constraint(equalTo: self.afternoonTimeView.trailingAnchor),
            self.afternoonAttendanceTimeBarView.widthAnchor.constraint(equalToConstant: 210)
        ])
        
        // Attendance 11 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance11Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance11Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance11Label.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.leadingAnchor, constant: 12)
        ])
        
        // Attendance 12 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance12Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance12Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance12Label.centerXAnchor.constraint(equalTo: self.afternoonAttendance11Label.centerXAnchor, constant: 37.2)
        ])
        
        // Attendance 13 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance13Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance13Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance13Label.centerXAnchor.constraint(equalTo: self.afternoonAttendance12Label.centerXAnchor, constant: 37.2)
        ])
        
        // Attendance 14 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance14Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance14Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance14Label.centerXAnchor.constraint(equalTo: self.afternoonAttendance13Label.centerXAnchor, constant: 37.2)
        ])
        
        // Attendance 15 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance15Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance15Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance15Label.centerXAnchor.constraint(equalTo: self.afternoonAttendance14Label.centerXAnchor, constant: 37.2)
        ])
        
        // Attendance 16 label layout
        NSLayoutConstraint.activate([
            self.afternoonAttendance16Label.bottomAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.topAnchor),
            self.afternoonAttendance16Label.heightAnchor.constraint(equalToConstant: 10),
            self.afternoonAttendance16Label.centerXAnchor.constraint(equalTo: self.afternoonAttendance15Label.centerXAnchor, constant: 37.2)
        ])
        
        // afternoonAttendanceTimeBarFirstPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFirstPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFirstPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarFirstPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.leadingAnchor, constant: 12),
            self.afternoonAttendanceTimeBarFirstPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // afternoonAttendanceTimeBarFirstHalfPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFirstHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFirstHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonAttendanceTimeBarFirstHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFirstPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarFirstHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // afternoonAttendanceTimeBarSecondPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarSecondPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarSecondPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarSecondPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFirstHalfPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarSecondPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // afternoonAttendanceTimeBarSecondHalfPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarSecondHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarSecondHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonAttendanceTimeBarSecondHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarSecondPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarSecondHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // afternoonAttendanceTimeBarThirdPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarThirdPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarThirdPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarThirdPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarSecondHalfPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarThirdPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // afternoonAttendanceTimeBarThirdHalfPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarThirdHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarThirdHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonAttendanceTimeBarThirdHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarThirdPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarThirdHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // afternoonAttendanceTimeBarFourthPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFourthPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFourthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarFourthPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarThirdHalfPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarFourthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // afternoonAttendanceTimeBarFourthHalfPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFourthHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFourthHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonAttendanceTimeBarFourthHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFourthPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarFourthHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // afternoonAttendanceTimeBarFifthPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFifthPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFifthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarFifthPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFourthHalfPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarFifthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // afternoonAttendanceTimeBarFifthHalfPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarFifthHalfPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarFifthHalfPointView.heightAnchor.constraint(equalToConstant: 3),
            self.afternoonAttendanceTimeBarFifthHalfPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFifthPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarFifthHalfPointView.widthAnchor.constraint(equalToConstant: 3)
        ])
        
        // afternoonAttendanceTimeBarSixthPointView
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarSixthPointView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarSixthPointView.heightAnchor.constraint(equalToConstant: 6),
            self.afternoonAttendanceTimeBarSixthPointView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarFifthHalfPointView.centerXAnchor, constant: 18.6),
            self.afternoonAttendanceTimeBarSixthPointView.widthAnchor.constraint(equalToConstant: 6)
        ])
        
        // Attendance time bar marking view layout
        self.afternoonAttendaceTimeBarMarkingViewConstraint = self.afternoonAttendanceTimeBarMarkingView.centerXAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.leadingAnchor, constant: 123.6) // 12 + 37.2 * 3
        NSLayoutConstraint.activate([
            self.afternoonAttendanceTimeBarMarkingView.centerYAnchor.constraint(equalTo: self.afternoonAttendanceTimeBarView.centerYAnchor),
            self.afternoonAttendanceTimeBarMarkingView.heightAnchor.constraint(equalToConstant: 18),
            self.afternoonAttendaceTimeBarMarkingViewConstraint,
            self.afternoonAttendanceTimeBarMarkingView.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
}

// MARK: - Extension for methods added
extension SettingNormalWorkTypeViewController {
    func determineInitialValues() {
        if self.mainVC?.schedule.workType == .normal {
            // Morning attendance
            let morningStartingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.morningStartingWorkTimeValue.rawValue] as! Double
            self.locateMarkingBarViewFor(.attendance(self.determineMorningAttendacePoint(morningStartingWorkTimeValue)!), isInitialization: true)
            
            // Lunch time
            let lunchTimeValue = ReferenceValues.initialSetting[InitialSetting.lunchTimeValue.rawValue] as! Double
            self.locateMarkingBarViewFor(.lunchTime(self.determineLunchPoint(lunchTimeValue)!), isInitialization: true)
            
            // Afternoon attendance
            let afternoonStartingWorkTimeValue = ReferenceValues.initialSetting[InitialSetting.afternoonStartingWorkTimeValue.rawValue] as! Double
            self.locateMarkingBarViewFor(.afternoonAttendance(self.determineAfternoonAttendacePoint(afternoonStartingWorkTimeValue)!), isInitialization: true)
        }
    }
    
    func locateMarkingBarViewFor(_ type: NormalMarkingViewType, isInitialization: Bool = false) {
        switch type {
        case .attendance(let point): // MARK: attendance
            if point.x <= 23.625 { // 12 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 12 // (07:00)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 12 // (16:00)
                
            } else if point.x > 23.625 && point.x <= 46.875 { // 12 + 23.25 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (07:30)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 35.25 // 12 + 23.25 (16:30)
                
            } else if point.x > 46.875 && point.x <= 70.125 { // 12 + 23.25*2 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (08:00)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 58.5 // 12 + 23.25*2 (17:00)
                
            } else if point.x > 70.125 && point.x <= 93.375 { // 12 + 23.25*3 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (08:30)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 81.75 // 12 + 23.25*3 (17:30)
                
            } else if point.x > 93.375 && point.x <= 116.625 { // 12 + 23.25*4 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (09:00)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 105 // 12 + 23.25*4 (18:00)
                
            } else if point.x > 116.625 && point.x <= 139.875 { // 12 + 23.25*5 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (09:30)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 128.25 // 12 + 23.25*5 (18:30)
                
            } else if point.x > 139.875 && point.x <= 163.125 { // 12 + 23.25*6 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (10:00)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 151.5 // 12 + 23.25*6 (19:00)
                
            } else if point.x > 163.125 && point.x <= 186.375 { // 12 + 23.25*7 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 174.75 // 12 + 23.25*7 (10:30)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 174.75 // 12 + 23.25*7 (19:30)
                
            } else { // > 12 + 23.25*7 + 23.25/2
                self.morningAttendaceTimeBarMarkingViewConstraint.constant = 198 // 12 + 23.25*8 (11:00)
                self.morningLeavingTimeBarMarkingViewConstraint.constant = 198 // 12 + 23.25*8 (20:00)
            }
            
            //self.determineAfternoonAttendanceTimeMarkingCenterX()
            
            UIView.animate(withDuration: 0.2) {
                self.morningAttendanceTimeBarView.layoutIfNeeded()
                self.leavingTimeBarView.layoutIfNeeded()
                //self.afternoonAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.morningAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            
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
                //self.afternoonAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.lunchTimeTimeBarView.isUserInteractionEnabled = true
                    self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
            
        case .afternoonAttendance(let point):
            if point.x <= 21.3 { // 12 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 12 // (11:00)
                
            } else if point.x > 21.3 && point.x <= 39.9 { // 12 + 18.6 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 30.6 // 12 + 18.6 (11:30)
                
            } else if point.x > 39.9 && point.x <= 58.5 { // 12 + 18.6*2 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 49.2 // 12 + 18.6*2 (12:00)
                
            } else if point.x > 58.5 && point.x <= 77.1 { // 12 + 18.6*3 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 67.8 // 12 + 18.6*3 (12:30)
                
            } else if point.x > 77.1 && point.x <= 95.7 { // 12 + 18.6*4 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 86.4 // 12 + 18.6*4 (13:00)
                
            } else if point.x > 95.7 && point.x <= 114.3 { // 12 + 18.6*5 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 105 // 12 + 18.6*5 (13:30)
                
            } else if point.x > 114.3 && point.x <= 132.9 { // 12 + 18.6*6 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 123.6 // 12 + 18.6*6 (14:00)
                
            } else if point.x > 132.9 && point.x <= 151.5 { // 12 + 18.6*7 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 142.2 // 12 + 18.6*7 (14:30)
                
            } else if point.x > 151.5 && point.x <= 170.1 { // 12 + 18.6*8 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 160.8 // 12 + 18.6*8 (15:00)
                
            } else if point.x > 170.1 && point.x <= 188.7 { // 12 + 18.6*9 + 18.6/2
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 179.4 // 12 + 18.6*9 (15:30)
                
            } else {
                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = 198 // 12 + 18.6*10 (16:00)
            }
            
            UIView.animate(withDuration: 0.2) {
                self.afternoonAttendanceTimeBarView.layoutIfNeeded()
                
            } completion: { success in
                if success {
                    self.afternoonAttendanceTimeBarView.isUserInteractionEnabled = true
                    self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
        
        if !isInitialization {
            UIDevice.softHaptic()
        }
    }
    
    func moveMarkingBarViewTo(_ type: NormalMarkingViewType) {
        switch type {
        case .attendance(let point):
            self.morningAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 198 ?
            198 : point.x
            
        case .lunchTime(let point):
            self.lunchTimeTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 151.5 ?
            151.5 : point.x
            
        case .afternoonAttendance(let point):
            self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = point.x < 12 ?
            12 : point.x > 198 ?
            198 : point.x
        }
    }
    
    func determineLunchTimeArea(_ at: CGFloat) {
        self.lunchTimeAreaCenterXAnchorConstraint.constant = at + 23.25
        
        //self.determineAfternoonAttendanceTimeMarkingCenterX()
    }
    
//    func determineAfternoonAttendanceTimeMarkingCenterX() {
//        let workLeftCountAtMorning = self.countForWidth(23.25, in: [self.morningAttendaceTimeBarMarkingViewConstraint.constant, 198])! // 12+23.25*8
//        let toEndOfLunchTimeCount = self.countForWidth(23.25, in: [12, self.lunchTimeTimeBarMarkingViewConstraint.constant + 46.5])! // 23.25*2
//
//        if self.ignoringLunchTimeButton.isSelected {
//            self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = (trunc((12 + 18.6*CGFloat(8-workLeftCountAtMorning))*10))/10 // (210-12*2)/10
//
//        } else {
//            if workLeftCountAtMorning + toEndOfLunchTimeCount <= 10 {
//                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = (trunc((12 + 18.6*CGFloat(10-workLeftCountAtMorning))*10))/10 // (210-12*2)/10
//
//            } else {
//                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = (trunc((12 + 18.6*CGFloat(8-workLeftCountAtMorning))*10))/10 // (210-12*2)/10
//            }
//        }
//    }
    
//    func countForWidth(_ width: CGFloat, in range: [CGFloat]) -> Int? {
//        guard range.count == 2 else {
//            return nil
//        }
//
//        let rangeValue = range[1] - range[0]
//
//        return Int(rangeValue / width)
//    }
    
    func showMomentLabelFor(_ type: NormalMarkingViewType, withAnimation animation: Bool) {
        self.momentLabel.layer.removeAllAnimations()
        
        switch type {
        case .attendance(let point):
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
            
        case .afternoonAttendance(let point):
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
            
            if point.x <= 21.3 { // 12 + 18.6/2
                self.momentLabel.text = "11:00" // (11:00)
                
            } else if point.x > 21.3 && point.x <= 39.9 { // 12 + 18.6 + 18.6/2
                self.momentLabel.text = "11:30" // (11:30)
                
            } else if point.x > 39.9 && point.x <= 58.5 { // 12 + 18.6*2 + 18.6/2
                self.momentLabel.text = "12:00" // (12:00)
                
            } else if point.x > 58.5 && point.x <= 77.1 { // 12 + 18.6*3 + 18.6/2
                self.momentLabel.text = "12:30" // (12:30)
                
            } else if point.x > 77.1 && point.x <= 95.7 { // 12 + 18.6*4 + 18.6/2
                self.momentLabel.text = "13:00" // (13:00)
                
            } else if point.x > 95.7 && point.x <= 114.3 { // 12 + 18.6*5 + 18.6/2
                self.momentLabel.text = "13:30" // (13:30)
                
            } else if point.x > 114.3 && point.x <= 132.9 { // 12 + 18.6*6 + 18.6/2
                self.momentLabel.text = "14:00" // (14:00)
                
            } else if point.x > 132.9 && point.x <= 151.5 { // 12 + 18.6*7 + 18.6/2
                self.momentLabel.text = "14:30" // (14:30)
                
            } else if point.x > 151.5 && point.x <= 170.1 { // 12 + 18.6*8 + 18.6/2
                self.momentLabel.text = "15:00" // (15:00)
                
            } else if point.x > 170.1 && point.x <= 188.7 { // 12 + 18.6*9 + 18.6/2
                self.momentLabel.text = "15:30" // (15:30)
                
            } else {
                self.momentLabel.text = "16:00" // (16:00)
            }
        }
    }
    
    func determineMorningAttendanceTimeValue() -> Double? {
        guard let attendanceTime = self.getMorningAttendaceTimeValue(self.morningAttendaceTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return attendanceTime
    }
    
    func determineLunchTimeValue() -> Double? {
        guard let lunchTime = self.getLunchTimeValue(self.lunchTimeTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return lunchTime
    }
    
    func determineAfternoonAttendanceTimeValue() -> Double? {
        guard let attendanceTime = self.getAfternoonAttendaceTimeValue(self.afternoonAttendaceTimeBarMarkingViewConstraint.constant) else {
            return nil
        }
        
        return attendanceTime
    }
    
    func getMorningAttendaceTimeValue(_ from: CGFloat) -> Double? {
        if from > 11.5 && from < 12.5 { // 12
            return 7.0
            
        } else if from > 34.75 && from < 35.75 { // 35.25
            return 7.5
            
        } else if from > 58.0 && from < 59.0 { // 58.5
            return 8.0
            
        } else if from > 81.25 && from < 82.25 { // 81.75
            return 8.5
            
        } else if from > 104.5 && from < 105.5 { // 105
            return 9.0
            
        } else if from > 127.75 && from < 128.75 { // 128.25
            return 9.5
            
        } else if from > 151.0 && from < 152.0 { // 151.5
            return 10.0
            
        } else if from > 174.25 && from < 175.25 { // 174.75
            return 10.5
            
        } else if from > 197.5 && from < 198.5 { // 198
            return 11.0
            
        } else {
            return nil
        }
        
        /*
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
        */
    }
    
    func determineMorningAttendacePoint(_ timeValue: Double) -> CGPoint? {
        switch timeValue {
        case 7.0:
            return CGPoint(x: 12, y: 0)
            
        case 7.5:
            return CGPoint(x: 35.25, y: 0)
            
        case 8.0:
            return CGPoint(x: 58.5, y: 0)
            
        case 8.5:
            return CGPoint(x: 81.75, y: 0)
            
        case 9.0:
            return CGPoint(x: 105, y: 0)
            
        case 9.5:
            return CGPoint(x: 128.25, y: 0)
            
        case 10.0:
            return CGPoint(x: 151.5, y: 0)
            
        case 10.5:
            return CGPoint(x: 174.75, y: 0)
            
        case 11.0:
            return CGPoint(x: 198, y: 0)
            
        default:
            return nil
        }
    }
    
    func getLunchTimeValue(_ from: CGFloat) -> Double? {
        if from > 11.5 && from < 12.5 { // 12
            return 11.0
            
        } else if from > 34.75 && from < 35.75 { // 35.25
            return 11.5
            
        } else if from > 58.0 && from < 59.0 { // 58.5
            return 12.0
            
        } else if from > 81.25 && from < 82.25 { // 81.75
            return 12.5
            
        } else if from > 104.5 && from < 105.5 { // 105
            return 13.0
            
        } else if from > 127.75 && from < 128.75 { // 128.25
            return 13.5
            
        } else if from > 151.0 && from < 152.0 { // 151.5
            return 14.0
            
        } else {
            return nil
        }
        
        /*
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
        */
    }
    
    func determineLunchPoint(_ timeValue: Double) -> CGPoint? {
        switch timeValue {
        case 11.0:
            return CGPoint(x: 12, y: 0)
            
        case 11.5:
            return CGPoint(x: 35.25, y: 0)
            
        case 12.0:
            return CGPoint(x: 58.5, y: 0)
            
        case 12.5:
            return CGPoint(x: 81.75, y: 0)
            
        case 13.0:
            return CGPoint(x: 105, y: 0)
            
        case 13.5:
            return CGPoint(x: 128.25, y: 0)
            
        case 14.0:
            return CGPoint(x: 151.5, y: 0)
            
        default:
            return nil
        }
    }
    
    func getAfternoonAttendaceTimeValue(_ from: CGFloat) -> Double? {
        if from > 11.5 && from < 12.5 { // 12
            return 11.0
            
        } else if from > 30.1 && from < 31.1 { // 30.6
            return 11.5
            
        } else if from > 48.7 && from < 49.7 { // 49.2
            return 12.0
            
        } else if from > 67.3 && from < 68.3 { // 67.8
            return 12.5
            
        } else if from > 85.9 && from < 86.9 { // 86.4
            return 13.0
            
        } else if from > 104.5 && from < 105.5 { // 105
            return 13.5
            
        } else if from > 123.1 && from < 124.1 { // 123.6
            return 14.0
            
        } else if from > 141.7 && from < 142.7 { // 142.2
            return 14.5
            
        } else if from > 160.3 && from < 161.3 { // 160.8
            return 15.0
            
        } else if from > 178.9 && from < 179.9 { // 179.4
            return 15.5
            
        } else if from > 197.5 && from < 198.5 { // 198
            return 16.0
            
        } else {
            return nil
        }
        
        /*
        switch from {
        case 12:
            return 11.0
            
        case 30.6:
            return 11.5
            
        case 49.2:
            return 12.0
            
        case 67.8:
            return 12.5
            
        case 86.4:
            return 13.0
            
        case 105:
            return 13.5
            
        case 123.6:
            return 14.0
            
        case 142.2:
            return 14.5
            
        case 160.8:
            return 15.0
            
        case 179.4:
            return 15.5
            
        case 198:
            return 16.0
            
        default:
            return nil
        }
        */
    }
    
    func determineAfternoonAttendacePoint(_ timeValue: Double) -> CGPoint? {
        switch timeValue {
        case 11.0:
            return CGPoint(x: 12, y: 0)
            
        case 11.5:
            return CGPoint(x: 30.6, y: 0)
            
        case 12.0:
            return CGPoint(x: 49.2, y: 0)
            
        case 12.5:
            return CGPoint(x: 67.8, y: 0)
            
        case 13.0:
            return CGPoint(x: 86.4, y: 0)
            
        case 13.5:
            return CGPoint(x: 105, y: 0)
            
        case 14.0:
            return CGPoint(x: 123.6, y: 0)
            
        case 14.5:
            return CGPoint(x: 142.2, y: 0)
            
        case 15.0:
            return CGPoint(x: 160.8, y: 0)
            
        case 15.5:
            return CGPoint(x: 179.4, y: 0)
            
        case 16.0:
            return CGPoint(x: 198, y: 0)
            
        default:
            return nil
        }
    }
}

// MARK: - Extension for Selector methods
extension SettingNormalWorkTypeViewController {
    @objc func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarButtonItem(_ sender: UIBarButtonItem) {
        guard let morningAttendanceTime = self.determineMorningAttendanceTimeValue(),
              let lunchTime = self.determineLunchTimeValue(),
              let afternoonAttendanceTime = self.determineAfternoonAttendanceTimeValue() else {
                  return
        }
        
        // MARK: Remove values
        // Work type
        ReferenceValues.initialSetting.removeValue(forKey: WorkType.staggered.rawValue)
        
        // Morning attendance time range
        ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.morningStartingWorkTimeValueRange.rawValue)
        
        // Lunch time
        ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.lunchTimeValue.rawValue)
        
        // Afternoon attendance time
        ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.afternoonStartingWorkTimeValueRange.rawValue)
        
        // Is ignore lunch time for half vacation
        ReferenceValues.initialSetting.removeValue(forKey: InitialSetting.isIgnoredLunchTimeOfNormalWorkType.rawValue)
        
        print("Work type is normal work type")
        print("Morning Attendance Time: \(morningAttendanceTime)")
        print("Lunch Time: \(lunchTime)")
        print("Is ignore lunch time for half vacation: \(self.ignoreLunchSwitch.isOn ? "Yes" : "No")")
        print("Afternoon Attendance Time: \(afternoonAttendanceTime)")
        
        // MARK: Insert values
        // Work type
        ReferenceValues.initialSetting.updateValue(WorkType.normal.rawValue, forKey: InitialSetting.workType.rawValue)
        
        // Morning attendance time range
        ReferenceValues.initialSetting.updateValue(morningAttendanceTime, forKey: InitialSetting.morningStartingWorkTimeValue.rawValue)
        
        // Lunch time
        ReferenceValues.initialSetting.updateValue(lunchTime, forKey: InitialSetting.lunchTimeValue.rawValue)
        
        // Afternoon attendance time
        ReferenceValues.initialSetting.updateValue(afternoonAttendanceTime, forKey: InitialSetting.afternoonStartingWorkTimeValue.rawValue)
        
        // Is ignore lunch time for half vacation
        ReferenceValues.initialSetting.updateValue(self.ignoreLunchSwitch.isOn, forKey: InitialSetting.isIgnoredLunchTimeOfNormalWorkType.rawValue)
        
        // Update initialSetting
        SupportingMethods.shared.setAppSetting(with: ReferenceValues.initialSetting, for: .initialSetting)
        
        self.mainVC?.schedule.refreshToday()
        
        // Pop view controller
        self.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    @objc func workTypeButtons(_ sender: UIButton) {
        UIDevice.lightHaptic()
        
        self.tabBarController?.selectedIndex = 0
        
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
//    @objc func ignoringLunchTimeButton(_ sender: UIButton) {
//        UIDevice.lightHaptic()
//
//        sender.isSelected.toggle()
//
//        self.lunchTimeTimeBarView.isUserInteractionEnabled = false
//        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
//
//        if sender.isSelected {
//            self.ignoringLunchTimeMarkLabel.textColor = .black
//
//            let workLeftCountAtMorning = self.countForWidth(23.25, in: [self.morningAttendaceTimeBarMarkingViewConstraint.constant, 198])! // 12+23.25*8
//            //let toEndOfLunchTimeCount = self.countForWidth(23.25, in: [12, self.lunchTimeTimeBarMarkingViewConstraint.constant + 23.25*2])!
//
//            self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = (trunc((12 + 18.6*CGFloat(8-workLeftCountAtMorning))*10))/10 // (210-12*2)/10
//
//        } else {
//            self.ignoringLunchTimeMarkLabel.textColor = .useRGB(red: 221, green: 221, blue: 221)
//
//            let workLeftCountAtMorning = self.countForWidth(23.25, in: [self.morningAttendaceTimeBarMarkingViewConstraint.constant, 198])! // 12+23.25*8
//            let toEndOfLunchTimeCount = self.countForWidth(23.25, in: [12, self.lunchTimeTimeBarMarkingViewConstraint.constant + 46.5])! // 23.25*2
//
//            if workLeftCountAtMorning + toEndOfLunchTimeCount <= 10 {
//                self.afternoonAttendaceTimeBarMarkingViewConstraint.constant = (trunc((12 + 18.6*CGFloat(10-workLeftCountAtMorning))*10))/10 // (210-12*2)/10
//            }
//        }
//
//        UIView.animate(withDuration: 0.2) {
//            self.lunchTimeTimeBarView.layoutIfNeeded()
//            self.afternoonAttendanceTimeBarView.layoutIfNeeded()
//
//        } completion: { success in
//            if success {
//                self.lunchTimeTimeBarView.isUserInteractionEnabled = true
//                self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
//            }
//        }
//    }
    
    @objc func ignoreLunchSwitch(_ sender: YSBlueSwitch) {
        self.ignoringLunchTimeMarkLabel.textColor = sender.isOn ? .black : .useRGB(red: 221, green: 221, blue: 221)
    }
    
    @objc func attendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("attendanceTimeBarView point: \(point)")
        
        self.morningAttendanceTimeBarView.isUserInteractionEnabled = false
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.locateMarkingBarViewFor(.attendance(point))
        self.showMomentLabelFor(.attendance(point), withAnimation: true)
    }
    
    @objc func attendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("attendanceTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            //self.morningAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.attendance(point))
            self.showMomentLabelFor(.attendance(point), withAnimation: true)
        }
    }
    
    @objc func lunchTimeTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("lunchTimeTimeBarView point: \(point)")
        
        self.lunchTimeTimeBarView.isUserInteractionEnabled = false
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.locateMarkingBarViewFor(.lunchTime(point))
        self.showMomentLabelFor(.lunchTime(point), withAnimation: true)
    }
    
    @objc func lunchTimeTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("lunchTimeTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            //self.lunchTimeTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.lunchTime(point))
            self.showMomentLabelFor(.lunchTime(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.lunchTime(point))
            self.showMomentLabelFor(.lunchTime(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.lunchTime(point))
            self.showMomentLabelFor(.lunchTime(point), withAnimation: true)
        }
    }
    
    @objc func afternoonAttendanceTimeBarViewTapGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        //print("lunchTimeTimeBarView point: \(point)")
        
        self.afternoonAttendanceTimeBarView.isUserInteractionEnabled = false
        self.tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.locateMarkingBarViewFor(.afternoonAttendance(point))
        self.showMomentLabelFor(.afternoonAttendance(point), withAnimation: true)
    }
    
    @objc func afternoonAttendanceTimeBarMarkingViewPanGesture(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: gesture.view?.superview)
        //print("lunchTimeTimeBarMarkingView point: \(point)")
        
        if (gesture.state == .began) {
            //self.afternoonAttendanceTimeBarView.isUserInteractionEnabled = false
            
            self.moveMarkingBarViewTo(.afternoonAttendance(point))
            self.showMomentLabelFor(.afternoonAttendance(point), withAnimation: false)
        }
        
        if (gesture.state == .changed) {
            self.moveMarkingBarViewTo(.afternoonAttendance(point))
            self.showMomentLabelFor(.afternoonAttendance(point), withAnimation: false)
        }
        
        if (gesture.state == .ended) {
            self.locateMarkingBarViewFor(.afternoonAttendance(point))
            self.showMomentLabelFor(.afternoonAttendance(point), withAnimation: true)
        }
    }
}
