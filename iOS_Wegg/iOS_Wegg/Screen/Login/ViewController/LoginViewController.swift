//
//  ViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/7/25.
//

import UIKit

import Then

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        loginView.emailLoginButton.addTarget(
            self,
            action: #selector(emailLoginButtonTapped),
            for: .touchUpInside)
        
        loginView.googleLoginButton.addTarget(self,
                                             action: #selector(googleLoginButtonTapped),
                                             for: .touchUpInside)
        
        loginView.kakaoLoginButton.addTarget(self,
                                             action: #selector(kakaoLoginButtonTapped),
                                             for: .touchUpInside)
        
        loginView.emailLoginButton.addTarget(self,
                                             action: #selector(emailLoginButtonTapped),
                                             for: .touchUpInside)
    }
    
    // Navigation 추후 구현
    
    // MARK: - Actions
    
    @objc private func googleLoginButtonTapped() {
        LoginManager.shared.login(type: .google, from: self)
    }
    
    @objc private func kakaoLoginButtonTapped() {
        LoginManager.shared.login(type: .kakao)
    }
    
    @objc private func emailLoginButtonTapped() {
        let emailLoginVC = EmailLoginViewController()
        navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    
}
