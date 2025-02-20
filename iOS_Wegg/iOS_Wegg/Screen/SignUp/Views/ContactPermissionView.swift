//
//  ContactPermissionView.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit

import Then
import SnapKit

class ContactPermissionView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    let tableView = UITableView().then {
        $0.register(ContactFriendCell.self, forCellReuseIdentifier: "ContactFriendCell")
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }
    
    private let titleLabelLeft = UILabel().then {
        $0.text = "주변 "
        $0.font = UIFont.LoginFont.title
    }
    
    private let appLogo = UIImageView().then {
        $0.image = UIImage(named: "weggy")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabelRight = UILabel().then {
        $0.text = "들을 팔로우 해보세요!"
        $0.font = UIFont.LoginFont.title
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "연락처를 통해 주변에 wegg를 사용하고 있는\n친구들을 찾아볼 수 있어요"
        $0.numberOfLines = 0
        $0.font = UIFont.LoginFont.subTitle
    }
    
    let contentBox = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderColor = UIColor.gray1.cgColor
        $0.layer.cornerCurve = .circular
        $0.isHidden = true
    }
    
    let nextButton = LoginButton(
        style: .textOnly,
        title: "다음",
        backgroundColor: .primary
    )
    
    // MARK: - Setup
    
    private func setupViews() {
        [titleLabelLeft, appLogo, titleLabelRight].forEach { mainStackView.addArrangedSubview($0) }
        
        [
            mainStackView,
            subtitleLabel,
            contentBox,
            nextButton
        ].forEach { addSubview($0) }
        
        contentBox.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupConstraints() {
        appLogo.snp.makeConstraints { make in
            make.width.equalTo(96)
            make.height.equalTo(46)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainStackView)
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        contentBox.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(26)
            make.bottom.equalTo(nextButton.snp.top).offset(-26)
            make.leading.trailing.equalToSuperview().inset(17)
        }
    }
}
