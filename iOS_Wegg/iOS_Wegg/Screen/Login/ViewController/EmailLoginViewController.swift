//
//  EmailLoginViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class EmailLoginViewController: UIViewController {

    // MARK: - Properties
    
    private let emailLoginView = EmailLoginView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = emailLoginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        emailLoginView.loginButton.addTarget(self,
                                             action: #selector(emailLoginButtonTapped),
                                             for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func emailLoginButtonTapped() {
        LoginManager.shared.login(type: .email)
    }
}
