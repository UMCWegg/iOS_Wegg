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
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailSignUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        emailSignUpView.signUpButton.addTarget(self,
                                               action: #selector(signUpButtonTapped),
                                               for: .touchUpInside)
        
        emailSignUpView.backButton.addTarget(self,
                                             action: #selector(backButtonTapped),
                                             for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonTapped() {
        let serviceAgreementVC = ServiceAgreementViewController()
        navigationController?.pushViewController(serviceAgreementVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
