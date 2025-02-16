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
        Task {
            do {
                let (email, token) = try await GoogleLoginManager.shared.requestSignUp(from: self)
                
                UserSignUpStorage.shared.update { data in
                    data.socialType = .google
                    data.email = email
                    data.accessToken = token
                }
                
                let serviceAgreementVC = ServiceAgreementViewController()
                navigationController?.pushViewController(serviceAgreementVC, animated: true)
            } catch {
                print("Google signup failed: \(error)")
            }
        }
    }
    
    @objc private func kakaoLoginButtonTapped() {
        Task {
            do {
                let (id, token) = try await KakaoLoginManager.shared.requestSignUp()
                
                UserSignUpStorage.shared.update { data in
                    data.socialType = .kakao
                    data.email = "K\(id)@daum.net"
                    data.accessToken = token
                }
                
                let serviceAgreementVC = ServiceAgreementViewController()
                navigationController?.pushViewController(serviceAgreementVC, animated: true)
            } catch {
                print("Kakao signup failed: \(error)")
            }
        }
    }
    
    @objc private func emailLoginButtonTapped() {
        let emailSignUpVC = EmailSignUpViewController()
        navigationController?.pushViewController(emailSignUpVC, animated: true)
    }

}
