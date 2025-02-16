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
                
                print("📝 SignUp Request Data Check:")
                print("- email: \(signUpData.email ?? "nil")")
                print("- password: \(signUpData.password != nil ? "exists" : "nil")")
                print("- marketingAgree: \(signUpData.marketingAgree ?? false)")
                print("- accountId: \(signUpData.accountId ?? "nil")")
                print("- name: \(signUpData.name ?? "nil")")
                print("- job: \(signUpData.job?.rawValue ?? "nil")")
                print("- reason: \(signUpData.reason?.rawValue ?? "nil")")
                print("- phone: \(signUpData.phone ?? "nil")")
                print("- alarm: \(signUpData.alarm ?? false)")
                print("- contact: \(signUpData.contact?.description ?? "nil")")
                print("- socialType: \(signUpData.socialType?.rawValue ?? "nil")")
                print("- accessToken: \(signUpData.accessToken?.prefix(10) ?? "nil")...")
                
                let request = signUpData.toSignUpRequest()
                let response: SignUpResponse
                
                if signUpData.socialType == .email {
                    response = try await authService.signUp(request: request)
                } else {
                    response = try await authService.socialSignUp(request: request)
                }
                
                if response.isSuccess {
                    UserDefaultsManager.shared.saveUserID(Int(response.result.userID))
                    
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
