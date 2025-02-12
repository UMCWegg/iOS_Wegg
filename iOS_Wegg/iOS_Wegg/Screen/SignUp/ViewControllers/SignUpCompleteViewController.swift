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
    private let networkService = NetworkService.shared
    
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
        let request = signUpData.toSignUpRequest()
        
        if let socialType = signUpData.socialType,
           (socialType == .google || socialType == .kakao) {
            networkService.request(.socialSignUp(request))
            { [weak self] (result: Result<SignUpResponse, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.handleSignUpSuccess(response)
                    case .failure(let error):
                        print("Sign up failed:", error)
                    }
                }
            }
        } else {
            networkService.request(.signUp(request))
            { [weak self] (result: Result<SignUpResponse, NetworkError>) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.handleSignUpSuccess(response)
                    case .failure(let error):
                        print("Sign up failed:", error)
                    }
                }
            }
        }
    }
    
    private func handleSignUpSuccess(_ response: SignUpResponse) {
        UserDefaultsManager.shared.saveToken(response.accessToken)
        let mainTabBarController = MainTabBarController()
        navigationController?.setViewControllers([mainTabBarController], animated: true)
        UserSignUpStorage.shared.clear()
    }
}
