//
//  ServiceAgreementViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.20.
//

import UIKit

class ServiceAgreementViewController: UIViewController {

    // MARK: - Properties
    
    private let serviceAgreementView = ServiceAggrementView()
    private var isMarketingAgreed: Bool = false
    private lazy var toggleButtons: [SignUpToggleButton] = [
        serviceAgreementView.serviceToggleButton,
        serviceAgreementView.privacyToggleButton,
        serviceAgreementView.locationToggleButton,
        serviceAgreementView.marketingToggleButton
    ]
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = serviceAgreementView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        updateNextButtonState()
    }
    
    // MARK: - Setup
    
    private func setupButtons() {
        serviceAgreementView.agreeAllToggleButton.setOnToggleListener { [weak self] isChecked in
            self?.handleAllAgreementToggle(isChecked)
            
        }
        
        toggleButtons.forEach { button in
            button.setOnToggleListener { [weak self] _ in
                self?.updateAgreementState()
                if button == self?.serviceAgreementView.marketingToggleButton {
                    self?.isMarketingAgreed = button.getChecked()
                }
            }
        }
        
        serviceAgreementView.nextButton.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )
        
        serviceAgreementView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }
    
    // MARK: - Functions
    
    private func handleAllAgreementToggle(_ isChecked: Bool) {
        toggleButtons.forEach { $0.setChecked(isChecked) }
        updateNextButtonState()
    }
    
    private func updateAgreementState() {
        let allChecked = toggleButtons.allSatisfy { $0.getChecked() }
        serviceAgreementView.agreeAllToggleButton.setChecked(allChecked)
        updateNextButtonState()
    }
    
    private func checkAllAgreement() {
        let allChecked = toggleButtons.allSatisfy { $0.getChecked() }
        serviceAgreementView.agreeAllToggleButton.setChecked(allChecked)
    }
    
    private func updateNextButtonState() {
        let requiredButtons = toggleButtons[0...2]
        let isEnabled = requiredButtons.allSatisfy { $0.getChecked() }
        
        serviceAgreementView.nextButton.alpha = isEnabled ? 1.0 : 0.3
        serviceAgreementView.nextButton.isEnabled = isEnabled
        
        checkAllAgreement()
    }
    
    @objc private func nextButtonTapped() {
        UserSignUpStorage.shared.update { data in
            data.marketingAgree = serviceAgreementView.marketingToggleButton.getChecked()
        }
        
        let phoneNumberInputVC = PhoneNumberInputViewController()
        navigationController?.pushViewController(phoneNumberInputVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
