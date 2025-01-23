//
//  PostDetailViewController.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/21/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    // MARK: - Property
    private let postDetail: PostDetail
    private let postDetailView = PostDetailView()
    
    // MARK: - Init
    
    /// 둘러보기 뷰의 사용자 데이터 의존성 주입
    init(postDetail: PostDetail) {
        self.postDetail = postDetail
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
    }
    
    // MARK: - Methods
    
    /// UI를 구성하고 데이터를 뷰에 반영
    private func configureUI() {
        /// PostDetailView에 데이터를 전달하여 화면을 업데이트
        postDetailView.configure(with: postDetail)
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
}
