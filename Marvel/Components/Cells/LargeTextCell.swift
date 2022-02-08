//
//  LargeTextCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import UIKit

final class LargeTextCell: UITableViewCell {
    private let largeTextLabel = UILabel.make().identifier("largeTextLabel")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        background(.clear)
        selectionStyle = .none
        largeTextLabel
            .wrapAndPin(padding: UIConstants.spacingDouble)
            .background(.secondarySystemGroupedBackground)
            .rounded()
            .addAndPinAsSubview(of: contentView, horizontalPadding: UIConstants.spacingDouble)
    }
    
    func setText(_ text: String) {
        largeTextLabel.text = text
    }
}
