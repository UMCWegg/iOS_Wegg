//
//  ToDoCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/30/25.
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
    }

    private let doneButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "emptyTodo"), for: .normal)
        $0.setImage(UIImage(named: "fillTodo"), for: .selected)
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    // MARK: - Properties
    private var todoItem: TodoResponse.TodoResult?
    var onToggleDone: (() -> Void)?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(doneButton)

        backgroundColor = .yellowWhite

        doneButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(doneButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doneButtonTapped))
        contentView.addGestureRecognizer(tapGesture)
        contentView.isUserInteractionEnabled = true
    }

    // MARK: - Configuration
    func configure(with todo: TodoResponse.TodoResult) {
        self.todoItem = todo
        nameLabel.text = todo.content
        doneButton.isSelected = todo.status == "DONE"
    }

    // MARK: - Actions
    @objc private func doneButtonTapped() {
        guard let item = todoItem else { return }
        let newStatus = doneButton.isSelected ? "YET" : "DONE"
        let updatedRequest = TodoRequest(status: newStatus, content: item.content)

        doneButton.isSelected.toggle()
        onToggleDone?()
    }
}
