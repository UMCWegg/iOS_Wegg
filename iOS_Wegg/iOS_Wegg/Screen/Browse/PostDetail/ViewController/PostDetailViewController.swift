//
//  PostDetailViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/21/25.
//

import UIKit
import SnapKit

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
        handlePlusEmojiSelection()
        commentButtonAction()
    }
    
    // MARK: - Methods
    
    /// UI를 구성하고 데이터를 뷰에 반영
    private func configureUI() {
        /// PostDetailView에 데이터를 전달하여 화면을 업데이트
        postDetailView.configure(with: postDetailModel)
    }
    
    /// 네비게이션 상단 바 타이틀 지정 및 나가기 버튼 커스텀
    private func setNavigation() {
        let titleView = UIView()
        // 로고 이미지로 스타일 변경
        let logoImageView = UIImageView(image: UIImage(named: "wegg_text"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        titleView.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(logoImageView.snp.height).multipliedBy(1.5) // 비율 유지
        }
        
        let backBtn = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(UIColor.white),
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
        // PlusEmojiView가 열려 있다면 닫기
            if let plusEmojiView = view.subviews.first(where: { $0 is PlusEmojiView }) {
                hidePopupView(plusEmojiView) // PlusEmojiView 닫기
                return
            }
        
        // 현재 이모지 팝업이 표시된 상태인지 확인
        if isEmojiPopupVisible {
            postDetailView.hideEmojiPopup() // 팝업이 표시 중인 상태에서 다른 동작시 숨기기
        } else {
            postDetailView.showEmojiPopup() // 팝업이 숨겨져 있다면 이모지 클릭시 표시
        }
        // 팝업 상태를 반대로 토글
        isEmojiPopupVisible.toggle()
    }
    
    /// PlusEmojiView를 포함하고, plus 버튼 클릭시 팝업을 표시하기
    private func handlePlusEmojiSelection() {
        postDetailView.emojiPopupView.showPlusView = { [weak self] in
            guard let self = self else { return }
            
            // PlusEmojiView 생성 및 설정
            let plusEmojiView = PlusEmojiView()
            plusEmojiView.configure(with: EmojiModel.getEmojiModels()) // 데이터 제공
            
            // 선택된 이모지 처리
            plusEmojiView.emojiSelected = { [weak self] selectedEmoji in
                print("이모지가 선택되었습니다: \(selectedEmoji.name)")
                self?.postDetailView.hideEmojiPopup() // 기존 이모지 팝업 닫기 메서드 호출
            }
            
            // 이모지 선택 시 팝업 닫기 설정
            plusEmojiView.closePopup = { [weak self] in
                print("PlusEmojiView에서 이모지 선택됨")
                self?.hidePopupView(plusEmojiView) // 팝업 닫기 메서드
            }
            
            self.showPopupView(plusEmojiView) // 팝업 표시하기
        }
    }
    
    /// 플러스 이모지 팝업뷰를 보여주는 메서드
    private func showPopupView(_ popupView: UIView) {
        view.addSubview(popupView)
        
        // 배경 둥글게 설정하기
        popupView.layer.cornerRadius = 25
        popupView.clipsToBounds = true // 모서리 둥글게
        
        popupView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-140)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(360)
            $0.height.equalTo(260)
        }
        
        // 애니메이션으로 팝업 표시
        UIView.animate(withDuration: 0.3) {
            popupView.alpha = 1
        }
    }
    
    /// 플러스 이모지 팝업뷰 가리는 메서드
    private func hidePopupView(_ popupView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            popupView.alpha = 0 // 투명도 0으로 설정하여 사라지게 만듦
        }, completion: { _ in
            popupView.removeFromSuperview() // 애니메이션 완료 후 제거
        })
    }
    
    /// 댓글 버튼에 액션을 추가하는 메서드
    private func commentButtonAction() {
        postDetailView.commentButton.addTarget(
            self,
            action: #selector(handleCommentButtonTap),
            for: .touchUpInside)
    }
    
    /// 댓글 버튼 클릭 시 바텀 시트 띄우기
    @objc private func handleCommentButtonTap() {
        let commentVC = CommentViewController()
        
        if let sheet = commentVC.sheetPresentationController {
            sheet.detents = [
                .medium(),
                .large()
            ]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 25
        }
        
        present(commentVC, animated: true, completion: nil)
    }
}
