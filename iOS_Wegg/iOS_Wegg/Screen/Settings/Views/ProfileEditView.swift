//
//  ProfileEditView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.18.
//

import UIKit

import Then
import SnapKit

class ProfileEditView: UIView {
    
    // MARK: - Properties
    
    let cancelButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.brown, for: .normal)
        $0.titleLabel?.font = .notoSans(.regular, size: 16)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = .notoSans(.medium, size: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.brown, for: .normal)
        $0.titleLabel?.font = .notoSans(.regular, size: 16)
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "settings_wegg")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    
    let cameraButton = UIButton().then {
        $0.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        $0.tintColor = .gray
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "이름"
        $0.font = .notoSans(.regular, size: 15)
        $0.textColor = .gray1
    }
    
    let nameTextField = UITextField().then {
        $0.font = .notoSans(.regular, size: 16)
        $0.layer.cornerRadius = 22
        $0.layer.borderColor = UIColor.brown.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "  이름"
    }
    
    private let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.font = .notoSans(.regular, size: 15)
        $0.textColor = .gray1
    }
    
    let idTextField = UITextField().then {
        $0.font = .notoSans(.regular, size: 16)
        $0.layer.cornerRadius = 22
        $0.layer.borderColor = UIColor.brown.cgColor
        $0.layer.borderWidth = 1
        $0.placeholder = "  아이디"
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        [
            cancelButton,
            titleLabel,
            saveButton,
            profileImageView,
            cameraButton,
            nameLabel,
            nameTextField,
            idLabel,
            idTextField
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(96)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.bottom.trailing.equalTo(profileImageView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(34)
            make.leading.equalTo(cancelButton)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton)
            make.trailing.equalTo(saveButton)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.equalTo(cancelButton)
        }
        
        idTextField.snp.makeConstraints { make in
            make.leading.equalTo(cancelButton)
            make.trailing.equalTo(saveButton)
            make.top.equalTo(idLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
    }
}
