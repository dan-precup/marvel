//
//  HeroDetailsNameImageCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import UIKit

final class HeroDetailsNameImageCell: UITableViewCell {
    
    private struct Constants {
        static let imageSideRatio: CGFloat = 0.22
        static let nameSize: CGFloat = 20
    }
    
    /// The image view
    private let heroImage = UIImageView()
    
    /// The hero name label
    private let nameLabel = UILabel.make(weight: .bold, size: Constants.nameSize, numberOfLines: 2)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        background(.clear)
      
        [heroImage, nameLabel].hStack()
            .wrapAndPin(padding: UIConstants.spacingDouble)
            .background(.systemBackground)
            .rounded()
            .addAndPinAsSubview(of: contentView)
        heroImage.fit()
            .width(equalsTo: contentView, multiplier: Constants.imageSideRatio)
            .heightToWidth()
            .circle()
        
    }
    
    func setData(imageURL: URL, name: String) {
        heroImage.sd_setImage(with: imageURL, placeholderImage:  UIImage(systemName: "photo"))
        nameLabel.text = name
    }
}
