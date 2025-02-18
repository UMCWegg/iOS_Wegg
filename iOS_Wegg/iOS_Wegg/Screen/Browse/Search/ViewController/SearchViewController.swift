//
//  SearchViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/20/25.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Property
    private let searchBarView = SearchBarView()
    private let searchResultView = SearchResultView()
    private var recentSearches: [User] = []
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Methods
    
    private func setupView() {
        view.addSubview(searchBarView)
        view.addSubview(searchResultView)
        
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 네비게이션 조정함수
    private func setupNavigationBar() {
        searchBarView.searchBar.delegate = self
        self.navigationItem.titleView = searchBarView.searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
                .withRenderingMode(.alwaysOriginal)
                .withTintColor(UIColor.black),
            style: .plain,
            target: self,
            action: #selector(didTapBack))
    }
    
    private func setupTableView() {
        searchResultView.tableView.delegate = self
        searchResultView.tableView.dataSource = self
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        let user = User(
            profileImage: UIImage(named: "profile_placeholder") ?? UIImage(),
            username: text)
        recentSearches.append(user)
        searchResultView.tableView.reloadData()
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
        /* 밑에 로직은 사용자 눌렀을시 화면전환 되도록 설계
         let calendarVC = CalendarViewController(username: selectedUser.username)
         navigationController?.pushViewController(calendarVC, animated: true)*/
    }
}
