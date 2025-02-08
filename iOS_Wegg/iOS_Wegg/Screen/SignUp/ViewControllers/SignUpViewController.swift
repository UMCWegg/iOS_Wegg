//
//  SignUpViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpView = SignUpView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customColor(.primary)
        setupActions()
    }
    
    private func setupActions() {
        signUpView.googleLoginButton.addTarget(self,
                                             action: #selector(googleLoginButtonTapped),
                                             for: .touchUpInside)
        
        signUpView.kakaoLoginButton.addTarget(self,
                                             action: #selector(kakaoLoginButtonTapped),
                                             for: .touchUpInside)
        
        signUpView.emailLoginButton.addTarget(self,
                                             action: #selector(emailLoginButtonTapped),
                                             for: .touchUpInside)
    }
    
    @objc private func googleLoginButtonTapped() {
        LoginManager.shared.login(type: .google, from: self)
    }
    
    @objc private func kakaoLoginButtonTapped() {
        LoginManager.shared.login(type: .kakao)
    }
    
    @objc private func emailLoginButtonTapped() {
        let emailSignUpVC = EmailSignUpViewController()
        navigationController?.pushViewController(emailSignUpVC, animated: true)
    }

}
