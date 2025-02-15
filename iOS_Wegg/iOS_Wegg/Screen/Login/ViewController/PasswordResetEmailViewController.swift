//
//  PasswordResetEmailViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

import Combine

class PasswordResetEmailViewController: UIViewController {

    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    private let passwordResetEmailView = PasswordResetEmailView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordResetEmailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        passwordResetEmailView.sendNumberButton.addTarget(self,
                                                          action: #selector(nextButtonTapped),
                                                          for: .touchUpInside)
        
        passwordResetEmailView.backButton.addTarget(self,
                                                    action: #selector(backButtonTapped),
                                                    for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        guard let email = passwordResetEmailView.emailTextField.text else { return }
        
        Task {
            do {
                let response = try await AuthService.shared.verifyEmail(email)
                if response.isSuccess {
                    let verificationVC = PasswordResetVerificationViewController()
                    verificationVC.userEmail = email
                    navigationController?.pushViewController(verificationVC, animated: true)
                }
            } catch {
                print("Email verification failed: \(error)")
            }
        }
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
