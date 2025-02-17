//
//  HomeViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, ToDoListViewDelegate {
    private let homeView = HomeView()
    private let todoService = TodoService()
    private let apiManager = APIManager()
    
    override func loadView() {
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupActions()
        homeView.scrollView.delegate = self
        
        homeView.headerView.viewController = self
        homeView.headerView.updateHeaderMode(isHomeMode: true)
        
        apiManager.setCookie(value: "9B054ED826CCEE55F59353174E0A4755")
        print("[HomeVC] JSESSIONID 쿠키 설정 완료")
        
        // 투두 리스트 불러오기
        fetchTodoList()
    }
    
    // MARK: - 투두 리스트 불러오기
    private func fetchTodoList() {
        Task {
            let result = await todoService.getTodoList()
            switch result {
            case .success(let todos):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.todoItems = todos
                    self.homeView.toDoListView.reloadTableView()
                    print("✅ 투두 리스트 불러오기 성공: \(todos.count)개 항목")
                }
            case .failure(let error):
                print("❌ 투두 리스트 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeView.handleScrollViewDidScroll(scrollView)
    }
    
    // MARK: - ToDoListViewDelegate
    func didAddToDoItem(text: String) {
        let request = TodoRequest(status: "YET", content: text)
        Task {
            let result = await todoService.addTodo(request)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.addTodoItem(response)
                }
                print("✅ 투두 등록 성공: \(response.content)")
            case .failure(let error):
                print("❌ 투두 등록 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func didUpdateToDoItem(at index: Int, with text: String) {
        let todoId = homeView.toDoListView.todoItems[index].todoId
        let request = TodoUpdateRequest(status: "YET", content: text)
        
        Task {
            let result = await todoService.updateTodo(todoId: todoId, request: request)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.updateTodoContent(at: index, with: response)
                }
                print("✅ 투두 수정 성공: \(response.content)")
            case .failure(let error):
                print("❌ 투두 수정 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// 사진 인증 버튼 액션 추가
    private func setupActions() {
        homeView.authView.photoAuthButton.addTarget(
            self,
            action: #selector(photoAuthTapped),
            for: .touchUpInside
        )
    }
    
    /// 사진 인증 버튼을 눌렀을 때 `CameraViewController`로 이동
    @objc private func photoAuthTapped() {
        let cameraVC = CameraViewController()
        cameraVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cameraVC, animated: true)
    }
}
