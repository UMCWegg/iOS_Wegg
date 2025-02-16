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
        
        apiManager.setCookie(value: "73E39CC343160FE5F508B39B7E276111")
        print("[HomeVC] JSESSIONID 쿠키 설정 완료")
        
        // 강제 세션 인증 요청
        triggerSessionAuthentication()
        
        // 쿠키 디버그 로그 출력
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        cookies.forEach { cookie in
            print("[debug] 쿠키: \(cookie.name)=\(cookie.value); Domain: \(cookie.domain)")
        }
    }

    // 세션 강제 인증 요청 (POST 방식으로 변경)
    func triggerSessionAuthentication() {
        guard let url = URL(string: "https://weggserver.store/todo/add") else {
            print("❌ [DEBUG] 잘못된 URL 형식")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // 요청 바디 설정
        let body: [String: String] = [
            "status": "YET",
            "content": "세션 활성화 테스트"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("❌ [DEBUG] 요청 바디 생성 실패: \(error.localizedDescription)")
            return
        }

        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [DEBUG] 세션 강제 요청 실패: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("🔍 [DEBUG] 세션 강제 요청 응답 코드: \(response.statusCode)")
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("📦 [DEBUG] 세션 강제 요청 응답: \(responseString)")
            }
        }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        homeView.handleScrollViewDidScroll(scrollView)
    }
    
    // MARK: - 쿠키 설정
    private func applySessionCookie() {
        let sessionId = "73E39CC343160FE5F508B39B7E276111"
        apiManager.setCookie(value: sessionId)
        print("✅ [HomeViewController] 쿠키 설정 완료: JSESSIONID=\(sessionId)")
    }
    
    // 현재 쿠키 목록 출력
    private func printCurrentCookies() {
        let cookies = HTTPCookieStorage.shared.cookies ?? []
        print("🍪 [HomeViewController] 현재 저장된 쿠키 목록:")
        cookies.forEach { cookie in
            print(
                "- \(cookie.name) = \(cookie.value); Domain: \(cookie.domain); Path: \(cookie.path)"
            )
        }
    }
    
    // MARK: - ToDoListViewDelegate
    func didAddToDoItem(text: String) {
        let request = TodoRequest(status: "YET", content: text)
        Task {
            let result = await todoService.addTodo(request)
            switch result {
            case .success(let response):
                print("✅ 투두 등록 성공: \(response.content)")
            case .failure(let error):
                print("❌ 투두 등록 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func didUpdateToDoItem(at index: Int, with text: String) {
        // 투두 수정 로직 구현
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
        print("사진인증터치")
        let cameraVC = CameraViewController()
        cameraVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(cameraVC, animated: true)
    }
}
