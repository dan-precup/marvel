//
//  SearchResult.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import Foundation

enum SearchResultType {
    case character, comic
}

struct SearchResult {
    let imageURL: URL
    let name: String
    let type: SearchResultType
}

extension SearchResult {
    
    static func fromHero(_ hero: Hero) -> SearchResult {
        SearchResult(imageURL: hero.thumbnail.url, name: hero.name, type: .character)
    }
}
