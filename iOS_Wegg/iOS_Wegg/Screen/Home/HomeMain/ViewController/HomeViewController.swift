//
//  HomeViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate, ToDoListViewDelegate {

    let homeView = HomeView()
    private let apiManager = APIManager()
    private let todoService = TodoService()
    private var timer: Timer?
    private var planId: Int? // 장소 인증시 필요 - 작성자: 이재원

    override func loadView() {
        self.view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primary
        setupActions()
        homeView.scrollView.delegate = self
        homeView.toDoListView.delegate = self
        homeView.headerView.viewController = self
        homeView.headerView.updateHeaderMode(isHomeMode: true)
        loadWeeklyData()
        startTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeView.handleScrollViewDidScroll(scrollView)
    }

    // MARK: - Timer Management

    private func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 20.0,
            target: self,
            selector: #selector(loadWeeklyData),
            userInfo: nil,
            repeats: true
        )
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - API 연동 및 데이터 로드

    @objc func loadWeeklyData() {
        print("🔄 loadWeeklyData() 렌더링 시작") // 렌더링 시작 로그
        Task {
            do {
                let weeklyRenderResponse: WeeklyRenderResponse = try await apiManager.request(
                    target: WeeklyResponseAPI.getWeeklyRender
                )
                
                // API 응답 로그 출력
                print("✅ API 응답: \(weeklyRenderResponse)")
                planId = weeklyRenderResponse.result.planId

                // 🥚 WeeklyEggView 업데이트
                DispatchQueue.main.async {
                    self.homeView.weeklyEggView.updateWeeklyData(
                        weeklyData: weeklyRenderResponse.result.weeklyData
                    )

                    // 🔄 SwipeView 업데이트
                    self.updateSwipeView(
                        totalTodos: weeklyRenderResponse.result.totalTodos,
                        completedTodos: weeklyRenderResponse.result.completedTodos,
                        completionRate: weeklyRenderResponse.result.completionRate,
                        successCount: weeklyRenderResponse.result.successCount,
                        availablePoints: weeklyRenderResponse.result.availablePoints,
                        canReceivePoints: weeklyRenderResponse.result.canReceivePoints
                    )

                    // 🗓️ ToDoListView 업데이트
                    self.homeView.toDoListView.todoItems =
                        weeklyRenderResponse.result.todayTodos.map {
                            TodoResult(
                                todoId: $0.todoId,
                                content: $0.content,
                                status: $0.status,
                                createdAt: $0.createdAt
                            )
                        }
                    self.homeView.toDoListView.tableView.reloadData() // ToDoListView 갱신

                    // ✅ 📍 AuthView 업데이트
                    self.updateAuthView(address: weeklyRenderResponse.result.upcomingPlanAddress)

                    print("✅ loadWeeklyData() 렌더링 완료") // 렌더링 완료 로그
                }
            } catch {
                print("❌ loadWeeklyData() 렌더링 중 오류 발생: \(error)") // 렌더링 중 오류 로그
            }
        }
    }

    // MARK: - AuthView 업데이트

    private func updateAuthView(address: String?) {
        DispatchQueue.main.async {
            self.homeView.authView.updateLocationInfo(with: address)
            self.homeView.updateAuthViewVisibility(with: address)
        }
    }

    // MARK: - ToDoListViewDelegate 구현

    func didAddToDoItem(text: String) {
        let request = TodoRequest(status: "YET", content: text)
        Task {
            let result = await todoService.addTodo(request)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.addTodoItem(response)
                    self.loadWeeklyData() // 데이터 다시 로드
                    // SwipeView 업데이트
                    self.updateSwipeView(
                        totalTodos: self.homeView.toDoListView.todoItems.count,
                        completedTodos: self.homeView.toDoListView.todoItems.filter {
                            $0.status == "DONE"
                        }.count,
                        completionRate: Double(
                            self.homeView.toDoListView.todoItems.filter {
                                $0.status == "DONE"
                            }.count
                        ) / Double(self.homeView.toDoListView.todoItems.count) * 100,
                        successCount: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        availablePoints: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        canReceivePoints: false // 임시로 false 넣어둠, loadWeeklyData에서 갱신
                    )

                    print("✅ 투두 등록 성공: \(response.content)")
                }
            case .failure(let error):
                print("❌ 투두 등록 실패: \(error.localizedDescription)")
            }
        }
    }

    func didUpdateToDoItem(at index: Int, with text: String) {
        guard let todo = homeView.toDoListView.todoItems[safe: index] else { return }
        let request = TodoUpdateRequest(status: "YET", content: text)
        Task {
            let result = await todoService.updateTodo(todoId: todo.todoId, request: request)
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.updateTodoContent(at: index, with: response)
                    self.loadWeeklyData() // 데이터 다시 로드
                    // SwipeView 업데이트
                    self.updateSwipeView(
                        totalTodos: self.homeView.toDoListView.todoItems.count,
                        completedTodos: self.homeView.toDoListView.todoItems.filter {
                            $0.status == "DONE"
                        }.count,
                        completionRate: Double(
                            self.homeView.toDoListView.todoItems.filter {
                                $0.status == "DONE"
                            }.count
                        ) / Double(self.homeView.toDoListView.todoItems.count) * 100,
                        successCount: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        availablePoints: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        canReceivePoints: false // 임시로 false 넣어둠, loadWeeklyData에서 갱신
                    )

                    print("✅ 투두 수정 성공: \(response.content)")
                }
            case .failure(let error):
                print("❌ 투두 수정 실패: \(error.localizedDescription)")
            }
        }
    }

    func didToggleToDoItem(at index: Int) {
        guard let todo = homeView.toDoListView.todoItems[safe: index] else { return }
        let newStatus = todo.status == "YET" ? "DONE" : "YET"
        let request = TodoCheckRequest(status: newStatus)
        Task {
            let result = await todoService.checkTodo(todoId: todo.todoId, request: request)
            switch result {
            case .success(let updatedTodo):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.todoItems[index] = updatedTodo
                    self.homeView.toDoListView.tableView.reloadData()
                    self.loadWeeklyData() // 데이터 다시 로드
                    // SwipeView 업데이트
                    self.updateSwipeView(
                        totalTodos: self.homeView.toDoListView.todoItems.count,
                        completedTodos: self.homeView.toDoListView.todoItems.filter {
                            $0.status == "DONE"
                        }.count,
                        completionRate: Double(
                            self.homeView.toDoListView.todoItems.filter {
                                $0.status == "DONE"
                            }.count
                        ) / Double(self.homeView.toDoListView.todoItems.count) * 100,
                        successCount: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        availablePoints: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        canReceivePoints: false // 임시로 false 넣어둠, loadWeeklyData에서 갱신
                    )

                    print("✅ 투두 상태 변경 성공")
                }
            case .failure(let error):
                print("❌ 투두 상태 변경 실패: \(error.localizedDescription)")
            }
        }
    }

    func didDeleteToDoItem(at index: Int) {
        guard let todo = homeView.toDoListView.todoItems[safe: index] else { return }
        Task {
            let result = await todoService.deleteTodo(todoId: todo.todoId)
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.homeView.toDoListView.todoItems.remove(at: index)
                    self.homeView.toDoListView.tableView.reloadData()
                    self.loadWeeklyData() // 데이터 다시 로드
                    // SwipeView 업데이트
                    self.updateSwipeView(
                        totalTodos: self.homeView.toDoListView.todoItems.count,
                        completedTodos: self.homeView.toDoListView.todoItems.filter {
                            $0.status == "DONE"
                        }.count,
                        completionRate: Double(
                            self.homeView.toDoListView.todoItems.filter {
                                $0.status == "DONE"
                            }.count
                        ) / Double(self.homeView.toDoListView.todoItems.count) * 100,
                        successCount: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        availablePoints: 0, // 임시로 0을 넣어둠, loadWeeklyData에서 갱신
                        canReceivePoints: false // 임시로 false 넣어둠, loadWeeklyData에서 갱신
                    )

                    print("✅ 투두 삭제 성공")
                }
            case .failure(let error):
                print("❌ 투두 삭제 실패: \(error.localizedDescription)")
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
        homeView.authView.onPlaceVerificationTapped = { [weak self] in
            self?.navigateToPlaceVerificationView()
        }
    }

    /// 사진 인증 버튼을 눌렀을 때 `CameraViewController`로 이동
    @objc private func photoAuthTapped() {
        let cameraVC = CameraViewController()
        cameraVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cameraVC, animated: true)
    }

    // MARK: - SwipeView 업데이트

    private func updateSwipeView(
        totalTodos: Int,
        completedTodos: Int,
        completionRate: Double,
        successCount: Int,
        availablePoints: Int,
        canReceivePoints: Bool
    ) {
        homeView.swipeView.updateTodoData(
            totalTodos: totalTodos,
            completedTodos: completedTodos,
            completionRate: completionRate
        )
        homeView.swipeView.updateConsecutiveSuccesses(successCount: successCount)
        homeView.swipeView.updatePointInfo(
            availablePoints: availablePoints,
            canReceivePoints: canReceivePoints
        )
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension HomeViewController {
    /// 장소 인증 화면으로 이동 - 작성자: 이재원
    func navigateToPlaceVerificationView() {
        guard let planId = planId else {
            print("planId in nil")
            return
        }
        let placeVerificationVC = PlaceVerificationViewController(
            mapManager: NaverMapManager(),
            planId: planId
        )
        homeView.authView.isHidden = true
        homeView.scrollView.isScrollEnabled = false // 스크롤 비활성화
        homeView.setNeedsUpdateConstraints()
        
        placeVerificationVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(placeVerificationVC, animated: true)
    }
}
