//
//  UIStackView+Extesnion.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

enum PaddingSide {
    case top
    case bottom
    case leading
    case trailing
    case all

    func toDirectionalMargins(_ margin: CGFloat) -> NSDirectionalEdgeInsets {
        switch self {
        case .top:
            return NSDirectionalEdgeInsets(top: margin, leading: 0, bottom: 0, trailing: 0)
        case .bottom:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: margin, trailing: 0)
        case .leading:
            return NSDirectionalEdgeInsets(top: 0, leading: margin, bottom: 0, trailing: 0)
        case .trailing:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case .all:
            return NSDirectionalEdgeInsets(top: margin, leading: margin, bottom: margin, trailing: margin)
        }
    }
}

extension UIStackView {

    @discardableResult
    func addArrangedSubview(_ view: UIView, atIndex: Int?) -> Self {
        guard let idx = atIndex else {
            addArrangedSubview(view)
            return self
        }

        insertArrangedSubview(view, at: idx)
        return self
    }

    static func vertical(views: [UIView] = [], alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = UIConstants.spacing) -> UIStackView {
        return make(views: views, axis: .vertical, alignment: alignment, distribution: distribution, spacing: spacing)
    }

    static func horizontal(views: [UIView] = [], alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = UIConstants.spacing) -> UIStackView {
        return make(views: views, axis: .horizontal, alignment: alignment, distribution: distribution, spacing: spacing)
    }

    static func make(views: [UIView],
                     axis: NSLayoutConstraint.Axis,
                     alignment: UIStackView.Alignment,
                     distribution: UIStackView.Distribution,
                     spacing: CGFloat) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.axis = axis
        return stack
    }

    @discardableResult
    func add(_ views: UIView...) -> UIStackView {
        for view in views {
            addArrangedSubview(view)
        }
        return self
    }

    @discardableResult
    func add(_ views: [UIView]) -> UIStackView {
        for view in views {
            addArrangedSubview(view)
        }
        return self
    }

    @discardableResult
    func replaceArrangedViews(with views: [UIView]) -> UIStackView {
        removeArrangedSubviews()
        for view in views {
            addArrangedSubview(view)
        }
        return self
    }

    @discardableResult
    func pad(_ margin: PaddingSide, _ padding: CGFloat = UIConstants.spacingDouble) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        switch margin {
        case .top:
            directionalLayoutMargins.top = padding
        case .bottom:
            directionalLayoutMargins.bottom = padding
        case .leading:
            directionalLayoutMargins.leading = padding
        case .trailing:
            directionalLayoutMargins.trailing = padding
        case .all:
            directionalLayoutMargins = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        }
        return self
    }

    @discardableResult
    func pad(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
        return self
    }


    @discardableResult
    func removeArrangedSubviews() -> Self {
        for subv in arrangedSubviews {
            removeArrangedSubview(subv)
            subv.removeFromSuperview()
        }

        return self
    }
}

