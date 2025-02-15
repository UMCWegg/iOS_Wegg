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
