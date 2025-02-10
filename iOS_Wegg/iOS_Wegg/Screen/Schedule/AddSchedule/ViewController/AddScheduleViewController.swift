//
//  AddScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

class AddScheduleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view = addScheduleView
    }
    
    lazy var addScheduleView = AddScheduleView()

}
