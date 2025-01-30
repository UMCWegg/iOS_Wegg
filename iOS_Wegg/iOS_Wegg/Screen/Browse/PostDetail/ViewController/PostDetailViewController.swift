//
//  PostDetailViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/21/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - Property
    private let postDetailModel: PostDetailModel
    private let postDetailView = PostDetailView()
    private var isEmojiPopupVisible = false
    
    // MARK: - Init
    
    /// 둘러보기 뷰의 사용자 데이터 의존성 주입
    init(postDetailModel: PostDetailModel) {
        self.postDetailModel = postDetailModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func loadView() {
        self.view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setNavigation()
        emojiButtonAction()
    }
    
    // MARK: - Methods
    
    /// UI를 구성하고 데이터를 뷰에 반영
    private func configureUI() {
        /// PostDetailView에 데이터를 전달하여 화면을 업데이트
        postDetailView.configure(with: postDetailModel)
    }
    
    /// 네비게이션 상단 바 타이틀 지정 및 나가기 버튼 커스텀
    private func setNavigation() {
        self.navigationItem.title = "Wegg 게시물"
        
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor.black),
            style: .plain,
            target: self,
            action: #selector(didTap))
        navigationItem.leftBarButtonItem = backBtn
    }
    
    /// 네비게이션 왼쪽 상단 버튼을 통해 이전 화면으로 돌아감
    @objc func didTap() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 이모지 버튼에 액션을 추가하는 메서드
    private func emojiButtonAction() {
        // 이모지 버튼에 터치 이벤트(.touchUpInside)를 연결
        postDetailView.emojiButton.addTarget(
            self, // 이벤트를 처리할 대상 (self: 현재 ViewController)
            action: #selector(handleEmojiButtonTap), // 버튼 클릭 시 호출될 메서드
            for: .touchUpInside // 버튼을 눌렀다가 뗐을 때 이벤트가 발생
        )
    }

    /// 이모지 버튼이 클릭되었을 때 호출되는 메서드
    @objc private func handleEmojiButtonTap() {
        // 현재 이모지 팝업이 표시된 상태인지 확인
        if isEmojiPopupVisible {
            postDetailView.hideEmojiPopup() // 팝업이 표시 중인 상태에서 다른 동작시 숨기기
        } else {
            postDetailView.showEmojiPopup() // 팝업이 숨겨져 있다면 이모지 클릭시 표시
        }
        // 팝업 상태를 반대로 토글
        isEmojiPopupVisible.toggle()
    }
}
