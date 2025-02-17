//
//  ToDoListView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

protocol ToDoListViewDelegate: AnyObject {
    func didAddToDoItem(text: String)
    func didUpdateToDoItem(at index: Int, with text: String)
}

extension UIAlertController {
    func styleAlert() {
        guard let subView = self.view.subviews.first,
              let alertContentView = subView.subviews.first else {
            print("Alert view structure is 다릅니다")
            return
        }
        
        alertContentView.backgroundColor = .primary
        alertContentView.layer.cornerRadius = 12
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = UIColor.secondary.cgColor
        
        // Title 스타일 변경
        if let title = self.title {
            let attributedString = NSAttributedString(string: title, attributes: [
                .font: UIFont.notoSans(.bold, size: 16),
                .foregroundColor: UIColor.black
            ])
            self.setValue(attributedString, forKey: "attributedTitle")
        }
        
        // Message 스타일 변경
        if let message = self.message {
            let attributedString = NSAttributedString(string: message, attributes: [
                .font: UIFont.notoSans(.regular, size: 14),
                .foregroundColor: UIColor.darkGray
            ])
            self.setValue(attributedString, forKey: "attributedMessage")
        }
    }
}

class ToDoListView: UIView {

    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.text = "TO DO LIST"
        $0.font = .notoSans(.bold, size: 13)
        $0.textColor = .secondary
    }

    let tableView = UITableView().then {
        $0.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.identifier)
        $0.isScrollEnabled = false
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
        $0.text = "새로운 할 일을 추가해보세요!"
        $0.font = .notoSans(.regular, size: 13)
        $0.textAlignment = .center
        $0.textColor = .gray
        $0.isHidden = true
    }

    // MARK: - Properties
    var todoItems: [TodoResult] = [] {
        didSet {
            updateEmptyState()
            updateTableViewHeight()
            tableView.reloadData()
        }
    }

    private let todoService = TodoService()
    weak var delegate: ToDoListViewDelegate?

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

    private func setupActions() {
        addButton.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
    }

    // MARK: - Public Methods
    func addTodoItem(_ item: TodoResult) {
        tableView.performBatchUpdates({
            self.todoItems.append(item)
            let indexPath = IndexPath(row: self.todoItems.count - 1, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }, completion: { _ in
            self.updateEmptyState()
            self.updateTableViewHeight()
        })
    }
    
    func reloadTableView() {
        tableView.reloadData()
        updateTableViewHeight()
        updateEmptyState()
    }
    
    func updateTodoContent(at index: Int, with newTodo: TodoResult) {
        guard index >= 0 && index < todoItems.count else { return }
        todoItems[index] = newTodo
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func updateEmptyState() {
        emptyStateLabel.isHidden = !todoItems.isEmpty
        tableView.isHidden = todoItems.isEmpty
    }

    func updateTableViewHeight() {
        tableView.reloadData()
        let height = tableView.contentSize.height
        tableView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }

    // MARK: - Actions
    @objc private func addTodoButtonTapped() {
        showAddTodoAlert()
    }

    // MARK: - API: 투두 추가
    private func showAddTodoAlert() {
        let alert = UIAlertController(
            title: "새로운 할 일",
            message: "할 일을 입력하세요.",
            preferredStyle: .alert
        )
        alert.styleAlert()

        alert.addTextField { textField in
            textField.placeholder = "할 일 내용"
            textField.font = .notoSans(.regular, size: 14)
            textField.backgroundColor = .white
        }

        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            let request = TodoRequest(status: "YET", content: text)
            Task {
                let result = await self?.todoService.addTodo(request)
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.addTodoItem(response)
                        print("✅ Todo 등록 성공: \(response.content)")
                    }
                case .failure(let error):
                    print("❌ Todo 등록 실패: \(error)")
                case .none:
                    print("⚠️ Todo 등록 실패: 결과 없음")
                }
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        findViewController()?.present(alert, animated: true)
    }

    // MARK: - API: 투두 수정
    private func showEditTodoAlert(at indexPath: IndexPath) {
        let alert = UIAlertController(
            title: "할 일 수정",
            message: "할 일을 수정하세요.",
            preferredStyle: .alert
        )
        alert.styleAlert()

        alert.addTextField { textField in
            textField.text = self.todoItems[indexPath.row].content
            textField.font = .notoSans(.regular, size: 14)
            textField.backgroundColor = .white
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }

        let saveAction = UIAlertAction(title: "저장", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first,
                  let text = textField.text, !text.isEmpty else { return }
            let oldTodo = self?.todoItems[indexPath.row]
            guard let todoId = oldTodo?.todoId else { return }
            let request = TodoUpdateRequest(status: oldTodo?.status ?? "YET", content: text)

            Task {
                let result = await self?.todoService.updateTodo(todoId: todoId, request: request)
                switch result {
                case .success(let updatedTodo):
                    DispatchQueue.main.async {
                        self?.todoItems[indexPath.row] = updatedTodo
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                        print("✅ Todo 수정 성공: \(updatedTodo.content)")
                    }
                case .failure(let error):
                    print("❌ Todo 수정 실패: \(error)")
                case .none:
                    print("⚠️ Todo 수정 실패: 결과 없음")
                }
            }
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        findViewController()?.present(alert, animated: true)
    }

    // MARK: - Helper Methods
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
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
        let todo = todoItems[indexPath.row]
        cell.configure(with: todo)

        // ✅ 투두 완료 상태 변경
        cell.onToggleDone = { [weak self] in
            guard let self = self else { return }
            let newStatus = todo.status == "YET" ? "DONE" : "YET"
            let request = TodoCheckRequest(status: newStatus)
            
            Task {
                let result = await self.todoService.checkTodo(todoId: todo.todoId, request: request)
                switch result {
                case .success(let updatedTodo):
                    DispatchQueue.main.async {
                        self.todoItems[indexPath.row] = updatedTodo
                        self.tableView.reloadData()
                        self.updateTableViewHeight()
                        
                        // ✅ 투두 달성률 및 텍스트 즉시 업데이트
                        let completedCount = self.todoItems.filter { $0.status == "DONE" }.count
                        let totalCount = self.todoItems.count
                        let achievement =
                        totalCount == 0 ? 0 : Double(completedCount) / Double(totalCount) * 100
                        
                        // SwipeView 업데이트
                        if let homeVC = self.findViewController() as? HomeViewController {
                            homeVC.homeView.swipeView.updateAchievement(achievement)
                            homeVC.homeView.swipeView.updateTodoCount(
                                completed: completedCount, total: totalCount
                            )
                        }
                    }
                case .failure(let error):
                    print("❌ Todo 상태 변경 실패: \(error)")
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showEditTodoAlert(at: indexPath)
    }

    // ✅ 투두 삭제
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "삭제"
        ) { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            let todoId = self.todoItems[indexPath.row].todoId

            Task {
                let result = await self.todoService.deleteTodo(todoId: todoId)
                switch result {
                case .success(let deletedTodo):
                    DispatchQueue.main.async {
                        // 1. 테이블 뷰 동기화
                        self.tableView.performBatchUpdates {
                            // 2. 데이터 소스 배열에서 항목 삭제
                            self.todoItems.remove(at: indexPath.row)

                            // 3. 해당 행 삭제
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        } completion: { _ in
                            // 4. 테이블 뷰 높이 업데이트
                            self.updateTableViewHeight()

                            // 5. 상태 업데이트
                            self.updateEmptyState()

                            print("✅ Todo 삭제 성공: \(deletedTodo.message)")
                        }
                    }
                case .failure(let error):
                    print("❌ Todo 삭제 실패: \(error)")
                }
            }
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
