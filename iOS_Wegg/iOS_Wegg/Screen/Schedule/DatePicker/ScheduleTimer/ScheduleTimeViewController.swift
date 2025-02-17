//
//  ScheduleTimeViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/17/25.
//

import UIKit

class ScheduleTimeViewController: UIViewController {
    
    weak var parentVC: AddScheduleViewController?
    var timePickerType: TimePickertype?
    
    private var selectedStartTime: String?
    private var selectedFinishTime: String?

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
        selectedStartTime = nil
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        switch timePickerType {
        case .startTime:
            if let selectedTime = selectedStartTime {
                parentVC?.addScheduleView.updateRandomTimeDate(
                    type: .startTime,
                    selectedTime
                )
            } else {
                // 휠을 돌리지 않았을 경우 현재 지정된 시각으로 설정
                if selectedStartTime == nil {
                    selectedStartTime = formatter.string(from: date)
                }
                parentVC?.addScheduleView.updateRandomTimeDate(
                    type: .startTime,
                    selectedStartTime ?? "00:00"
                )
            }
        case .finishTime:
            if let selectedTime = selectedFinishTime {
                parentVC?.addScheduleView.updateRandomTimeDate(
                    type: .finishTime,
                    selectedTime
                )
            } else {
                // 휠을 돌리지 않았을 경우 현재 지정된 시각으로 설정
                if selectedFinishTime == nil {
                    selectedFinishTime = formatter.string(from: date)
                }
                parentVC?.addScheduleView.updateRandomTimeDate(
                    type: .finishTime,
                    selectedFinishTime ?? "00:00"
                )
            }
        case .none:
            print("TimePickerType Error")
        }
        dismiss(animated: true)
    }
    
    func didTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let selectedTime = formatter.string(from: sender.date)
    }
    
}
