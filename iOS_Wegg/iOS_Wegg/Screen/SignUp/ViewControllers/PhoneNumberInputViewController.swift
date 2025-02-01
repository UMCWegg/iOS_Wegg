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
        let phoneNumberVerificationVC = PhoneNumberVerificationViewController()
        navigationController?.pushViewController(phoneNumberVerificationVC, animated: true)
    }
    
}
