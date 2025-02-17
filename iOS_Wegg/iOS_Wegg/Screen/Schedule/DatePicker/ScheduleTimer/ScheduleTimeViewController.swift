//
//  ScheduleTimeViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/17/25.
//

import UIKit

class ScheduleTimeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = scheduleTimerView
    }
    lazy var scheduleTimerView = ScheduleTimeView().then {
        $0.delegate = self
    }
    
}

extension ScheduleTimeViewController: ScheduleViewDelegate {
    
    func didTapCancelButton() {
        print("didTapCancelButton")
    }
    
    func didTapConfirmButton() {
        print("didTapConfirmButton")
    }
    
    func didTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 24시간 형식
        
        let selectedTime = formatter.string(from: sender.date)
        print("선택된 시간: \(selectedTime)")
    }
    
}
