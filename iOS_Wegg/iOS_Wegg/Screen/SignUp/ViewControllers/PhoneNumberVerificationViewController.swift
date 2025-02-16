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
    
    private func setupSubLabel() {
        if let phoneNumber = phoneNumber {
            phoneNumberVerificationView.phoneNumber = phoneNumber
        }
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
