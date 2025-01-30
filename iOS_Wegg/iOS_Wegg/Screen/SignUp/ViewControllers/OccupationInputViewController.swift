//
//  OccupationInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class OccupationInputViewController: UIViewController {

    // MARK: - Properties
    
    private let occupationInputView = OccupationInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = occupationInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        occupationInputView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        occupationInputView.occupationDropdown.didSelectOption = { [weak self] selectedOption in
            self?.handleOccupationSelection(selectedOption)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handleOccupationSelection(_ occupation: String) {
        guard let occupationType = UserOccupation(rawValue: occupation) else { return }
        
        switch occupationType {
        case .employee:
            
            break
        case .university:
            
            break
        case .elementary:
            
            break
        case .secondary:
            
            break
        case .unemployed:
            
            break
        case .other:
            
            break
        }
        
    }
    
    private func moveToNextScreen() {
        // 추후 구현 예정
    }

}
