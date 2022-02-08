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
}
extension Comic: Equatable {
    static func == (lhs: Comic, rhs: Comic) -> Bool {
        return lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.issueNumber == rhs.issueNumber &&
        lhs.pageCount == rhs.pageCount
    }
}
