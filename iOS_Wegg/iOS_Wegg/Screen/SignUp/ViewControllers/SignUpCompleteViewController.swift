//
//  SignUpCompleteViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit

import Moya

class SignUpCompleteViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpCompleteView = SignUpCompleteView()
    private let apiManager = APIManager()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = signUpCompleteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        signUpCompleteView.nextButton.addTarget(self,
                                                action: #selector(nextButtonTapped),
                                                for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        guard let signUpData = UserSignUpStorage.shared.get() else { return }
        
        if let socialType = signUpData.socialType,
           (socialType == .google || socialType == .kakao) {
            // 소셜 회원가입
            let socialRequest = SocialSignUpRequest(
                oauthId: signUpData.oauthID ?? "",
                type: socialType,
                name: signUpData.name ?? "",
                accountId: signUpData.nickname ?? "",
                marketingAgree: signUpData.marketingAgreed ?? false,
                phone: signUpData.phoneNumber ?? "",
                alarm: signUpData.alert ?? false,
                job: (signUpData.occupation ?? .employee).rawValue,
                reason: (signUpData.reason ?? .formHabits).rawValue,
                contact: signUpData.contact?.map { Contact(phone: $0.phone) } ?? []
            )
            
            NetworkService.shared.request(.socialSignUp(socialRequest))
            { [weak self] (result: Result<SignUpResponse, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.isSuccess {
                            self?.handleSignUpSuccess()
                        } else {
                            print("Social sign up failed:", response.message)
                            // 에러 처리 (alert 등)
                        }
                    case .failure(let error):
                        print("Social sign up error:", error)
                        // 에러 처리 (alert 등)
                    }
                }
            }
        } else {
            // 일반 회원가입
            let request = signUpData.toSignUpRequest()
            NetworkService.shared.request(.signUp(request))
            { [weak self] (result: Result<SignUpResponse, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if response.isSuccess {
                            self?.handleSignUpSuccess()
                        } else {
                            print("Sign up failed:", response.message)
                            // 에러 처리 (alert 등)
                        }
                    case .failure(let error):
                        print("Sign up error:", error)
                        // 에러 처리 (alert 등)
                    }
                }
            }
        }
    }

    private func handleSignUpSuccess() {
        let mainTabBarController = MainTabBarController()
        navigationController?.setViewControllers([mainTabBarController], animated: true)
        UserSignUpStorage.shared.clear()
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "회원가입 실패",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "확인",
            style: .default
        ))
        
        present(alert, animated: true)
    }
}
