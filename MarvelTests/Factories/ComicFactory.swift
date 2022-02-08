//
//  ComicFactory.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import Foundation
@testable import Marvel

final class ComicFactory {
    static func make(name: String = "The adventures of Iron Man",
                         issueNumber: Int = 5,
                         pageCount: Int = 5) -> Comic {
       Comic(id: 1, title: name,
             issueNumber: issueNumber,
             pageCount: pageCount,
             thumbnail: ImageResource(path: URL(string: "https://i.ytimg.com/vi/RcNS0VhQgy0/maxresdefault")!, fileExtension: "jpg"))
    }
}
