//
//  HomeViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    private let homeView = HomeView()
    private let toDoListView = ToDoListView()
    
    // MARK: - Properties
    var todoItems: [ToDoItem] = [] {
        didSet {
            toDoListView.tableView.reloadData()
            toDoListView.updateEmptyState()
            toDoListView.updateTableViewHeight()
        }
    }
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        homeView.scrollView.delegate = self
        homeView.headerView.viewController = self
        
        toDoListView.tableView.delegate = self
        toDoListView.tableView.dataSource = self
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeView.handleScrollViewDidScroll(scrollView)
    }
    
    /// photoAuthButton에 액션 추가
    private func setupActions() {
        homeView.authView.photoAuthButton.addTarget(
            self,
            action: #selector(handlePhotoAuthButtonTap),
            for: .touchUpInside)
    }
    
    /// 버튼을 눌렀을 때 CameraViewController로 이동
    @objc private func handlePhotoAuthButtonTap() {
        let cameraVC = CameraViewController()
        cameraVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cameraVC, animated: true)
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        // ✅ 체크 상태가 변경될 때 todoItems 업데이트
        cell.onToggleDone = { [weak self] in
            self?.todoItems[indexPath.row].isDone.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
    
    // MARK: - ✅ To Do 리스트 선택 이벤트 추가
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = todoItems[indexPath.row]
        print("✅ 선택된 To Do: \(selectedTodo.name)")
        
        // 선택 시 애니메이션 효과
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
