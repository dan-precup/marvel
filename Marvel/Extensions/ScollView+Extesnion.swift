//
//  ScollView+Extesnion.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

extension UIScrollView {
    
    /// Test if the scroll view is about to reach the end of the content offset
    /// - Parameter aboveEnd: Deduced from the content size to reach end sooner, eg: trigger something with 100px before reaching the scroll end
    /// - Returns: Bool
    func isReachingEnd(aboveEnd: CGFloat = 100) -> Bool {
        let contentHeight = contentSize.height - aboveEnd
        guard contentOffset.y > contentHeight - frame.height else { return  false }
        return true
    }
}
