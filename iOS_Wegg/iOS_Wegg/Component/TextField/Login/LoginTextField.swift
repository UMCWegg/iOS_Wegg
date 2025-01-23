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
        backgroundColor = .white
        font = UIFont(name: "NotoSansKR-Regular", size: 13)
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.71, green: 0.71, blue: 0.71, alpha: 1).cgColor
        
        autocapitalizationType = .none
        autocorrectionType = .no
        heightAnchor.constraint(equalToConstant: 44).isActive = true

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
