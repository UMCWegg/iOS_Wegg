//
//  PasswordResetVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

class PasswordResetVerificationViewController: UIViewController {

    // MARK: - Properties
    
    private let passwordResetVerificationView = PasswordResetVerificationView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordResetVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
