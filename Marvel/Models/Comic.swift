//
//  Comic.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

struct Comic: Codable {
    let id: Int
    let title: String
    let issueNumber: Int
    let pageCount: Int
    let thumbnail: ImageResource
    let prices: [Price]
}
