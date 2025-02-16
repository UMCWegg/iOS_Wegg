//
//  PhoneNumberInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.29.
//

import UIKit

class PhoneNumberInputViewController: UIViewController {
    
    // MARK: - Properties
    
    private let phoneNumberInputView = PhoneNumberInputView()
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = phoneNumberInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        phoneNumberInputView
            .sendVerificationButton
            .addTarget(self,
                       action: #selector(nextButtonTapped),
                       for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        guard let phone = formatPhoneNumber(),
              isValidPhoneNumber(phone) else {
            showAlert(message: "전화번호를 올바르게 입력해주세요")
            return
        }
        
        Task {
            do {
                let response = try await authService.verifyPhone(phone)
                if response.isSuccess {
                    UserSignUpStorage.shared.update { data in
                        data.phone = phone
                    }
                    
                    let verificationVC = PhoneNumberVerificationViewController()
                    verificationVC.phoneNumber = phone
                    navigationController?.pushViewController(verificationVC, animated: true)
                }
            } catch {
                print("❌ 전화번호 인증 요청 실패: \(error)")
                showAlert(message: "전화번호 인증 요청에 실패했습니다")
            }
        }
        
        // MARK: - Functions
        
        func formatPhoneNumber() -> String? {
            guard let first = phoneNumberInputView.firstTextField.text,
                  let second = phoneNumberInputView.secondTextField.text,
                  let third = phoneNumberInputView.thirdTextField.text,
                  !first.isEmpty && !second.isEmpty && !third.isEmpty else {
                return nil
            }
            return first + second + third
        }
        
        func isValidPhoneNumber(_ number: String) -> Bool {
            return number.count == 11 && number.allSatisfy { $0.isNumber }
        }
        
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
}
