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
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        passwordResetVerificationView.confirmButton.addTarget(
            self,
            action: #selector(confirmButtonTapped),
            for: .touchUpInside)
        
        passwordResetVerificationView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonTapped() {
        let mainTabBarController = MainTabBarController()
        navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
