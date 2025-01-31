//
//  FollowViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

class FollowViewController: UIViewController {
    
    private let followView = FollowView()
    
    private let sections = ["팔로우 요청", "연락처에 있는 weegy 추천", "회원님을 위한 weegy 추천"]
    
    private let followRequests = [
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진")
    ]
    
    private let recommendedContacts = [
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진")
    ]
    
    private let recommendedUsers = [
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진"),
        ("sojin1108", "신소진")
    ]
    
    override func loadView() {
        self.view = followView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        followView.tableView.dataSource = self
        followView.tableView.delegate = self
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton().then {
            $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            $0.tintColor = .black
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        let titleLabel = UILabel().then {
            $0.text = "팔로우 요청"
            $0.font = .boldSystemFont(ofSize: 18)
            $0.textColor = .black
        }
        
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return followRequests.count
        case 1:
            return recommendedContacts.count
        case 2:
            return recommendedUsers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FollowCell.identifier,
            for: indexPath
        ) as? FollowCell else {
            return UITableViewCell()
        }
        
        let data: (String, String)
        
        switch indexPath.section {
        case 0:
            data = followRequests[indexPath.row]
            cell.configure(with: data.0, name: data.1, type: .request)
        case 1:
            data = recommendedContacts[indexPath.row]
            cell.configure(with: data.0, name: data.1, type: .recommendation)
        case 2:
            data = recommendedUsers[indexPath.row]
            cell.configure(with: data.0, name: data.1, type: .recommendation)
        default:
            return UITableViewCell()
        }
        
        return cell
    }
}
