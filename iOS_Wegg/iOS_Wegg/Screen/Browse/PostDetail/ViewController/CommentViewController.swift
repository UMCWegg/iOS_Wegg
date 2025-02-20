//
//  CommentViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import UIKit

/// 댓글 바텀 시트를 담당하는 댓글창 뷰 컨트롤러
class CommentViewController: UIViewController {
    
    // MARK: - Property
    
    private let commentView = CommentView()
    // Mock데이터 프로퍼티 선언
    private var comments = CommentModel.getMockdata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupTableView()
        setupSheetPresentation() // 바텀 시트 설정
        view.backgroundColor = .white
        view = commentView
        // 초기 이모지 설정 테스트
        commentView.updateEmojiImages(with: ["blush", "cry", "pray"])
    }
    
    
    
    // MARK: - Methods
    /// 테이블 뷰 설정
    private func setupTableView() {
        commentView.tableView.dataSource = self
    }
    
    /// 버튼 액션 설정
    private func setupActions() {
        commentView.submitButton.addTarget(
            self, action: #selector(didTapSubmit),
            for: .touchUpInside)
    }
    
    /// 바텀 시트 설정
    private func setupSheetPresentation() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .medium(), // 중간 크기 (약간만 띄우기)
                .large() // 완전 확장
            ]
            sheet.prefersGrabberVisible = true // 상단 그립
            sheet.preferredCornerRadius = 25 // 모서리 둥글게
        }
    }
    
    /// 댓글 등록 버튼 클릭 시 댓글 추가
    @objc private func didTapSubmit() {
        guard let text = commentView.commentTextField.text, !text.isEmpty else { return }
        let newCommnet = CommentModel(
            userName: "사용자",
            profileImage: UIImage(named: "profile_placeholder"),
            commentText: text)
        // 댓글 배열에 추가
        comments.append(newCommnet)
        // 입력 필드 초기화
        commentView.commentTextField.text = ""
        // 테이블 뷰 갱신
        commentView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    
    // 테이블 뷰의 섹션당 행 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    // 각 행에 대한 셀을 생성하여 반환하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 재사용 가능한 셀을 가져옴 (없으면 기본 UITableViewCell 반환)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentCell.identifier,
            for: indexPath) as? CommentCell else { return UITableViewCell() }
        // 현재 인덱스의 댓글 데이터를 셀에 설정
        cell.configure(with: comments[indexPath.row])
        return cell
    }
}
