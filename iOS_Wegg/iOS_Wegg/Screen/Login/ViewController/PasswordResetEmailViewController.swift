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
    
    // MARK: - Setup
    
    private func setupActions() {
        passwordResetEmailView.sendNumberButton.addTarget(self,
                                                          action: #selector(nextButtonTapped), for: .touchUpInside)
        
        passwordResetEmailView.backButton.addTarget(self,
                                                    action: #selector(backButtonTapped),
                                                    for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let passwordResetVerificationVC = PasswordResetVerificationViewController()
        navigationController?.pushViewController(passwordResetVerificationVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true)
    }

}
