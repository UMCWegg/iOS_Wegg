//
//  PasswordRecoveryEmailViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

class PasswordRecoveryEmailViewController: UIViewController {

    // MARK: - Properties
    
    private let passwordRecoveryEmailView = PasswordRecoveryEmailView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordRecoveryEmailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
