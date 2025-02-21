//
//  EmailSignUpViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class EmailSignUpViewController: UIViewController {

    // MARK: - Properties

    private let emailSignUpView = EmailSignUpView()
    private let authService = AuthService.shared
    private var isEmailVerified = false
    
    private var isPasswordValid: Bool {
        guard let password = emailSignUpView.password,
              let confirmPassword = emailSignUpView.passwordCheckTextField.text else {
            return false
        }
        return password.count >= 6 && password == confirmPassword
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailSignUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        addKeyboardDismissGesture()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        emailSignUpView.duplicateButton.addTarget(self,
                                                  action: #selector(duplicateButtonTapped),
                                                  for: .touchUpInside)
        
        emailSignUpView.signUpButton.addTarget(self,
                                               action: #selector(signUpButtonTapped),
                                               for: .touchUpInside)
        
        emailSignUpView.backButton.addTarget(self,
                                             action: #selector(backButtonTapped),
                                             for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func duplicateButtonTapped() {
        guard let email = emailSignUpView.email else { return }
        
        Task {
            do {
                let response = try await authService.checkEmail(email)
                await MainActor.run {
                    handleDuplicateCheckResponse(response)
                }
            } catch {
                print("❌ 이메일 중복 확인 실패: \(error)")
                await MainActor.run {
                    showErrorMessage("중복 확인 중 오류가 발생했습니다")
                }
            }
        }
    }
    
    private func handleDuplicateCheckResponse(_ response: BaseResponse<IDCheckResult>) {
        emailSignUpView.duplicateCheckLabel.isHidden = false
        
        if !response.result.duplicate {
            isEmailVerified = true
            emailSignUpView.duplicateCheckLabel.text = "사용 가능한 이메일입니다"
            emailSignUpView.duplicateCheckLabel.textColor = .green
        } else {
            isEmailVerified = false
            emailSignUpView.duplicateCheckLabel.text = "이미 사용 중인 이메일입니다"
            emailSignUpView.duplicateCheckLabel.textColor = .red
        }
    }
    
    @objc private func signUpButtonTapped() {
        guard let email = emailSignUpView.email,
              let password = emailSignUpView.password else { return }
        
        guard isPasswordValid else {
            showAlert(message: "비밀번호를 확인해주세요")
            return
        }
        
        if !isEmailVerified {
            showErrorMessage("이메일 중복 확인이 필요합니다")
            return
        }
        
        UserSignUpStorage.shared.update { data in
            data.email = email
            data.password = password
            data.socialType = .email
            data.accessToken = nil
        }
        
        let serviceAgreementVC = ServiceAgreementViewController()
        navigationController?.pushViewController(serviceAgreementVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Functions
    
    private func showErrorMessage(_ message: String) {
        emailSignUpView.duplicateCheckLabel.isHidden = false
        emailSignUpView.duplicateCheckLabel.text = message
        emailSignUpView.duplicateCheckLabel.textColor = .red
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

}
