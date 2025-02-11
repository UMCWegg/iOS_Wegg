//
//  SignUpViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.27.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpView = SignUpView()
    private var cancellables = Set<AnyCancellable>()
    
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
        GoogleLoginManager.shared.requestSignUp(from: self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Google login failed: \(error)")
                }
            } receiveValue: { email in
                // 회원가입 데이터 저장
                UserSignUpStorage.shared.update { data in
                    data.socialType = .google
                    data.email = email
                    data.oauthID = email
                }
                
                // 서비스 동의 화면으로 이동
                let serviceAgreementVC = ServiceAgreementViewController()
                self.navigationController?.pushViewController(serviceAgreementVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc private func kakaoLoginButtonTapped() {
        KakaoLoginManager.shared.requestSignUp()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Kakao login failed: \(error)")
                }
            } receiveValue: { id in
                // 회원가입 데이터 저장
                UserSignUpStorage.shared.update { data in
                    data.socialType = .kakao
                    data.oauthID = "K\(id)"  // K prefix 추가
                }
                
                // 서비스 동의 화면으로 이동
                let serviceAgreementVC = ServiceAgreementViewController()
                self.navigationController?.pushViewController(serviceAgreementVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc private func emailLoginButtonTapped() {
        UserSignUpStorage.shared.update { data in
            data.socialType = .email
        }
        
        let emailSignUpVC = EmailSignUpViewController()
        navigationController?.pushViewController(emailSignUpVC, animated: true)
    }

}
