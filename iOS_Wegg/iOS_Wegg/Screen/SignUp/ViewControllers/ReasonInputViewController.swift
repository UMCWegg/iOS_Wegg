//
//  ReasonInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class ReasonInputViewController: UIViewController {

    // MARK: - Properties
    
    private let reasonInputView = ReasonInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = reasonInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        
        handlereasonSelection(UserReason.formHabits.displayName)
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        
        reasonInputView.nextButton.addTarget(self,
                                             action: #selector(nextButtonTapped),
                                             for: .touchUpInside)
        
        reasonInputView.backButton.addTarget(self,
                                             action: #selector(backButtonTapped),
                                             for: .touchUpInside)
        
        reasonInputView.passButton.addTarget(self,
                                             action: #selector(passButtonTapped),
                                             for: .touchUpInside)
        
        reasonInputView.reasonDropdown.didSelectOption = { [weak self] selectedOption in
            self?.handlereasonSelection(selectedOption)
        }
    }
    
    // MARK: - Actions
    
    private func handlereasonSelection(_ reason: String) {
        guard let reasonType = UserReason(from: reason) else { return }
        
        UserSignUpStorage.shared.update { data in
            data.reason = reasonType
        }
    }
    
    @objc private func passButtonTapped() {
        // 건너뛰기 시 nil로 설정
        UserSignUpStorage.shared.update { data in
            data.reason = nil
        }
        
        let getAlertPermissionVC = GetAlertPermissionViewController()
        navigationController?.pushViewController(getAlertPermissionVC, animated: true)
    }
    
    @objc private func nextButtonTapped() {
        let getAlertPermissionVC = GetAlertPermissionViewController()
        navigationController?.pushViewController(getAlertPermissionVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
