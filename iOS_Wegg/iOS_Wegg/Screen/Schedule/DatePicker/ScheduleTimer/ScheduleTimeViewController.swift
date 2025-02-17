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
    
    lazy var scheduleTimerView = ScheduleTimeView()
    
}
