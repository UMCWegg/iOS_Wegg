//
//  GetAlertPermissionViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class GetAlertPermissionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let getAlertPermissionView = GetAlertPermissionView()
    private var user: BaseUser?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = getAlertPermissionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Functions
    
    private func setupActions() {
        getAlertPermissionView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { [weak self] granted, _ in
            DispatchQueue.main.async {
                UserSignUpStorage.shared.update { data in
                    data.alarm = granted
                }
                self?.nextButtonTapped()
            }
        }
    }
    
    @objc private func nextButtonTapped() {
        let signUpCompleteViewController = SignUpCompleteViewController()
        navigationController?.pushViewController(signUpCompleteViewController, animated: true)
    }
    
}
