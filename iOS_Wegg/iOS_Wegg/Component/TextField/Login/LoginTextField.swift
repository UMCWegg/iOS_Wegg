//
//  LoginTextField.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.18.
//

import UIKit

class LoginTextField: UITextField {

    // MARK: - Init
    
    init(placeholder: String, type: TextFieldType = .normal) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        setupTextField(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Types
    
    enum TextFieldType {
        case normal
        case email
        case password
    }
    
    // MARK: - Setup
    
    private func setupTextField(type: TextFieldType) {
        backgroundColor = UIColor(named: "Login/TextField")
        font = UIFont(name: "NotoSansKR-Regular", size: 13)
        autocapitalizationType = .none
        autocorrectionType = .no
        heightAnchor.constraint(equalToConstant: 43).isActive = true

        switch type {
        case .normal:
            break
        case .email:
            keyboardType = .emailAddress
        case .password:
            isSecureTextEntry = true
        }
    }

}
