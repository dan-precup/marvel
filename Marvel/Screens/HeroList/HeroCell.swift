//
//  HeroCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import SDWebImage
import UIKit

final class HeroCell: UITableViewCell {
    
    private struct Constants {
        static let heroNameSize: CGFloat = 30
        static let gradientHeightRatio: CGFloat = 0.3
    }
    /// Current hero
    private var hero: Hero?
        
    /// The hero image view
    private let heroImage = UIImageView()
    
    /// Gradient view
    private let gradientView = GradientView()
    
    /// The name label
    private let heroNameLabel = UILabel.make(weight: .semibold, size: Constants.heroNameSize, color: .white, numberOfLines: 2)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.tinted(.white)
        selectionStyle = .none
        let shadowView = UIView()
        let containerView = UIView()
        shadowView.addAndPinAsSubview(of: contentView, horizontalPadding: UIConstants.spacingDouble, verticalPadding: UIConstants.spacing)
            .shadow()
            .heightToWidth()
            .unclipped()
        containerView.addAndPinAsSubview(of: shadowView)
            .rounded(radius: UIConstants.radiusLarge)
            
        heroImage.addAndPinAsSubview(of: containerView)
            .fill()
            .height(UIScreen.main.bounds.height)
        
        gradientView.constrained()
            .addAsSubview(of: containerView)
            .pinToBottom(of: heroImage)
            .height(equalsTo: containerView, multiplier: Constants.gradientHeightRatio)
        
        heroNameLabel
            .shrinkToFit()
            .textShadow()
            .addAndPinAsSubview(of: gradientView, padding: UIConstants.spacingDouble)
        
    }
    
    /// Populate the cell with data
    /// - Parameter hero: The hero
    func setHero(_ hero: Hero) {
        heroNameLabel.text = hero.name
        heroImage.sd_setImage(with: hero.thumbnail.url, placeholderImage: UIImage(systemName: "photo"))
        self.hero = hero
    }
}
