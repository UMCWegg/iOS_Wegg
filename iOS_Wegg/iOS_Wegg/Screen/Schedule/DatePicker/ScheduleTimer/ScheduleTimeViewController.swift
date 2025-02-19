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
    
    private var selectedTime: String?
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
        selectedTime = nil
        dismiss(animated: true)
    }
    
    func didTapConfirmButton(date: Date) {
        guard let timePickerType = timePickerType else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        selectedTime = formatter.string(from: date)
        
        parentVC?.setSelectedTime(type: timePickerType, selectedTime: selectedTime ?? "00:00")
        parentVC?.addScheduleView.updateRandomTimeDate(
            type: timePickerType,
            selectedTime ?? "00:00"
        )
        dismiss(animated: true)
    }
    
}
