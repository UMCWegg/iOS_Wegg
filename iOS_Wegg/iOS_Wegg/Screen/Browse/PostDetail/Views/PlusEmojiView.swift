//
//  PlusEmojiView.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/28/25.
//

import UIKit

class PlusEmojiView: UIView {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // 뷰 구성
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private var emojis: [EmojiModel] = []
    var emojiSelected: ((EmojiModel) -> Void)? // 선택된 이모지를 전달하는 클로저
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 39, height: 39)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 19
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white.withAlphaComponent(0.7) // 투명한 배경
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    // MARK: - Methods
    
    private func setupView() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure (with emojis: [EmojiModel]) {
        self.emojis = emojis
        collectionView.reloadData()
    }
}

extension PlusEmojiView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return emojis.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EmojiCell.identifier,
            for: indexPath) as? EmojiCell
        else {
            return UICollectionViewCell()
        }
        let emoji = emojis[indexPath.item]
        cell.configure(with: emoji)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEmoji = emojis[indexPath.item]
        emojiSelected?(selectedEmoji)
    }
}
