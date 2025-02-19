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
        setupNotifications()
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
        let mainTabBarController = MainTabBarController()
        navigationController?.setViewControllers([mainTabBarController], animated: true)
    }
    
    @objc private func showSignUpAlert(_ notification: Notification) {
        let alert = UIAlertController(
            title: "회원 정보 없음",
            message: "회원 정보가 없습니다. 가입하시겠습니까?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            let signUpVC = SignUpViewController()
            self?.navigationController?.pushViewController(signUpVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Functions
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginSuccess),
            name: NSNotification.Name("LoginSuccess"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showSignUpAlert),
            name: NSNotification.Name("ShowSignUpAlert"),
            object: nil
        )
    }
    
    private func handleSignUpConfirm(_ notification: Notification) {
        if let socialType = notification.userInfo?["socialType"] as? SocialType {
            if socialType == .email {
                let emailSignUpVC = EmailSignUpViewController()
                navigationController?.pushViewController(emailSignUpVC, animated: true)
            } else {
                let serviceAgreementVC = ServiceAgreementViewController()
                navigationController?.pushViewController(serviceAgreementVC, animated: true)
            }
        }
    }
}
