//
//  SectionTitleCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import UIKit

final class SectionTitleCell: UITableViewCell {
    private struct Constants {
        static let titleTextSize: CGFloat = 20
    }
    private let titleLabel = UILabel.make(weight: .bold, size: Constants.titleTextSize, numberOfLines: 1).identifier("sectionTitleLabel")
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
        titleLabel.constrained()
            .addAsSubview(of: contentView)
            .pinHorizontaly(to: contentView, padding: UIConstants.spacingTripe)
            .top(to: contentView, constant: UIConstants.spacingDouble)
            .bottom(to: contentView, constant: -UIConstants.spacing)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
