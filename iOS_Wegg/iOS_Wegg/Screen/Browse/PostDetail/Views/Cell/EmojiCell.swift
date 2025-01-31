//
//  EmojiCellCollectionViewCell.swift
//  iOS_Wegg
//
//  Created by 송승윤 on 1/30/25.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "EmojiCell"
    
    private let emojiImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupView() {
        contentView.addSubview(emojiImageView)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    func configure(with emoji: EmojiModel) {
        emojiImageView.image = UIImage(named: emoji.imageName)
    }
}
