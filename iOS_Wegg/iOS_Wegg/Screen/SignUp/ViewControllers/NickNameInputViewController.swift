//
//  NickNameInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class NickNameInputViewController: UIViewController {

    // MARK: - Properties
    
    var nameText: String?
    private let nickNameInputView = NickNameInputView()
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = nickNameInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupNameText()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        nickNameInputView.nextButton.addTarget(self,
                                           action: #selector(nextButtonTapped),
                                           for: .touchUpInside)
        
        nickNameInputView.backButton.addTarget(self,
                                           action: #selector(backButtonTapped),
                                           for: .touchUpInside)
    }
    
    private func setupNameText() {
        if let nameText = nameText {
            nickNameInputView.nameText = nameText
        }
    }

    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        guard let accountId = nickNameInputView.nickNameTextField.text else { return }
        
        Task {
            do {
                let response: BaseResponse<IDCheckResult>
                = try await authService.checkAccountId(accountId)
                await MainActor.run {
                    handleValidationResponse(response.result)
                }
            } catch {
                print("❌ 아이디 검증 실패: \(error)")
                showAlert(message: "아이디 검증에 실패했습니다")
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    private func handleValidationResponse(_ result: IDCheckResult) {
        // 결과 메시지 표시
        showValidationMessage(result.message, isValid: result.valid)
        
        // 유효한 경우 다음 화면으로 이동
        if result.valid {
            UserSignUpStorage.shared.update { data in
                data.accountId = nickNameInputView.nickNameTextField.text
            }
            
            let occupationInputVC = OccupationInputViewController()
            occupationInputVC.nameText = nameText
            navigationController?.pushViewController(occupationInputVC, animated: true)
        }
    }
    
    private func showValidationMessage(_ message: String, isValid: Bool) {
        let messageLabel = UILabel().then {
            $0.text = message
            $0.font = .notoSans(.regular, size: 13)
            $0.textColor = isValid ? .green : .red
        }
        
        view.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.nickNameTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 3초 후 메시지 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            messageLabel.removeFromSuperview()
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
}
