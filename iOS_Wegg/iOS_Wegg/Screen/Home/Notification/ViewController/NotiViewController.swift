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

    private let notiView = NotiView()
    
    private let sections = ["읽지 않음", "오늘", "이전 활동"]
    private let notifications: [[(String, String)]] = [
        [("OO님이 댓글을 달았습니다: “~~”", "2일")],
        [("OO님이 댓글을 달았습니다: “~~”", "2일"),
         ("OO님이 알을 깨고 도망갔어요!", "2일")],
        [("OO님이 댓글을 달았습니다: “~~”", "2일"),
         ("OO님이 알을 깨고 도망갔어요!", "2일")]
    ]

    override func loadView() {
        self.view = notiView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        notiView.notiFollowView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(followTapped))
        )
        
        notiView.tableView.dataSource = self
        notiView.tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupNavigationBar() {
        let backButton = UIButton().then {
            $0.setImage(UIImage(named: "backButton"), for: .normal)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func followTapped() {
        let followVC = FollowViewController()
        navigationController?.pushViewController(followVC, animated: true)
    }
}

extension NotiViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotiCell.identifier,
            for: indexPath
        ) as? NotiCell else {
            return UITableViewCell()
        }
        
        let (text, time) = notifications[indexPath.section][indexPath.row]
        cell.configure(with: text, time: time)
        return cell
    }
}
