//
//  Collection+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import Foundation

extension Collection {
    // Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
