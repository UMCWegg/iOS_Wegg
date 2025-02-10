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
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        
        reasonInputView.nextButton.addTarget(self,
                                             action: #selector(nextButtonTapped),
                                             for: .touchUpInside)
        
        reasonInputView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        reasonInputView.reasonDropdown.didSelectOption = { [weak self] selectedOption in
            self?.handlereasonSelection(selectedOption)
        }
    }
    
    // MARK: - Actions
    
    private func handlereasonSelection(_ reason: String) {
        guard let reasonType = UserReason(rawValue: reason) else { return }
        
        UserSignUpStorage.shared.update { data in
            data.reason = reasonType
        }
    }
    
    @objc private func nextButtonTapped() {
        let getAlertPermissionVC = GetAlertPermissionViewController()
        navigationController?.pushViewController(getAlertPermissionVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
