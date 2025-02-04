//
//  PhoneNumberVerificationViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class PhoneNumberVerificationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let phoneNumberVerificationView = PhoneNumberVerificationView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = phoneNumberVerificationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
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
    
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        let nameInputVC = NameInputViewController()
        navigationController?.pushViewController(nameInputVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
