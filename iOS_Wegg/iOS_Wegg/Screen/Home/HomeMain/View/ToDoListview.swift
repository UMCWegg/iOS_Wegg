//
//  ToDoListView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

class ToDoListView: UIView {

    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "TO DO LIST"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .secondary
    }

    let tableView = UITableView().then {
        $0.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        $0.isScrollEnabled = false // 스크롤 비활성화
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 40
    }

    private let addButton = UIButton().then {
        $0.setImage(UIImage(named: "addTodo"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }

    private let emptyStateLabel = UILabel().then {
        $0.text = "할 일이 없습니다. 새로운 할 일을 추가해보세요!"
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.isHidden = true
    }

    // MARK: - Properties
    var todoItems: [ToDoItem] = [] {
        didSet {
            tableView.reloadData()
            updateEmptyState()
            updateTableViewHeight()
        }
    }

    var onTodoSelected: ((ToDoItem) -> Void)?

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
        self.do {
            $0.backgroundColor = .yellowWhite
            $0.layer.cornerRadius = 24
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.secondary.cgColor
        }

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
            ToDoItem(name: "람보르기니 아벤타도르 SVJ 구매"),
            ToDoItem(name: "람보르기니 구매")
        ]
        updateEmptyState()
        updateTableViewHeight()
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(addButton.snp.top).offset(-8)
        }

        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }

        emptyStateLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
            $0.leading.trailing.equalTo(tableView).inset(16)
        }
    }

    // MARK: - Public Methods
    func addTodoItem(text: String) {
        todoItems.append(ToDoItem(name: text))
        updateTableViewHeight()
    }

    func updateEmptyState() {
        emptyStateLabel.isHidden = !todoItems.isEmpty
        tableView.isHidden = todoItems.isEmpty
    }

    func updateTableViewHeight() {
        tableView.reloadData()
        tableView.layoutIfNeeded() // 레이아웃 즉시 업데이트
        let totalHeight = tableView.contentSize.height
        tableView.snp.updateConstraints {
            $0.height.equalTo(totalHeight)
        }
        self.layoutIfNeeded() // 부모 뷰 레이아웃 업데이트
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todoItems[indexPath.row]
        print("✅ 선택된 To Do: \(selectedTodo.name)")

        // 선택 시 애니메이션 효과
        tableView.deselectRow(at: indexPath, animated: true)

        // ✅ 선택한 ToDo에 대한 액션 실행
        onTodoSelected?(selectedTodo)
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
