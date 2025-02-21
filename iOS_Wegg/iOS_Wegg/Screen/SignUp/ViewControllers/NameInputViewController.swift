//
//  NameInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.30.
//

import UIKit

class NameInputViewController: UIViewController {

    // MARK: - Properties
    
    private let nameInputView = NameInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = nameInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        addKeyboardDismissGesture()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        nameInputView.nextButton.addTarget(self,
                                           action: #selector(nextButtonTapped),
                                           for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        guard let name = nameInputView.nameTextField.text else { return }
        
        UserSignUpStorage.shared.update { data in
            data.name = name
        }
        
        let nickNameInputVC = NickNameInputViewController()
        nickNameInputVC.nameText = name
        navigationController?.pushViewController(nickNameInputVC, animated: true)
    }
    
}
