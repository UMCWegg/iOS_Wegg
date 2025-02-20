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
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = passwordResetVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupEmailLabel()
        setupTimer()
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
    
    private func setupTimer() {
        TimerManager.shared.timerCallback = { [weak self] remainingTime in
            self?.passwordResetVerificationView.timerLabel.text = TimerManager.shared.getFormattedTime()
        }
        
        TimerManager.shared.timerExpiredCallback = { [weak self] in
            self?.showAlert(message: "인증 시간이 만료되었습니다. 다시 시도해주세요.")
            self?.navigationController?.popViewController(animated: true)
        }
        
        TimerManager.shared.startTimer()
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonTapped() {
        let verificationCode = passwordResetVerificationView.verificationTextField.verificationCode
        
        Task {
            do {
                let request = CheckVerificationRequest(
                    type: "EMAIL",
                    target: userEmail ?? "",
                    number: verificationCode
                )
                
                let response = try await AuthService
                    .shared.checkVerificationNumber(request: request)
                
                if response.isSuccess && response.result.valid {
                    let mainTabBarController = MainTabBarController()
                    navigationController?.setViewControllers([mainTabBarController], animated: true)
                } else {
                    // 실패 처리
                    showAlert(message: "인증번호가 올바르지 않습니다")
                }
            } catch {
                print("❌ 인증번호 확인 실패: \(error)")
                showAlert(message: "인증에 실패했습니다")
            }
        }
    }
    
        @objc private func resendButtonTapped() {
            TimerManager.shared.startTimer()
            
            guard let userEmail = userEmail else { return }
            
            Task {
                do {
                    let response = try await authService.verifyEmail(userEmail)
                    if response.isSuccess {
                        showAlert(message: "인증번호가 재전송되었습니다")
                    }
                } catch {
                    print("❌ 인증번호 재전송 실패: \(error)")
                    showAlert(message: "인증번호 재전송에 실패했습니다")
                }
            }
        }
        
        private func showAlert(message: String) {
            let alert = UIAlertController(
                title: "알림",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
