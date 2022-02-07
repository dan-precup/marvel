//
//  HeroDetailsViewModel.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 06/02/2022.
//

import Foundation
import Combine

enum HeroDetailsCells {
    case imageAndName(Hero)
    case stats(Hero)
    case description(String)
    case title(String)
    case comic(Comic)
}

protocol HeroDetailsViewModel: LoadingNotifier, ViewLoadedListener {
    var cells: CurrentValueSubject<[HeroDetailsCells], Never> { get }
}

final class HeroDetailsViewModelImpl: BaseViewModel, HeroDetailsViewModel {
    
    /// Cells container
    let cells = CurrentValueSubject<[HeroDetailsCells], Never>([])
    
    /// The coordinator
    private let coordinator: Coordinatable
    
    /// The hero
    private let hero: Hero
    
    /// The marvel service
    private let marvelService: MarvelService
    /// Current page
    private var currentPage = -1
    
    /// The max number of items requested per page
    private let maxPerPage = 5
    
    /// Flag for signaling if we can load a new page
    private var hasNextPage = true

    init(coordinator: Coordinatable, hero: Hero, marvelService: MarvelService = ServiceRegistry.shared.marvelService) {
        self.hero = hero
        self.marvelService = marvelService
        self.coordinator = coordinator
        super.init()
    }
    
    func didFinishLoading() {
        var feed: [HeroDetailsCells] = [
            .imageAndName(hero),
            .title("Stats"),
            .stats(hero)
        ]
        
        feed.append(.title("About"))
        feed.append(.description(!hero.description.isEmpty ? hero.description : "🚨 🚨 🚨 Redacted 🚨 🚨 🚨"))
        
        cells.value = feed
        loadNextPageIfPossible()
    }
    
    /// Load the next page if we haven't reached the end of the list
    func loadNextPageIfPossible() {
        guard hasNextPage, !isLoading.value else { return }
        currentPage += 1
        isLoading.value = true
        let shouldAddTitle = currentPage == 0
        handlePublisher(marvelService.getComics(with: hero, page: currentPage, perPage: maxPerPage), completion: { [weak self] pagedComics in
            var comicsCells: [HeroDetailsCells] = shouldAddTitle ? [.title("Comics")] : []
            comicsCells.append(contentsOf: pagedComics.results.map({ .comic($0) }))
            self?.cells.value.append(contentsOf: comicsCells)
            self?.hasNextPage = pagedComics.hasNextPage
            self?.isLoading.value = false
        })
    }
    
}

