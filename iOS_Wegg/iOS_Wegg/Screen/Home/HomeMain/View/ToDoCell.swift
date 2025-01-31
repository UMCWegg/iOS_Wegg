//
//  ToDoCell.swift
//  iOS_Wegg
//
//  Created by KKM on 1/30/25.
//

import UIKit

// MARK: - ToDoItem Model
struct ToDoItem {
    let id: UUID
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isDone = isDone
    }
}

class ToDoCell: UITableViewCell {
    
    static let identifier = "ToDoCell"
    
    // MARK: - UI Components
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "emptyTodo"), for: .normal)
        button.setImage(UIImage(named: "fillTodo"), for: .selected)
        return button
    }()
    
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            doneButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 24),
            doneButton.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: doneButton.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with todo: ToDoItem) {
        nameLabel.text = todo.name
        doneButton.isSelected = todo.isDone
    }
}
