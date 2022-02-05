//
//  UIImageView+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

extension UIImageView {
    
    static func withSystemName(_ name: String) -> UIImageView {
        UIImageView(image: UIImage(systemName: name))
    }
    
    @discardableResult
    func fit() -> Self {
        contentMode = .scaleAspectFit
        return self
    }

    @discardableResult
    func fill() -> Self {
        contentMode = .scaleAspectFill
        return self
    }
    
}
