//
//  HeroDetailsStatsCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import UIKit

final class HeroDetailsStatsCell: UITableViewCell {
    
    private struct Constants {
        static let textSize: CGFloat = 14
        static let lineWidth: CGFloat = 0.5
    }
  
    /// Value labels
    private let eventsValueLabel = UILabel.make(size: Constants.textSize, color: .secondaryLabel, numberOfLines: 1)
    private let storiesValueLabel = UILabel.make(size: Constants.textSize, color: .secondaryLabel, numberOfLines: 1)
    private let comicsValueLabel = UILabel.make(size: Constants.textSize, color: .secondaryLabel, numberOfLines: 1)
    
    /// Stacks
    private lazy var eventsStack = makeStatStack(valueLabel: eventsValueLabel, title: "Events", imageName: "calendar")
    private lazy var storiesStack = makeStatStack(valueLabel: storiesValueLabel, title: "Stories", imageName: "tv")
    private lazy var comicsStack = makeStatStack(valueLabel: comicsValueLabel, title: "Comics", imageName: "magazine")

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
        [ eventsStack,storiesStack, comicsStack].hStack(distribution: .fillEqually)
            .wrapAndPin(padding: UIConstants.spacingDouble)
            .background(.systemBackground)
            .rounded()
            .addAndPinAsSubview(of: contentView, horizontalPadding: UIConstants.spacingDouble)
    }
    
    func setHero(_ hero: Hero) {
        eventsValueLabel.text = "\(hero.events.available)"
        storiesValueLabel.text = "\(hero.stories.available)"
        comicsValueLabel.text = "\(hero.comics.available)"
    }
    
    private func makeVLine() -> UIView {
        UIView.line(ofColor: .separator)
            .width(Constants.lineWidth)
    }
    
    private func makeStatStack(valueLabel: UILabel, title: String, imageName: String) -> UIStackView {
        let titleLabel =  UILabel.make(title, size: Constants.textSize, color: .secondaryLabel, numberOfLines: 1)
            .textCentered()
        return [titleLabel,
                UIImageView.withSystemName(imageName).fit(),
                valueLabel.textCentered(),

        ].vStack()
            .tinted(.secondaryLabel)
            .width(30)
    }
}
