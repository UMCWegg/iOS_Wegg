//
//  HomeView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

class HomeView: UIView {
    
    let headerView = HeaderView()
    let weeklyEggView = WeeklyEggView()
    
    let modalView = UIView().then {
        $0.backgroundColor = .yellowWhite
        $0.layer.borderColor = UIColor.secondary.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 25
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.masksToBounds = true
    }

    let scrollView = UIScrollView().then {
        $0.backgroundColor = UIColor(
            red: 255/255,
            green: 250/255,
            blue: 236/255,
            alpha: 1.0
        ) /// 배경색 FFFAEC (스크롤 뷰 및 모달 뷰 배경 색)
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
    }
    
    private let contentView = UIView()
    
    let authView = AuthView()
    private let toDoListView = ToDoListView()
    private let swipeView = SwipeView()
    private let timerView = TimerView()
    
    private var modalHeightConstraint: Constraint?
    
    private let maxModalHeight: CGFloat = UIScreen.main.bounds.height * 0.84 // 확장 시 높이
    private let minModalHeight: CGFloat = UIScreen.main.bounds.height * 0.65 // 기본 높이

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(headerView)
        addSubview(weeklyEggView)
        addSubview(modalView)

        modalView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(authView)
        contentView.addSubview(toDoListView)
        contentView.addSubview(swipeView)
        contentView.addSubview(timerView)
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        weeklyEggView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }

        modalView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            modalHeightConstraint = $0.height.equalTo(minModalHeight).constraint // 초기 높이 설정
        }

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualToSuperview().priority(.low) // 높이 유연성 추가
        }

        authView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(280)
        }

        toDoListView.snp.makeConstraints {
            $0.top.equalTo(authView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(toDoListView.tableView.contentSize.height).priority(.medium)
        }
        
        swipeView.snp.makeConstraints {
            $0.top.equalTo(toDoListView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(164) // swipeView의 높이 고정
        }
        
        timerView.snp.makeConstraints {
            $0.top.equalTo(swipeView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY > 50 {
            expandModalView()
        } else if offsetY < 0 {
            collapseModalView()
        }
    }
    
    private func expandModalView() {
        UIView.animate(withDuration: 0.3) {
            self.modalHeightConstraint?.update(offset: self.maxModalHeight)
            self.layoutIfNeeded()
        }
    }

    private func collapseModalView() {
        UIView.animate(withDuration: 0.3) {
            self.modalHeightConstraint?.update(offset: self.minModalHeight)
            self.layoutIfNeeded()
        }
    }
}
