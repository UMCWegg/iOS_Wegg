//
//  AddScheduleViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 2/10/25.
//

import UIKit

class AddScheduleViewController:
    UIViewController,
    UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        view = addScheduleView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar 숨김. 다음 화면에서도 보이지 않음.
        navigationController?.setNavigationBarHidden(true, animated: animated)
        // 뒤로가기 제스처 활성화
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    lazy var addScheduleView = AddScheduleView()

}
