//
//  NickNameInputViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.31.
//

import UIKit

class NickNameInputViewController: UIViewController {

    // MARK: - Properties
    
    var nameText: String?
    private let nickNameInputView = NickNameInputView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = nickNameInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupNameText()
    }
    
    // MARK: - Setup
    
    private func setupActions() {
        nickNameInputView.nextButton.addTarget(self,
                                           action: #selector(nextButtonTapped),
                                           for: .touchUpInside)
    }
    
    private func setupNameText() {
        if let nameText = nameText {
            nickNameInputView.nameText = nameText
        }
    }
    
    // MARK: - Actions
    
    @objc private func nextButtonTapped() {
        guard let nickName = nickNameInputView.nickNameTextField.text else { return }
        
        UserSignUpStorage.shared.update { data in
            data.accountId = nickName
        }
        
        let occupationInputVC = OccupationInputViewController()
        occupationInputVC.nameText = nameText
        navigationController?.pushViewController(occupationInputVC, animated: true)
    }
    
}
