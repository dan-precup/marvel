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
    
    /// The shadow container
    private let shadowView = UIView()
    
    /// The views container
    let containerView = UIView()

    /// Constraints for shadow view
    private var shadowViewBottomAnchor: NSLayoutConstraint?
    private var shadowViewTopAnchor: NSLayoutConstraint?
    private var shadowViewLeadingAnchor: NSLayoutConstraint?
    private var shadowViewTrailingAnchor: NSLayoutConstraint?
    private var nameLabelLeadingAnchor: NSLayoutConstraint?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        shadowView
            .constrained()
            .addAsSubview(of: self)
            .shadow()
            .heightToWidth()
            .unclipped()
        
        buildConstraints()
        
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
            .addAsSubview(of: gradientView)
            .constrained()
            .trailing(to: gradientView, constant: -UIConstants.spacingDouble)
            .top(to: gradientView, constant: UIConstants.spacingDouble)
            .bottom(to: gradientView, constant: -UIConstants.spacingDouble)
        
        nameLabelLeadingAnchor = heroNameLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: UIConstants.spacingDouble)
        nameLabelLeadingAnchor?.isActive = true
    }
    
    /// Populate the cell with data
    /// - Parameter hero: The hero
    func setHero(_ hero: Hero) {
        heroNameLabel.text = hero.name
        heroImage.sd_setImage(with: hero.thumbnail.url, placeholderImage: UIImage(systemName: "photo"))
        self.hero = hero
    }
    
    func setExpansionStatus(expand: Bool) {
        if expand {
            self.expand()
        } else {
            contract()
        }
    }
    
    func expand() {
        shadowViewBottomAnchor?.constant = 0
        shadowViewTopAnchor?.constant = 0
        shadowViewLeadingAnchor?.constant = 0
        shadowViewTrailingAnchor?.constant = 0
        nameLabelLeadingAnchor?.constant = UIConstants.spacingTripe
        containerView.rounded(radius: 0)
        shadowView.shadow(shadowOpacity: 0)
    }
    
    func contract() {
        shadowViewBottomAnchor?.constant = -UIConstants.spacingDouble
        shadowViewTopAnchor?.constant =  UIConstants.spacingDouble
        shadowViewLeadingAnchor?.constant = UIConstants.spacingDouble
        shadowViewTrailingAnchor?.constant = -UIConstants.spacingDouble
        nameLabelLeadingAnchor?.constant = UIConstants.spacingDouble
        containerView.rounded(radius: UIConstants.radiusLarge)
        shadowView.shadow()
    }
    
    /// Build the manual constraints so we can manipulated them later
    private func buildConstraints() {
        shadowViewBottomAnchor = shadowView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.spacingDouble)
        shadowViewTopAnchor = shadowView.topAnchor.constraint(equalTo: self.topAnchor, constant:  UIConstants.spacingDouble)
        shadowViewLeadingAnchor = shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.spacingDouble)
        shadowViewTrailingAnchor = shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.spacingDouble)
        shadowViewBottomAnchor?.isActive = true
        shadowViewTopAnchor?.isActive = true
        shadowViewLeadingAnchor?.isActive = true
        shadowViewTrailingAnchor?.isActive = true
    }
}
