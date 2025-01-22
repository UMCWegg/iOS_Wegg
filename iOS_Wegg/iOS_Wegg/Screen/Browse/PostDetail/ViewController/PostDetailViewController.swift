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
    }
    
    // MARK: - Methods
    private func configureUI() {
        postDetailView.configure(with: postDetail)
    }
}
