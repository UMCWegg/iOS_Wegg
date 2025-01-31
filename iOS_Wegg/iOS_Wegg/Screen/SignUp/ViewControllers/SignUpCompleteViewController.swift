//
//  SignUpCompleteViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit

class SignUpCompleteViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpCompleteView = SignUpCompleteView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = signUpCompleteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
