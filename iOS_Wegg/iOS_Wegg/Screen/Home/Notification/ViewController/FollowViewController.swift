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
    private let sections = [
        "팔로우 요청",
        "연락처에 있는 weegy 추천",
        "회원님을 위한 weegy 추천"
    ]

    // 데이터는 이제 외부에서 받아올 것이므로, 임시 데이터는 제거합니다.
    private var followRequests: [(String, String)] = []
    private var recommendedContacts: [(String, String)] = []
    private var recommendedUsers: [(String, String)] = []

    override func loadView() {
        self.view = followView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        followView.tableView.dataSource = self
        followView.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = true
    }

    private func setupNavigationBar() {
        let backButton = UIButton().then {
            $0.setImage(UIImage(named: "backButton"), for: .normal)
            $0.addTarget(
                self,
                action: #selector(backButtonTapped),
                for: .touchUpInside
            )
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

    // 데이터를 설정하는 함수를 추가합니다.
    func configure(
        followRequests: [(String, String)],
        recommendedContacts: [(String, String)],
        recommendedUsers: [(String, String)]
    ) {
        self.followRequests = followRequests
        self.recommendedContacts = recommendedContacts
        self.recommendedUsers = recommendedUsers
        followView.tableView.reloadData() // 데이터 변경 후 테이블 뷰를 리로드합니다.
    }
}

extension FollowViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
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

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57 // 셀 기본 높이(45) + 간격(12)
    }

    // ✅ 섹션 헤더 폰트 및 색상 수정 (잘림 방지)
    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
            header.textLabel?.textColor = .black
            header.textLabel?.lineBreakMode = .byWordWrapping // ✅ 줄 바꿈 허용
            header.textLabel?.numberOfLines = 0 // ✅ 여러 줄 표시 가능
        }
    }

    // ✅ 섹션 헤더 뷰 설정 (잘림 방지 + 레이아웃 강제 업데이트)
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.textLabel?.font = UIFont(name: "NotoSansKR-Medium", size: 16)
        headerView.textLabel?.textColor = .black
        headerView.textLabel?.lineBreakMode = .byWordWrapping
        headerView.textLabel?.numberOfLines = 0
        headerView.textLabel?.text = sections[section]
        headerView.layoutIfNeeded() // ✅ 레이아웃 강제 업데이트
        return headerView
    }

    // ✅ 섹션 헤더 높이 조정 (너비 부족으로 인한 줄바꿈 대응)
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
        return 28 // 기본 높이보다 살짝 높게 설정하여 여유 공간 확보
    }
}
