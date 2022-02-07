//
//  HeroDetailsComicCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import UIKit

final class HeroDetailsComicCell: UITableViewCell {
    
    private struct Constants {
        static let textSize: CGFloat = 14
        static let titleSize: CGFloat = 18
        static let imageWidth: CGFloat = UIScreen.main.bounds.width * 0.28
        static let imageHeight: CGFloat = imageWidth * 1.54
    }
    
    /// The image view
    private let comicImage = UIImageView()
    
    /// The name label
    private let nameLabel = UILabel.make(weight: .semibold, size: Constants.titleSize)
    
    /// The pages label
    private let pagesLabel = UILabel.make(size: Constants.textSize)
    
    /// The issue number label
    private let issueNumberLabel = UILabel.make(size: Constants.textSize, color: .tertiaryLabel)
    
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
        
        let textsStack = [
            nameLabel,
            pagesLabel,
            issueNumberLabel,
            UIView.spacer(.vertical)
        ].vStack()
     
        let imageWrapper = comicImage
            .fit()
            .dimensions(width: Constants.imageWidth, height: Constants.imageHeight)
            .wrapAndCenterKeepingDimensions()
            .width(Constants.imageWidth)
            .minHeight(Constants.imageHeight)
        [imageWrapper, textsStack].hStack(spacing: UIConstants.spacingDouble)
            .wrapAndPin(padding: UIConstants.spacingDouble)
            .background(.systemBackground)
            .addAndPinAsSubview(to: contentView, bottom: -UIConstants.spacingDouble)
            .rounded()
    }
    
    func setComic(_ comic: Comic) {
        comicImage.sd_setImage(with: comic.thumbnail.url, placeholderImage:  UIImage(systemName: "photo"))
        nameLabel.text = comic.title
        pagesLabel.text = "\(comic.pageCount) Pages"
        issueNumberLabel.text = "Issue #\(comic.issueNumber)"
    }
}
