//
//  PointPurchaseViewController.swift
//  iOS_Wegg
//
//  Created by 이건수 on 2025.02.21.
//

import UIKit
import StoreKit

class PointPurchaseViewController: UIViewController {
    
    // MARK: - Properties
    
    private let pointPurchaseView = PointPurchaseView()
    
    // 포인트 상품 데이터
    private let pointProducts = [
        PointProduct(id: "com.wegg.point.30", title: "30 포인트", price: 1000),
        PointProduct(id: "com.wegg.point.50", title: "50 포인트", price: 1500),
        PointProduct(id: "com.wegg.point.100", title: "100 포인트", price: 2500)
    ]
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = pointPurchaseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.title = "포인트 구매"
        
        let backButton = SettingBackButton()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupTableView() {
        pointPurchaseView.tableView.delegate = self
        pointPurchaseView.tableView.dataSource = self
        pointPurchaseView.tableView.register(
            PointProductCell.self,
            forCellReuseIdentifier: "PointProductCell")
        
        // 현재 보유 포인트 표시
        pointPurchaseView.pointLabel.text = "보유 포인트: 24 P"
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func purchasePoint(_ product: PointProduct) {
        let alertController = UIAlertController(
            title: "포인트 구매",
            message: "\(product.title)를 \(product.price)원에 구매하시겠습니까?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let purchaseAction = UIAlertAction(title: "구매", style: .default) { [weak self] _ in
            self?.processPurchase(product)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(purchaseAction)
        
        present(alertController, animated: true)
    }
    
    private func processPurchase(_ product: PointProduct) {
        // 구매 처리 로직
        // StoreKit 연동 코드가, 이번에는 간단하게 성공 알림만 표시
        
        let alertController = UIAlertController(
            title: "구매 성공",
            message: "\(product.title)를 구매했습니다.",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PointPurchaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "PointProductCell",
            for: indexPath
        ) as? PointProductCell else {
            return UITableViewCell()
        }
        
        let product = pointProducts[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        purchasePoint(pointProducts[indexPath.row])
    }
}
