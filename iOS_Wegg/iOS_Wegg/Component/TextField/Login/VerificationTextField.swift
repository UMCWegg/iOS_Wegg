//
//  VerificationTextField.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.24.
//

import UIKit

import SnapKit
import Then

class VerificationTextField: UIView {

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextFields()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private var digitTextFields: [UITextField] = []
    var verificationCode: String {
        digitTextFields.map { $0.text ?? "" }.joined()
    }
    
    // MARK: - Setup
    
    private func setupTextFields() {
        for iteratable in 0 ..< 6 {
            let textField = createTextField()
            textField.tag = iteratable
            digitTextFields.append(textField)
            stackView.addArrangedSubview(textField)
        }
        addSubview(stackView)
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.font = UIFont.notoSans(.regular, size: 24)
        textField.delegate = self
        
        let underlineView = UIView().then {
            $0.backgroundColor = UIColor.LoginColor.textFieldColor
        }
        textField.addSubview(underlineView)
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(6)
            make.height.equalTo(1)
            make.width.equalTo(54)
        }
        
        return textField
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}

// MARK: - UITextFieldDelegate

extension VerificationTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let isBackspace = string.isEmpty
       
        if isBackspace {
            textField.text = ""
            if let previousField = digitTextFields[safe: textField.tag - 1] {
                previousField.becomeFirstResponder()
            }
            return false
        }
    
       guard string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
           return false
       }

       textField.text = string
       
       if let nextField = digitTextFields[safe: textField.tag + 1] {
           nextField.becomeFirstResponder()
       } else {
           textField.resignFirstResponder()
       }
       
       return false
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
