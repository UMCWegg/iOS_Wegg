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
            let emailSignUpVC = EmailSignUpViewController()
            self?.navigationController?.pushViewController(emailSignUpVC, animated: true)
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
}
