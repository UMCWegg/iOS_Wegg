//
//  EmailLoginViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class EmailLoginViewController: UIViewController {

    // MARK: - Properties
    
    private let emailLoginView = EmailLoginView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailLoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        emailLoginView.loginButton.addTarget(self,
                                             action: #selector(emailLoginButtonTapped),
                                             for: .touchUpInside)
        
        emailLoginView.backButton.addTarget(self,
                                            action: #selector(backButtonTapped),
                                            for: .touchUpInside)
        
        emailLoginView.findPasswordButton.addTarget(self,
                                                    action: #selector(findPasswordButtonTapped),
                                                    for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func emailLoginButtonTapped() {
        guard let email = emailLoginView.email,
              let password = emailLoginView.password else { return }
        
        Task {
            await LoginManager.shared.login(type: .email,
                                          email: email,
                                          password: password)
        }
    }
    
    @objc private func findPasswordButtonTapped() {
        let passwordResetEmailVC = PasswordResetEmailViewController()
        navigationController?.pushViewController(passwordResetEmailVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
