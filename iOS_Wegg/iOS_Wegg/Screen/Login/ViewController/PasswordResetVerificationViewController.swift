//
//  PasswordResetVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit
import Combine

class PasswordResetVerificationViewController: UIViewController {

    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
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
            action: #selector(resendButtonTapped()),
            for: .touchUpInside)
    }
    
    private func setupEmailLabel() {
        if let email = userEmail {
            passwordResetVerificationView.subLabel.text = "\(email)로 인증 번호를 보냈어요"
        }
    }
    
    // MARK: - Actions
    
    @objc private func confirmButtonTapped() {
        let verificationCode = passwordResetVerificationView.verificationTextField.verificationCode
        
        AuthService.shared.checkVerificationNumber(verificationCode)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Verification failed: \(error)")
                }
            } receiveValue: { response in
                if response.isSuccess {
                    let mainTabBarController = MainTabBarController()
                    self.navigationController?
                        .setViewControllers([mainTabBarController], animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func resendButtonTapped() {
        guard let email = userEmail else { return }
        
        AuthService.shared.verifyEmail(email)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Resend verification failed: \(error)")
                }
            } receiveValue: { _ in
                // TODO: 재전송 성공 알림
            }
            .store(in: &cancellables)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
