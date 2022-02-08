//
//  SearchResultCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import UIKit

final class SearchResultCell: UITableViewCell {
    
    private struct Constants {
        static let resultNameFontSize: CGFloat = 18
        static let resultImageSideRatio: CGFloat = 0.3
        static let disclosureOpacity: CGFloat = 0.7
    }
    
    /// The result image view
    private let resultImage = UIImageView()
    
    /// The name label
    private let resultNameLabel = UILabel.make(weight: .semibold, size: Constants.resultNameFontSize, color: .white)
    
    /// Disclosure image
    private let disclosureImage = UIImageView.withSystemName("chevron.right.circle.fill")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Setup the ui
    private func setupUI() {
        background(.clear)
        contentView.background(.clear)
        selectionStyle = .none
        
        disclosureImage
            .fit()
            .tinted(.white.withAlphaComponent(Constants.disclosureOpacity))
            .dimensions(width: UIConstants.interactionIcon, height: UIConstants.interactionIcon)
            .addAsSubview(of: contentView)
            .constrained()
            .trailing(to: contentView, constant: -UIConstants.spacingDouble)
            .centerY(to: contentView)
        
        [resultImage, resultNameLabel].hStack(spacing: UIConstants.spacingDouble)
            .addAsSubview(of: contentView)
            .constrained()
            .top(to: contentView, constant: UIConstants.spacing)
            .bottom(to: contentView, constant: -UIConstants.spacing)
            .leading(to: contentView, constant: UIConstants.spacingDouble)
            .trailingToLeading(of: disclosureImage, constant: UIConstants.spacing)
        
        resultImage.fill()
            .clipped()
            .width(equalsTo: contentView, multiplier: Constants.resultImageSideRatio)
            .heightToWidth()
        
    }
    
    func setHero(_ hero: Hero) {
        resultNameLabel.text = hero.name
        resultImage.sd_setImage(with: hero.thumbnail.url, placeholderImage: UIImage(systemName: "photo"))
    }
}
