//
//  NotiViewController.swift
//  iOS_Wegg
//
//  Created by KKM on 1/31/25.
//

import UIKit
import SnapKit
import Then

class NotiViewController: UIViewController {

    private let apiManager = APIManager()
    private let notiView = NotiView()

    // 섹션 재정의: "읽지 않음", "읽음"
    private let sections = ["읽지 않음", "읽음"]

    // notifications 데이터를 저장할 변수
    private var notifications: [GetNoti] = []

    override func loadView() {
        self.view = notiView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        notiView.tableView.dataSource = self
        notiView.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = true

        // API 호출 및 데이터 로드
        loadNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
            $0.text = "알림"
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

    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(followTapped)
        )
        notiView.notiFollowView.addGestureRecognizer(tapGesture)
        notiView.notiFollowView.isUserInteractionEnabled = true
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func followTapped() {
        let followVC = FollowViewController()
        navigationController?.pushViewController(followVC, animated: true)
    }

    // API로부터 데이터를 받아오는 함수
    func loadNotifications() {
        Task {
            do {
                let response: GetNotiResponse = try await getNotifications(apiManager: apiManager)

                // 데이터 로드 성공 시
                self.notifications = response.result.notifications

                // accountVisibility에 따라 NotiFollowView 숨김/표시
                if response.result.accountVisibility == "PUBLIC" {
                    notiView.notiFollowView.isHidden = true
                } else if response.result.accountVisibility == "FOLLOWER_ONLY" {
                    notiView.notiFollowView.isHidden = false

                    // NotiFollowView에 데이터 설정
                    notiView.notiFollowView.configure(
                        latestFollowerAccountId: response.result.latestFollowerAccountId,
                        waitingFollowRequests: response.result.waitingFollowRequests,
                        viewController: self
                    )
                }

                // 테이블 뷰 리로드
                notiView.tableView.reloadData()

            } catch {
                // 에러 처리
                print("Error loading notifications: \(error)")
            }
        }
    }

    // APIManager 외부에서 API 호출 함수 정의
    func getNotifications(apiManager: APIManager) async throws -> GetNotiResponse {
        return try await apiManager.request(target: NotificationAPI.notification)
    }
}

extension NotiViewController: UITableViewDataSource, UITableViewDelegate {
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
        // 섹션에 따라 필터링된 데이터 개수 반환
        switch section {
        case 0: // "읽지 않음" 섹션
            return notifications.filter { $0.readStatus == "UNREAD" }.count
        case 1: // "읽음" 섹션
            return notifications.filter { $0.readStatus == "READ" }.count
        default:
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotiCell.identifier,
            for: indexPath
        ) as? NotiCell else {
            return UITableViewCell()
        }

        // 섹션에 따라 필터링된 데이터 사용
        let notification: GetNoti
        switch indexPath.section {
        case 0: // "읽지 않음" 섹션
            notification = notifications.filter {
                $0.readStatus == "UNREAD"
            }[indexPath.row]
        case 1: // "읽음" 섹션
            notification = notifications.filter {
                $0.readStatus == "READ"
            }[indexPath.row]
        default:
            return UITableViewCell()
        }

        // content와 imageUrl을 사용하여 셀 구성
        cell.configure(
            with: notification.content,
            time: "",
            imageUrl: notification.imageUrl
        )
        return cell
    }

    // ✅ 셀 간격 추가 (셀 기본 높이 45 + 간격 12 = 57)
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    // ✅ 섹션 헤더 커스텀 (폰트 및 색상 설정)
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
