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
        
        // REFACTOR: [25.02.17] 추후 시간되면 시작 시각이 종료 시각보다 더 크지 못하게 막기 - 작성자: 이재원
        selectedTime = formatter.string(from: date)
        parentVC?.addScheduleView.updateRandomTimeDate(
            type: timePickerType,
            selectedTime ?? "00:00"
        )
        dismiss(animated: true)
    }
    
}
