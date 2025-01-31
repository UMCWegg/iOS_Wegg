//
//  SwipeView.swift
//  iOS_Wegg
//
//  Created by KKM on 1/29/25.
//

import UIKit
import SnapKit
import Then

final class SwipeView: UIView, UIScrollViewDelegate {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
    }
    
    private let pageControl = UIPageControl().then {
        $0.numberOfPages = 2
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .primary
        $0.currentPageIndicatorTintColor = .secondary
    }
    
    private var slides: [UIView] = []
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if slides.isEmpty { // 중복 호출 방지
            setupSlides()
        }
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        self.do {
            $0.backgroundColor = UIColor(
                red: 255 / 255,
                green: 253 / 255,
                blue: 249 / 255,
                alpha: 1.0
            )
            $0.layer.cornerRadius = 20
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(
                red: 162 / 255,
                green: 131 / 255,
                blue: 106 / 255,
                alpha: 1.0
            ).cgColor
        }
        
        addSubview(scrollView)
        addSubview(pageControl)
        
        scrollView.delegate = self
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSlides() {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        slides.removeAll()
        
        let slide1 = createSlideView(
            title: "나의 목표 달성",
            progressText: "4개의 투두 중 2개를 달성했어요!",
            remainingText: "나머지 2개도 마저 달성하여 에그를 얻어보세요",
            progress: 0.5,
            image: nil
        )
        
        let slide2 = createSlideView(
            title: "포인트 얻기",
            progressText: "목표를 달성하고 포인트를 쌓아보세요!",
            remainingText: "알을 눌러 포인트를 적립하세요",
            progress: nil,
            image: "shineEgg"
        )
        
        slides = [slide1, slide2]
        
        let slideWidth = bounds.width
        let slideHeight = bounds.height
        
        for (index, slide) in slides.enumerated() {
            scrollView.addSubview(slide)
            slide.snp.makeConstraints { make in
                make.width.equalTo(slideWidth)
                make.height.equalTo(slideHeight)
                make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(index) * slideWidth)
                make.top.equalTo(scrollView.snp.top)
            }
        }
        
        scrollView.contentSize = CGSize(
            width: slideWidth * CGFloat(slides.count),
            height: slideHeight
        )
    }
    
    private func createSlideView(
        title: String,
        progressText: String,
        remainingText: String,
        progress: CGFloat?,
        image: String?
    ) -> UIView {
        let view = UIView().then {
            $0.backgroundColor = UIColor(
                red: 255 / 255,
                green: 253 / 255,
                blue: 249 / 255,
                alpha: 1.0
            )
            $0.layer.cornerRadius = 24
            $0.layer.masksToBounds = true
        }

        // 라벨을 묶을 컨테이너 뷰
        let labelContainerView = UIView()

        let titleLabel = UILabel().then {
            $0.text = title
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 13)
            $0.textColor = .gray
        }

        let progressLabel = UILabel().then {
            $0.text = progressText
            $0.font = UIFont(name: "NotoSansKR-Regular", size: 14)
            $0.textColor = .black
            $0.numberOfLines = 2
        }

        let remainingLabel = UILabel().then {
            $0.text = remainingText
            $0.font = UIFont(name: "NotoSansKR-Medium", size: 11)
            $0.textColor = .gray
        }

        labelContainerView.addSubview(titleLabel)
        labelContainerView.addSubview(progressLabel)
        labelContainerView.addSubview(remainingLabel)

        let eggProgressView = EggProgressView().then {
            if let progress = progress {
                $0.setProgress(progress, animated: false)
            } else {
                $0.isHidden = true
            }
        }

        let shineEggView = UIButton().then {
            if let imageName = image {
                $0.setImage(UIImage(named: imageName), for: .normal)
                $0.imageView?.contentMode = .scaleAspectFit
                $0.addTarget(self, action: #selector(shineEggButtonTapped), for: .touchUpInside)
            } else {
                $0.isHidden = true
            }
        }

        let contentView = UIView()
        contentView.addSubview(labelContainerView)
        contentView.addSubview(progress != nil ? eggProgressView : shineEggView)

        view.addSubview(contentView)

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        labelContainerView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6) // 전체 너비의 60% 사용
        }

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }

        remainingLabel.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }

        if progress != nil {
            eggProgressView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-16)
                make.width.equalTo(85)
                make.height.equalTo(102)
            }
        } else {
            shineEggView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-16)
                make.width.equalTo(85)
                make.height.equalTo(102)
            }
        }

        return view
    }
    
    // MARK: - Button Action
    @objc private func shineEggButtonTapped(_ sender: UIButton) {
        print("포인트 버튼 클릭✅")
        
        // 애니메이션 효과: 살짝 줄어들었다가 복귀
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9) // 크기 줄이기
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity // 원래 크기로 복귀
            })
        }
    }

    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
        pageControl.currentPage = currentPage
    }
}
