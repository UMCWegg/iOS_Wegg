//
//  ReasonInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class ReasonInputViewController: UIViewController {

    // MARK: - Properties
    
    private let reasonInputView = ReasonInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = reasonInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        reasonInputView.backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
        
        reasonInputView.reasonDropdown.didSelectOption = { [weak self] selectedOption in
            self?.handlereasonSelection(selectedOption)
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func handlereasonSelection(_ reason: String) {
        guard let reasonType = UserReason(rawValue: reason) else { return }
        
        switch reasonType {
        case .formHabits:
            
            break
        case .followFriends:
            
            break
        case .recordStudy:
            
            break
        case .shareKnowledge:
            
            break
        case .other:
            
            break
        }
        
    }
    
    private func moveToNextScreen() {
        // 추후 구현 예정
    }

}
