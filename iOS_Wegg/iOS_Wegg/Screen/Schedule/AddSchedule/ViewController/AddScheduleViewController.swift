//
//  AddScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

protocol AddScheduleGestureDelegate: AnyObject {
    func didTapCalendarButton()
    func didTapDoneButton()
    func didTapCancelButton()
    func didChangeDate(_ date: Date)
}

class AddScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view = addScheduleView
    }
    
    lazy var addScheduleView = AddScheduleView().then {
        $0.gestureDelegate = self
    }

}

extension AddScheduleViewController: AddScheduleGestureDelegate {
    func didTapCalendarButton() {
        let alert = UIAlertController(
            title: "\n\n\n\n\n\n\n\n\n",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.frame = CGRect(
            x: 0, y: 0,
            width: alert.view.bounds.width - 20,
            height: 450
        )
        
        alert.view.snp.makeConstraints { make in
            make.height.equalTo(600)
        }
        alert.view.addSubview(datePicker)
        
        let selectAction = UIAlertAction(title: "확인", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd" // 요일
            let selectedTime = formatter.string(from: datePicker.date)
            print(selectedTime)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func didTapDoneButton() {
        print("didTapDoneButton")
    }
    
    func didTapCancelButton() {
        print("didTapCancelButton")
    }
    
    func didChangeDate(_ date: Date) {
        print("didChangeDate")
    }
    
}
