//
//  SearchViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Property
    private var searchView: SearchView = SearchView()
    private var recentSearches: [UserSearchResult] = [] // ✅ 타입 변경 (User → UserSearchResult)
    private let userService = UserService() // ✅ API 호출을 위한 서비스
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view = searchView
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Methods
    
    /// 네비게이션 조정함수
    private func setupNavigationBar() {
        searchView.searchBarView.searchBar.delegate = self
        self.navigationItem.titleView = searchView.searchBarView.searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(UIColor.black),
            style: .plain,
            target: self,
            action: #selector(didTapBack))
    }
    
    private func setupTableView() {
        searchView.searchResultView.tableView.delegate = self
        searchView.searchResultView.tableView.dataSource = self
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
    
    /// ✅ 사용자 검색 API 호출
        private func searchUsers(keyword: String) {
            Task {
                do {
                    let users = try await userService.searchUser(keyword: keyword)
                    
                    DispatchQueue.main.async {
                        self.recentSearches = users // ✅ 결과 데이터 저장
                        self.searchView.searchResultView.tableView.reloadData() // ✅ UI 업데이트
                    }
                } catch {
                    print("❌ 사용자 검색 실패: \(error)")
                }
            }
        }
}

/// search 버튼 클릭 시 API 호출하여 사용자 검색 결과 표시
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 🔹 키보드 내리기
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else { return }

        print("🔍 사용자 검색 요청: \(text)") // ✅ 디버깅 로그 추가
        searchUsers(keyword: text) // ✅ API 호출
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultCell.identifier,
            for: indexPath) as? SearchResultCell else {
            return UITableViewCell()
        }
        let user = recentSearches[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = recentSearches[indexPath.row]
        print("✅ 선택된 사용자: \(selectedUser.accountId)")
        /* 화면 전환 로직 추가 가능
         let calendarVC = CalendarViewController(username: selectedUser.accountId)
         navigationController?.pushViewController(calendarVC, animated: true) */
    }
}
