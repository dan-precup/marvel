//
//  UILabel+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

extension UILabel {
    
    static func make(_ text: String = "", weight: UIFont.Weight = .regular, size: CGFloat = 16, color: UIColor = .label, numberOfLines: Int = 0) -> UILabel {
        return UILabel(frame: .zero).text(text)
            .font(UIFont.systemFont(ofSize: size, weight: weight))
            .color(color)
            .lines(numberOfLines)
    }
    
    @discardableResult
    func shrinkToFit(minScale: CGFloat = 0.2) -> Self {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = minScale
        return self
    }
    
    @discardableResult
    func truncateToFit() -> Self {
        adjustsFontSizeToFitWidth = false
        lineBreakMode = .byTruncatingTail
        return self
    }
    
    @discardableResult
    func lines(_ lines: Int) -> Self {
        numberOfLines = lines
        return self
    }

    @discardableResult
    func textCentered() -> Self {
        return align(.center)
    }

    @discardableResult
    func align(_ alignment: NSTextAlignment) -> Self {
        textAlignment = alignment
        return self
    }

    @discardableResult
    func textOrHide(_ text: String?) -> Self {
        self.text = text
        isHidden = text == nil
        return self
    }

    @discardableResult
    func text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    func textStyle(_ style: UIFont.TextStyle) -> Self {
        return font(UIFont.preferredFont(forTextStyle: style))

    }

    @discardableResult
    func font(_ font: UIFont) -> Self {
        self.font = font
        return self
    }

    @discardableResult
    func color(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }

    @discardableResult
    func textShadow(_ color: UIColor = .darkText) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 1
        return self
    }
    
}

