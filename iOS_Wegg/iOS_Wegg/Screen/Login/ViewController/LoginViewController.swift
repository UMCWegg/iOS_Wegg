//
//  ViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/7/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    private let loginManager = LoginManager.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupActions()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccess),
            name: NSNotification.Name("LoginSuccess"),
            object: nil
        )
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        loginView.googleLoginButton.addTarget(self,
                                             action: #selector(googleLoginButtonTapped),
                                             for: .touchUpInside)
        
        loginView.kakaoLoginButton.addTarget(self,
                                             action: #selector(kakaoLoginButtonTapped),
                                             for: .touchUpInside)
        
        loginView.emailLoginButton.addTarget(self,
                                             action: #selector(emailLoginButtonTapped),
                                             for: .touchUpInside)
        
        loginView.signUpButton.addTarget(self,
                                         action: #selector(signUpButtonTapped),
                                         for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func googleLoginButtonTapped() {
        Task {
            await LoginManager.shared.login(type: .google, from: self)
        }
    }
    
    @objc private func kakaoLoginButtonTapped() {
        Task {
            await LoginManager.shared.login(type: .kakao)
        }
    }
    
    @objc private func emailLoginButtonTapped() {
        print("Email Login Button Tapped")
        let emailLoginVC = EmailLoginViewController()
        navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        print("Sign Up Button Tapped")
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    @objc private func handleLoginSuccess() {
        print("Login Success!")
    }
}
