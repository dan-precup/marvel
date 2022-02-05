//
//  UITableView+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

extension UITableView {
    
    /// Set an empty label in the table
    /// - Parameter text: The text
    func setEmptyViewText(_ text: String = "No transactions yet") {
        backgroundView = UILabel.make(text, color: .tertiaryLabel)
            .textCentered()
            .font(.systemFont(ofSize: 20, weight: .semibold))
        
        backgroundView?.isHidden = true
    }
    
    /// Show empty text based on a given count
    /// - Parameter count: The count
    func setEmptyViewIfNeededFor(count: Int) {
        backgroundView?.isHidden = count > 0
    }
}
