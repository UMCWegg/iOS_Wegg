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
        
        Task {
            do {
                let request = signUpData.toSignUpRequest()
                let response = try await AuthService.shared.signUp(with: request)
                if response.isSuccess {
                    await MainActor.run {
                        handleSignUpSuccess()
                    }
                }
            } catch {
                print("Sign up error: \(error)")
                await MainActor.run {
                    showError(error.localizedDescription)
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
