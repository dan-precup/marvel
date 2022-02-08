//
//  UIView+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

extension UIView {
    
    static func spacer(_ axis: NSLayoutConstraint.Axis, bgColor: UIColor = .systemBackground) -> UIView {
        let view = UIView()
            .background(bgColor)
        view.setContentCompressionResistancePriority(.required, for: axis)
        return view
    }
    
    static func line(ofColor: UIColor = .separator) -> UIView {
        UIView().constrained().background(ofColor)
    }
    
    @discardableResult
    func identifier(_ id: String) -> Self {
        accessibilityIdentifier = id
        return self
    }
    
    @discardableResult
    func background(_ color: UIColor = .systemBackground) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func opacity(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    
    @discardableResult
    func constrained() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func addAsSubview(of view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
    
    @discardableResult
    func addAndPinAsSubview(of view: UIView, padding: CGFloat = 0) -> Self {
        return addAndPinAsSubview(of: view, horizontalPadding: padding, verticalPadding: padding)
    }
    
    @discardableResult
    func addAndPinAsSubview(of view: UIView, horizontalPadding padding: CGFloat = 0, verticalPadding vPadding: CGFloat = 0) -> Self {
        constrained()
            .addAsSubview(of: view)
            .pin(to: view, horizontalPadding: padding, verticalPadding: vPadding)
        return self
    }
    
    @discardableResult
    func addAndPinAsSubview(to view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        constrained()
            .addAsSubview(of: view)
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        return self
    }
    
    @discardableResult
    func pin(to view: UILayoutGuide, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        return self
    }
    
    @discardableResult
    func pin(to view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        return self
    }
    
    @discardableResult
    func pin(to view: UIView, horizontalPadding padding: CGFloat = 0, verticalPadding vPadding: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: vPadding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -vPadding).isActive = true
        return self
    }
    
    @discardableResult
    func pinHorizontaly(to view: UIView, padding: CGFloat = 0) -> Self {
        return pinHorizontaly(to: view, leadingMargin: padding, trailingMargin: -padding)
    }
    
    @discardableResult
    func pinHorizontaly(to view: UIView, leadingMargin: CGFloat = 0, trailingMargin: CGFloat = 0) -> Self {
        return leading(to: view, constant: leadingMargin)
            .trailing(to: view, constant: trailingMargin)
    }
    
    @discardableResult
    func pinVerticaly(to view: UIView, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        return self.top(to: view, constant: top)
            .bottom(to: view, constant: bottom)
    }
    
    
    @discardableResult
    func pinHorizontaly(toSafeAreaOf view: UIView, padding: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func pinToBottom(of view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        return self
    }
    
    @discardableResult
    func pinToTop(toSafeAreaOf view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
        return self
    }
    
    @discardableResult
    func topTrailingCorner(to view: UIView, top: CGFloat = 0, trailing: CGFloat = 0) -> Self {
        self.trailing(to: view, constant: trailing)
         .top(toSafeAreaOf: view, constant: top)
    }
    
    
    @discardableResult
    func minWidth(_ value: CGFloat) -> Self {
        widthAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
        return self
    }
    
    @discardableResult
    func minHeight(_ value: CGFloat) -> Self {
        heightAnchor.constraint(greaterThanOrEqualToConstant: value).isActive = true
        return self
    }
    
    @discardableResult
    func wrapAndPin(padding: CGFloat = 0) -> UIView {
       return wrapAndPin(top: padding, bottom: -padding, leading: padding, trailing: -padding)
    }
    
    @discardableResult
    func wrapAndPin(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> UIView {
        let view = UIView()
        constrained()
            .addAsSubview(of: view)
            .top(to: view, constant: top)
            .bottom(to: view, constant: bottom)
            .leading(to: view, constant:leading)
            .trailing(to: view, constant: trailing)
        return view
    }
    
    @discardableResult
    func wrapAndPinToTop(top: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> UIView {
        let view = UIView()
        constrained()
            .addAsSubview(of: view)
            .top(to: view, constant: top)
            .leading(to: view, constant:leading)
            .trailing(to: view, constant: trailing)
        return view
    }
    
    @discardableResult
    func wrapAndPinToBottom(bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> UIView {
        let view = UIView()
        constrained()
            .addAsSubview(of: view)
            .bottom(to: view, constant: bottom)
            .leading(to: view, constant:leading)
            .trailing(to: view, constant: trailing)
        return view
    }
    
    @discardableResult
    func wrapAndCenterY(minHeight: CGFloat = 0) -> UIView {
        let view = UIView().minHeight(minHeight)
        constrained()
            .addAsSubview(of: view)
            .pinHorizontaly(to: view)
            .centerY(to: view)
        return view
    }
    
    @discardableResult
    func wrapAndCenterX(minWidth: CGFloat = 0) -> UIView {
        let view = UIView().minWidth(minWidth)
        constrained()
            .addAsSubview(of: view)
            .pin(to: view)
            .centerY(to: view)
        return view
    }
    
    @discardableResult
    func wrapAndCenterKeepingDimensions() -> UIView {
        let view = UIView()
        constrained()
            .addAsSubview(of: view)
        
        centerY(to: view)
            .centerX(to: view)
        
        return view
    }
    
    
    @discardableResult
    func centered(inView: UIView? = nil) -> Self {
        let superView: UIView
        if let inView = inView {
            superView = inView
        } else {
            guard let superview = superview else { return self }
            superView = superview
        }
        
        centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superView.centerYAnchor).isActive = true
        return self
    }
    
    
    @discardableResult
    func dimensions(width theWidth: CGFloat, height theHeight: CGFloat?) -> Self {
        width(theWidth)
        if let theHeight = theHeight {
            height(theHeight)
        } else {
            heightToWidth()
        }
        return self
    }
    
    @discardableResult
    func rounded(radius: CGFloat = 8) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult///Constrain the heightAnchor to the widthAnchor of the same view
    func heightToWidth(multiplier: CGFloat = 1) -> Self {
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier).isActive = true
        return self
    }
    
    @discardableResult
    func width(equalsTo view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Self {
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func width(percentFromSuperview multiplier: CGFloat = 1) -> Self {
        guard let superview = superview else { return self }
        return width(equalsTo: superview, multiplier: multiplier, constant: 0)
    }
    
    @discardableResult
    func height(equalsTo view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> Self {
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ constant: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leading(to view: UIView, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailing(to view: UIView, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailingToLeading(of view: UIView, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func top(toSafeAreaOf view: UIView, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func top(to view: UIView, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func topToBottom(of view: UIView, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(to view: UIView, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(toSafeAreaOf view: UIView, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottomToTop(of view: UIView, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerX(to view: UIView, constant: CGFloat = 0) -> Self {
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func centerY(to view: UIView, constant: CGFloat = 0) -> Self {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bordered(_ color: UIColor = .separator, borderWidth: CGFloat = 0.5) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    func unBordered() -> Self {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
        return self
    }
    
    @discardableResult
    func tinted(_ color: UIColor) -> Self {
       tintColor = color
        return self
    }
    
    @discardableResult
    func underlined(ofColor: UIColor = .separator) -> Self {
        UIView.line(ofColor: ofColor).constrained()
            .addAsSubview(of: self)
            .pinToBottom(of: self)
            .height(0.5)
        return self
    }
    
    @discardableResult
    func clipped() -> Self {
        clipsToBounds = true
        return self
    }
    
    @discardableResult
    func unclipped() -> Self {
        clipsToBounds = false
        return self
    }
    
    @discardableResult
    func circle() -> Self {
       layoutIfNeeded()
        return clipped().rounded(radius: frame.width / 2)
    }
    
    @discardableResult
      func shadow(_ radius: CGFloat = 5,
                  color: UIColor = .black,
                  shadowOpacity: Float = 0.4,
                  offset: CGSize = .zero) -> Self {
          layer.shadowRadius = radius
          layer.shadowColor = color.cgColor
          layer.shadowOpacity = shadowOpacity
          layer.shadowOffset = offset
          return self
      }
}

extension Array where Element: UIView {
    
    func vStack(alignment: UIStackView.Alignment = .fill,
                distribution: UIStackView.Distribution = .fill,
                spacing: CGFloat = UIConstants.spacing) -> UIStackView {
        return UIStackView.make(views: self,
                                axis: .vertical,
                                alignment: alignment,
                                distribution: distribution,
                                spacing: spacing)
    }
    
    func hStack(alignment: UIStackView.Alignment = .fill,
                distribution: UIStackView.Distribution = .fill,
                spacing: CGFloat = UIConstants.spacing) -> UIStackView {
        return UIStackView.make(views: self,
                                axis: .horizontal,
                                alignment: alignment,
                                distribution: distribution,
                                spacing: spacing)
    }
}

