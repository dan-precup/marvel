//
//  HeroFactory.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import Foundation

final class HeroFactory {
    static func makeHero(name: String = "Iron Man",
                         description: String = "Some description",
                         comicsCount: Int = 5,
                         eventsCount: Int = 6,
                         seriesCount: Int = 7,
                         storiesCount: Int = 7) -> Hero {
        Hero(id: 1,
             name: name,
             description: description,
             thumbnail: ImageResource(path: URL(string: "https://i.ytimg.com/vi/RcNS0VhQgy0/maxresdefault")!, fileExtension: "jpg"),
             comics: CountableProperty(available: comicsCount),
             events: CountableProperty(available: eventsCount),
             series: CountableProperty(available: seriesCount),
             stories: CountableProperty(available: storiesCount))
    }
}
