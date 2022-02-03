//
//  DataContainer.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct DataContainer<T:Codable>: Codable {
    let data: T
}
