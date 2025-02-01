//
//  CommentView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 2/1/25.
//

import UIKit
import SnapKit

class CommentView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    /// 댓글 입력 필드
    lazy var commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력하세요 ..."
        $0.borderStyle = .roundedRect
        $0.font = UIFont.notoSans(.regular, size: 14)
        $0.isUserInteractionEnabled = true
    }
    
    /// 댓글 등록 버튼
    lazy var submitButton = UIButton().then {
        $0.setImage(UIImage(named: "submit_icon"), for: .normal)
        $0.tintColor = .white
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    /// 댓글 리스트 테이블 뷰
    lazy var tableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.separatorStyle = .none
    }
    
    // MARK: - Methods
    
    /// UI 구성 요소 추가
    private func setupView() {
        backgroundColor = .white
        [ commentTextField, submitButton, tableView].forEach {
            self.addSubview($0)
        }
    }
    
    // 레이아웃 설정
    private func setupConstraints() {
        commentTextField.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-52) // 하단에서 여백 유지
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(submitButton.snp.leading).offset(-10)
            $0.height.equalTo(44)
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalTo(commentTextField)
            $0.width.height.equalTo(27)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16) // 테이블뷰 시작 위치
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(commentTextField.snp.top).offset(-16) // 댓글 입력 필드 위까지 확장
        }
    }}
