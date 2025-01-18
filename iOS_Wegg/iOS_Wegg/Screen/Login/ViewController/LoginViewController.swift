//
//  ViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/7/25.
//

import UIKit

import Then

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var loginView = LoginView().then {
        $0.emailLoginButton.addTarget(
            self,
            action: #selector(emailLoginButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - Functions
    
    @objc private func emailLoginButtonTapped() {
        let emailLoginViewController = EmailLoginViewController()
        navigationController?.pushViewController(emailLoginViewController, animated: true)
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
