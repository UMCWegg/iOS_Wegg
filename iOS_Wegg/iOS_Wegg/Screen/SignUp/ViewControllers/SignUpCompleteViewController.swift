//
//  SignUpCompleteViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit
import Combine

import Moya

class SignUpCompleteViewController: UIViewController {

    // MARK: - Properties
    
    private let signUpCompleteView = SignUpCompleteView()
    private var cancellables = Set<AnyCancellable>()
    
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
            let request = signUpData.toSignUpRequest()
            
            AuthService.shared.socialSignUp(request: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Sign up failed: \(error)")
                    if let moyaError = error as? MoyaError {
                        switch moyaError {
                        case .underlying(let error, let response):
                            print("Underlying error: \(error)")
                            if let response = response {
                                print("Status code: \(response.statusCode)")
                                if let responseString = String(data: response.data,
                                                               encoding: .utf8) {
                                    print("Response body: \(responseString)")
                                }
                            }
                        case .statusCode(let response):
                            print("Status code: \(response.statusCode)")
                            if let responseString = String(data: response.data, encoding: .utf8) {
                                print("Response body: \(responseString)")
                            }
                        default:
                            print("Other Moya error: \(moyaError)")
                        }
                    }
                }
            } receiveValue: { response in
                UserDefaultsManager.shared.saveToken(response.accessToken)
                let mainTabBarController = MainTabBarController()
                self.navigationController?
                    .setViewControllers([mainTabBarController], animated: true)
                UserSignUpStorage.shared.clear()
            }
            .store(in: &cancellables)
        } else {
            // 일반 회원가입
            let request = signUpData.toSignUpRequest()
            
            AuthService.shared.signUp(with: request)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Sign up failed: \(error)")
                        if let moyaError = error as? MoyaError {
                            print("Detailed error:", moyaError)
                        }
                    }
                } receiveValue: { response in
                    UserDefaultsManager.shared.saveToken(response.accessToken)
                    let mainTabBarController = MainTabBarController()
                    self.navigationController?
                        .setViewControllers([mainTabBarController], animated: true)
                    UserSignUpStorage.shared.clear()
                }
                .store(in: &cancellables)
        }
    }
}
