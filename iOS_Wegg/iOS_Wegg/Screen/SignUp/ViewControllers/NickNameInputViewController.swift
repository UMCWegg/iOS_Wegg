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
    private var isDuplicateChecked = false
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = nickNameInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupNameText()
        setupTextField()
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
    
    private func setupTextField() {
        nickNameInputView.nickNameTextField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // 텍스트필드 값이 변경되면 중복 체크 상태 초기화
        isDuplicateChecked = false
    }
    
    @objc private func nextButtonTapped() {
        guard let accountId = nickNameInputView.nickNameTextField.text else { return }
        
        Task {
            do {
                let response = try await authService.checkAccountId(accountId)
                
                if response.result.duplicate {
                    // 중복된 아이디인 경우
                    showDuplicateError()
                } else {
                    // 사용 가능한 아이디인 경우
                    isDuplicateChecked = true
                    proceedToNextScreen(with: accountId)
                }
            } catch {
                print("❌ 아이디 중복 확인 실패: \(error)")
                showAlert(message: "아이디 중복 확인에 실패했습니다")
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    
    private func showDuplicateError() {
        isDuplicateChecked = false
        
        let duplicateLabel = UILabel().then {
            $0.text = "이미 사용 중인 아이디에요"
            $0.font = .notoSans(.regular, size: 13)
            $0.textColor = .red
        }
        
        view.addSubview(duplicateLabel)
        
        duplicateLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.nickNameTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 3초 후 에러 메시지 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            duplicateLabel.removeFromSuperview()
        }
    }
    
    private func proceedToNextScreen(with accountId: String) {
        UserSignUpStorage.shared.update { data in
            data.accountId = accountId
        }
        
        let occupationInputVC = OccupationInputViewController()
        occupationInputVC.nameText = nameText
        navigationController?.pushViewController(occupationInputVC, animated: true)
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
