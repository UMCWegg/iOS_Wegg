//
//  ViewController.swift
//  iOS_Wegg
//
//  Created by jaewon Lee on 1/7/25.
//

import UIKit

import Then

class LoginViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Properties
    
    private let loginView = LoginView()
    
    // MARK: - Functions
    
    @objc private func emailLoginButtonTapped() {
        let emailLoginViewController = EmailLoginViewController()
        navigationController?.pushViewController(emailLoginViewController, animated: true)
    }
    
}
