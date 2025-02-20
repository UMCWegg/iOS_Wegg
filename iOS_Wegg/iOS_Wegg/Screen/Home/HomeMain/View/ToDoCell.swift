//
//  ToDoCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

class ToDoCell: UITableViewCell {

    static let identifier = "ToDoCell"

    // MARK: - UI Components

    private let nameLabel = UILabel().then {
        $0.font = .notoSans(.regular, size: 13)
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    let completeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "emptyTodo"), for: .normal)
        $0.setImage(UIImage(named: "fillTodo"), for: .selected)
    }

    // MARK: - Properties
    var onToggleDone: (() -> Void)?

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupUI() {
        contentView.addSubview(completeButton)
        contentView.addSubview(nameLabel)
        backgroundColor = .yellowWhite
    }

    private func setupLayout() {
        completeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(completeButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }

    private func setupActions() {
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(completeButtonTapped)
        )
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }

    // MARK: - Configure Cell

    func configure(with todo: TodoResult) {
        nameLabel.text = todo.content
        completeButton.isSelected = todo.status == "DONE"
    }

    // MARK: - Actions
    @objc private func completeButtonTapped() {
        completeButton.isSelected.toggle()
        onToggleDone?()
    }
}
