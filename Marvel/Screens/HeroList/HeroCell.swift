//
//  HeroCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import SDWebImage
import UIKit

protocol HeroCellSearchDelegate: AnyObject {
    func heroCellDidSelectSearch()
}

final class HeroCell: UITableViewCell {
    
    private struct Constants {
        static let heroNameSize: CGFloat = 45
        static let gradientHeight: CGFloat = UIScreen.main.bounds.height * 0.3
        static let genericAlpha: CGFloat = 0.7
        static let progressTrackAlpha: CGFloat = 0.3
        static let progressHeight: CGFloat = 3
        static let progressRadius: CGFloat = 1.5
        static let leftIconsWidth: CGFloat = 20
    }
    
    weak var delegate: HeroCellSearchDelegate?
    
    /// The hero image view
    private let heroImage = UIImageView()
    
    /// Gradient view
    private let gradientView = GradientView()
    
    /// The name label
    private let heroNameLabel = UILabel.make(weight: .semibold, size: Constants.heroNameSize, color: .white, numberOfLines: 2)
    
    /// Events count icon
    private let eventsIcon = TitledIcon(imageSystemName: "calendar")
    
    /// Stories count icon
    private let storiesIcon = TitledIcon(imageSystemName: "tv")
    
    /// Comics count icon
    private let comicsIcon = TitledIcon(imageSystemName: "magazine")
    
    /// The more button
    private let moreButton = UIButton()
    
    /// Time progressbar
    private let progressBar = UIProgressView()
    
    /// Search button
    private let searchButton = UIButton()
    
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
            .height(Constants.gradientHeight)
        
        setGradientContent()
        setProgressBar()
    }
    
    /// Sets up the gradient content
    private func setGradientContent() {
        let iconsStack = [moreButton,
                          eventsIcon,
                          storiesIcon,
                          comicsIcon
        ].vStack(spacing: UIConstants.spacingDouble)
            .opacity(Constants.genericAlpha)
            .constrained()
            .addAsSubview(of: contentView)
            .bottom(to: heroImage, constant: -UIConstants.spacingQuadruple)
            .trailing(to: heroImage, constant: -UIConstants.spacingDouble)
            .width(Constants.leftIconsWidth)
        
        heroNameLabel.addAsSubview(of: gradientView)
            .constrained()
            .shrinkToFit()
            .leading(to: gradientView, constant: UIConstants.spacingDouble)
            .centerY(to: gradientView)
            .trailingToLeading(of: iconsStack, constant: -UIConstants.spacingDouble)
        
        moreButton.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
    }
    
    /// Sets up the progress bar and the search button
    private func setProgressBar() {
        let progressWrapper = progressBar
            .rounded(radius: Constants.progressRadius)
            .height(Constants.progressHeight)
            .wrapAndCenterY(minHeight: Constants.progressHeight)
        progressBar.trackTintColor = .white.withAlphaComponent(Constants.progressTrackAlpha)
        progressBar.progressTintColor = .white
        searchButton
            .opacity(Constants.genericAlpha)
            .dimensions(width: Constants.leftIconsWidth, height: UIConstants.buttonHeight)
            .setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        [progressWrapper, searchButton]
            .hStack(spacing: UIConstants.spacing)
            .constrained()
            .addAsSubview(of: contentView)
            .pinToTop(toSafeAreaOf: heroImage,
                      leading: UIConstants.spacingDouble,
                      trailing: -UIConstants.spacingDouble,
                      top: UIConstants.spacingTripe)
        searchButton.addTarget(self, action: #selector(didSelectSearchButton), for: .touchUpInside)
    }
    
    @objc private func didSelectSearchButton() {
        delegate?.heroCellDidSelectSearch()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        progressBar.setProgress(0, animated: false)
    }
    
    func startProgressAnimation(with duration: TimeInterval) {
        progressBar.setProgress(0, animated: false)
        contentView.layoutIfNeeded()
    
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
            self.progressBar.setProgress(1, animated: true)
        })
       
    }
    
}
