//
//  HeroCardView.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import UIKit

final class HeroCardView: UIView {

    private struct Constants {
        static let heroNameSize: CGFloat = 30
        static let gradientHeightRatio: CGFloat = 0.3
    }
    
    private(set) var hero: Hero?
    /// The hero image view
    private let heroImage = UIImageView()
    
    /// Gradient view
    private let gradientView = GradientView()
    
    /// The name label
    private let heroNameLabel = UILabel.make(weight: .semibold, size: Constants.heroNameSize, color: .white, numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let shadowView = UIView()
        let containerView = UIView()
        shadowView.addAndPinAsSubview(of: self, horizontalPadding: UIConstants.spacingDouble, verticalPadding: UIConstants.spacing)
            .shadow()
            .heightToWidth()
            .unclipped()
        
        containerView.addAndPinAsSubview(of: shadowView)
            .rounded(radius: UIConstants.radiusLarge)
            
        heroImage.addAndPinAsSubview(of: containerView)
            .fill()
        
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
