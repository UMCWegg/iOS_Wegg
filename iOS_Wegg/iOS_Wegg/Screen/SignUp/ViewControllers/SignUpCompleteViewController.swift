//
//  SignUpCompleteViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.01.
//

import UIKit
import Combine

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
        let request = signUpData.toSignUpRequest()
        
        AuthService.shared.signUp(with: request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Sign up failed: \(error)")
                }
            } receiveValue: { response in
                // 회원가입 성공 처리
                UserDefaultsManager.shared.saveToken(response.accessToken)
                // 메인 화면으로 이동
                let mainTabBarController = MainTabBarController()
                self.navigationController?
                    .setViewControllers([mainTabBarController], animated: true)
                // 저장된 회원가입 데이터 삭제
                UserSignUpStorage.shared.clear()
            }
            .store(in: &cancellables)
    }

}
