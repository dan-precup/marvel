//
//  HeroCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import SDWebImage
import UIKit

final class HeroCell: UITableViewCell {
    
    /// The hero image view
    private let heroImage = UIImageView()
    
    /// Gradient view
    private let gradientView = GradientView(colors: [UIColor.black.withAlphaComponent(0).cgColor,
                                                     UIColor.black.cgColor],
                                            locations: [0, 1])
    
    /// The name label
    private let heroNameLabel = UILabel.make(weight: .semibold, size: 45, color: .white, numberOfLines: 2)
    
    /// Events count icon
    private let eventsIcon = TitledIcon(imageSystemName: "calendar")
    
    /// Stories count icon
    private let storiesIcon = TitledIcon(imageSystemName: "tv")
    
    /// Comics count icon
    private let comicsIcon = TitledIcon(imageSystemName: "magazine")
    
    /// The more button
    private let moreButton = UIButton()
    
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
        heroImage.addAndPinAsSubview(of: contentView)
            .fill()
            .height(UIScreen.main.bounds.height)
        
        gradientView.constrained()
            .addAsSubview(of: contentView)
            .pinToBottom(of: heroImage)
            .height(UIScreen.main.bounds.height * 0.3)
        
        let iconsStack = [moreButton,
                          eventsIcon,
                          storiesIcon,
                          comicsIcon
        ].vStack(spacing: UIConstants.spacingDouble)
            .opacity(0.6)
            .constrained()
            .addAsSubview(of: contentView)
            .bottom(to: heroImage, constant: -UIConstants.spacingQuadruple)
            .trailing(to: heroImage, constant: -UIConstants.spacingDouble)
            .width(20)
        
        heroNameLabel.addAsSubview(of: gradientView)
            .constrained()
            .shrinkToFit()
            .leading(to: gradientView, constant: UIConstants.spacingDouble)
            .centerY(to: gradientView)
            .trailingToLeading(of: iconsStack, constant: -UIConstants.spacingDouble)
        moreButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)

    }
    
    /// Populate the cell with data
    /// - Parameter hero: The hero
    func setHero(_ hero: Hero) {
        heroNameLabel.text = hero.name
        heroImage.sd_setImage(with: hero.thumbnail.url, placeholderImage: UIImage(systemName: "photo"))
        eventsIcon.setTitle("\(hero.events.available)")
        storiesIcon.setTitle("\(hero.stories.available)")
        comicsIcon.setTitle("\(hero.comics.available)")
    }
    
}
