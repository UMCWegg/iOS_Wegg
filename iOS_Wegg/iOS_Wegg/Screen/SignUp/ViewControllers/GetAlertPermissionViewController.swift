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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MAKR: - Functions
    
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
                if granted {
                    self?.handlePermissionGranted()
                } else {
                    self?.handlePermissionDenied()
                }
                self?.navigateToNextScreen()
            }
        }
    }
    
    private func handlePermissionGranted() {
        UserDefaults.standard.set(true, forKey: "notificationEnabled")
        updateUserAlertStatus(enabled: true)
    }
    
    private func handlePermissionDenied() {
        UserDefaults.standard.set(false, forKey: "notificationEnabled")
        updateUserAlertStatus(enabled: false)
    }
    
    private func updateUserAlertStatus(enabled: Bool) {
    }
    
    private func navigateToNextScreen() {
        let signUpCompleteViewController = SignUpCompleteViewController()
        navigationController?.pushViewController(signUpCompleteViewController, animated: true)
    }
    
    @objc private func nextButtonTapped() {
        requestNotificationPermission()
    }
    
}
