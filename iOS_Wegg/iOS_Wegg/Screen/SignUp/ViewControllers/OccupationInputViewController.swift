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
        
        occupationInputView.nextButton.addTarget(self,
                                                 action: #selector(nextButtonTapped),
                                                 for: .touchUpInside)
        
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
    
    private func handleOccupationSelection(_ occupation: String) {
        guard let occupationType = UserOccupation(rawValue: occupation) else { return }
        
        UserSignUpStorage.shared.update { data in
            data.occupation = occupationType
        }
    }
    
    @objc private func nextButtonTapped() {
        let reasonInputVC = ReasonInputViewController()
        navigationController?.pushViewController(reasonInputVC, animated: true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

}
