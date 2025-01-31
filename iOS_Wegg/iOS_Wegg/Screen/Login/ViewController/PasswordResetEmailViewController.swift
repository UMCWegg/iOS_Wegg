//
//  PasswordResetEmailViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

class PasswordResetEmailViewController: UIViewController {

    // MARK: - Properties
    
    private let passwordResetEmailView = PasswordResetEmailView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordResetEmailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
