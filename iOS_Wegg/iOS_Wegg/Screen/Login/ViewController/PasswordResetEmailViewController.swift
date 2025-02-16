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
    private let authService = AuthService.shared
    
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
                let response = try await authService.verifyEmail(email)
                if response.isSuccess {
                    
                    let verificationVC = PasswordResetVerificationViewController()
                    verificationVC.userEmail = email
                    navigationController?.pushViewController(verificationVC, animated: true)
                }
            } catch {
                print("❌ 전화번호 인증 요청 실패: \(error)")
                showAlert(message: "전화번호 인증 요청에 실패했습니다")
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Functions
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
