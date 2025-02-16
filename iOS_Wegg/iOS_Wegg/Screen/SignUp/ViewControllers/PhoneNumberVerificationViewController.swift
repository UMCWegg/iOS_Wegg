//
//  PhoneNumberVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class PhoneNumberVerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    var phoneNumber: String?
    private let phoneNumberVerificationView = PhoneNumberVerificationView()
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = phoneNumberVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupSubLabel()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        phoneNumberVerificationView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside)
        
        phoneNumberVerificationView.backButton.addTarget(self,
                                                         action: #selector(backButtonTapped),
                                                         for: .touchUpInside)
    }
    
    private func setupSubLabel() {
        if let phoneNumber = phoneNumber {
            phoneNumberVerificationView.phoneNumber = phoneNumber
        }
    }
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let verificationCode = phoneNumberVerificationView.verificationTextField.verificationCode
        
        Task {
            do {
                // API 요청 형식에 맞게 요청 데이터 구성
                let request = CheckVerificationRequest(
                    type: "PHONE",
                    target: phoneNumber ?? "",
                    number: verificationCode
                )
                
                let response = try await authService
                    .checkVerificationNumber(request: request)
                
                if response.isSuccess && response.result.valid {
                    // 인증 성공 시 다음 화면으로 이동
                    let nameInputVC = NameInputViewController()
                    navigationController?.pushViewController(nameInputVC, animated: true)
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
        guard let phoneNumber = phoneNumber else { return }
        
        Task {
            do {
                let response = try await authService.verifyPhone(phoneNumber)
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
