//
//  SignUpCompleteViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit

class SignUpCompleteViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpCompleteView = SignUpCompleteView()
    private let authService = AuthService.shared
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = signUpCompleteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        
        if let signUpData = UserSignUpStorage.shared.get() {
            print("⭐️ 저장된 회원가입 데이터:")
            print("이메일: \(signUpData.email ?? "없음")")
            print("이름: \(signUpData.name ?? "없음")")
            print("계정 ID: \(signUpData.accountId ?? "없음")")
            print("직업: \(signUpData.job?.rawValue ?? "없음")")
            print("가입 이유: \(signUpData.reason?.rawValue ?? "없음")")
            print("전화번호: \(signUpData.phone ?? "없음")")
            print("마케팅 동의: \(signUpData.marketingAgree ?? false)")
            print("알림 동의: \(signUpData.alarm ?? false)")
            print("소셜 타입: \(signUpData.socialType?.rawValue ?? "없음")")
            print("액세스 토큰: \(signUpData.accessToken ?? "없음")")
        } else {
            print("❌ 저장된 회원가입 데이터가 없습니다")
        }
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        signUpCompleteView.nextButton.addTarget(self,
                                                action: #selector(nextButtonTapped),
                                                for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func nextButtonTapped() {
        Task {
            do {
                guard let signUpData = UserSignUpStorage.shared.get() else { return }
                let request = signUpData.toSignUpRequest()
                
                let response = try await authService.signUp(request: request)
                if response.isSuccess {
                    let mainTabBarController = MainTabBarController()
                    navigationController?.setViewControllers([mainTabBarController], animated: true)
                    UserSignUpStorage.shared.clear()
                }
            } catch {
                print("❌ 실패: \(error)")
            }
        }
    }
    
    private func handleSignUpSuccess() {
        let mainTabBarController = MainTabBarController()
        navigationController?.setViewControllers([mainTabBarController], animated: true)
        UserSignUpStorage.shared.clear()
    }
}
