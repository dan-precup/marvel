//
//  HeroListViewModel.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation
import Combine

protocol HeroListCoordinator: Coordinatable, HeroNavigatable {
    func presentSearch()
}
protocol HeroListViewModel: LoadingNotifier, ViewLoadedListener {
    var heroes: CurrentValueSubject<[Hero], Never> { get }
    func loadNextPageIfPossible()
    func didSelectHero(_ hero: Hero)
    func didSelectSearch()
}

final class HeroListViewModelImpl: BaseViewModel, HeroListViewModel {
    
    /// The hero list
    let heroes = CurrentValueSubject<[Hero], Never>([])
    
    /// Coordinator
    private let coordinator: HeroListCoordinator
    /// The marvel api service
    
    private let marvelService: MarvelService
    
    /// Current page
    private var currentPage = -1
    
    /// The max number of items requested per page
    private let maxPerPage = 10
    
    /// Flag for signaling if we can load a new page
    private var hasNextPage = true

    init(coordinator: HeroListCoordinator, marvelService: MarvelService = ServiceRegistry.shared.marvelService) {
        self.coordinator = coordinator
        self.marvelService = marvelService
        super.init()
    }
    
    func didFinishLoading() {
        loadNextPageIfPossible()
    }
    
    /// Load the next page if we haven't reached the end of the list
    func loadNextPageIfPossible() {
        guard hasNextPage, !isLoading.value else { return }
        currentPage += 1
        isLoading.value = true
        handlePublisher(marvelService.getHeroes(page: currentPage, perPage: maxPerPage), completion: { [weak self] pagedHeroes in
            self?.heroes.value = pagedHeroes.results
            self?.hasNextPage = pagedHeroes.hasNextPage
            self?.isLoading.value = false
        })
    }
    
    func didSelectHero(_ hero: Hero) {
        coordinator.pushToHero(hero)
    }
    
    func didSelectSearch() {
        coordinator.presentSearch()
    }
}

