//
//  ToDoListView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit

class ToDoListView: UIView {

    // MARK: - Properties
    private var todoItems: [ToDoItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
        }
    }

    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TO DO LIST"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 162/255, green: 131/255, blue: 106/255, alpha: 1.0)
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addTodo"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "할 일이 없습니다. 새로운 할 일을 추가해보세요!"
        label.textAlignment = .center
        label.textColor = .gray
        label.isHidden = true
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupUI() {
        backgroundColor = UIColor(red: 255/255, green: 253/255, blue: 249/255, alpha: 1.0)
        layer.cornerRadius = 24
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 162/255, green: 131/255, blue: 106/255, alpha: 1.0).cgColor

        tableView.delegate = self
        tableView.dataSource = self

        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(addButton)
        addSubview(emptyStateLabel)

        // Dummy Data
        todoItems = [
            ToDoItem(name: "강남 KKM빌딩 건설"),
            ToDoItem(name: "부가티 시론 구매"),
            ToDoItem(name: "람보르기니 아벤타도르 SVJ 구매")
        ]
        updateEmptyState()
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addButton.snp.top).offset(-16)
        }

        addButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalTo(tableView).inset(16)
        }
    }

    // MARK: - Public Methods
    func addTodoItem(text: String) {
        todoItems.append(ToDoItem(name: text))
    }

    private func updateEmptyState() {
        emptyStateLabel.isHidden = !todoItems.isEmpty
        tableView.isHidden = todoItems.isEmpty
    }

    private func setupActions() {
        addButton.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
    }

    @objc private func addTodoButtonTapped() {
        print("TO DO LIST 추가 버튼 터치 ✅")
        addTodoItem(text: "새로운 할 일 추가됨")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ToDoListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ToDoCell.identifier,
            for: indexPath
        ) as? ToDoCell else {
            return UITableViewCell()
        }
        cell.configure(with: todoItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 40
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { [weak self] (_, _, completionHandler) in
            self?.todoItems.remove(at: indexPath.row)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
