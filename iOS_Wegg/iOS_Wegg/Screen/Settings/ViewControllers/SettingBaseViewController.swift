//
//  SettingBaseViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.17.
//

import UIKit

class SettingBaseViewController: UIViewController {

    // MARK: - Properties
    
    lazy var tableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingBaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Must override")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Must override")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
