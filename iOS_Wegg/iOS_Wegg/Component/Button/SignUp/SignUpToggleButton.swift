//
//  SignUpRadioButton.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.01.20.
//

import UIKit

import SnapKit
import Then

final class SignUpToggleButton: UIButton {
    
    // MARK: - Init
    
    init(text: String, isChecked: Bool = false) {
        super.init(frame: .zero)
        setupUI()
        setupGesture()
        configure(with: text, isChecked: isChecked)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var isChecked: Bool = false {
        didSet {
            updateCheckButtonState()
        }
    }
    
    private var buttonTapped: ((Bool) -> Void)?
    
    private let checkButton = UIButton().then {
        $0.tintColor = .primary
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
    }
    
    private let checkTitleLabel = UILabel().then {
        $0.font = UIFont.notoSans(.regular, size: 15)
        $0.textColor = .black
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubview(checkButton)
        addSubview(checkTitleLabel)
        
        checkButton.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(15)
        }
        
        checkTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.centerY.trailing.equalToSuperview()
        }
    }
    
    private func setupGesture() {
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func checkButtonTapped() {
        isChecked.toggle()
        buttonTapped?(isChecked)
    }
    
    private func updateCheckButtonState() {
        let imageName = isChecked ? "circle.fill" : "circle"
        checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Public Methods
    
    func configure(with title: String, isChecked: Bool = false) {
        checkTitleLabel.text = title
        self.isChecked = isChecked
    }
    
    func setChecked(_ checked: Bool) {
        isChecked = checked
    }
    
    func getChecked() -> Bool {
        return isChecked
    }
    
    func setOnToggleListener(completion: @escaping (Bool) -> Void) {
        buttonTapped = completion
    }
}
