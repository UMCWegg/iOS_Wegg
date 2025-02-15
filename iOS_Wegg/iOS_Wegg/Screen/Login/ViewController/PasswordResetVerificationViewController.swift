//
//  PasswordResetVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

class PasswordResetVerificationViewController: UIViewController {

    // MARK: - Properties
    
    var userEmail: String?
    
    private let passwordResetVerificationView = PasswordResetVerificationView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordResetVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupEmailLabel()
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
        
        passwordResetVerificationView.resendButton.addTarget(
            self,
            action: #selector(resendButtonTapped),
            for: .touchUpInside)
    }
    
    private func setupEmailLabel() {
        if let email = userEmail {
            passwordResetVerificationView.emailText = email
        }
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonTapped() {
        let verificationCode = passwordResetVerificationView.verificationTextField.verificationCode
        
        Task {
            do {
                let response = try await AuthService
                    .shared.checkVerificationNumber(verificationCode)
                if response.isSuccess {
                    let mainTabBarController = MainTabBarController()
                    navigationController?.setViewControllers([mainTabBarController], animated: true)
                }
            } catch {
                print("Verification failed: \(error)")
            }
        }
    }
    
    @objc private func resendButtonTapped() {
        guard let email = userEmail else { return }
        
        Task {
            do {
                let _ = try await AuthService.shared.verifyEmail(email)
                // TODO: 재전송 성공 알림
            } catch {
                print("Resend verification failed: \(error)")
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
