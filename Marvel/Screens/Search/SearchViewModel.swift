//
//  SearchViewModel.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import Foundation
import Combine

protocol SearchViewCoordinator: HeroNavigatable, Coordinatable {}

protocol SearchViewModel: LoadingNotifier {
    var results: CurrentValueSubject<[Hero], Never> { get }
    func didTypeSearchTerm(_ term: String)
    func didSelectHero(_ hero: Hero)
    func loadNextPageIfPossible()
}

final class SearchViewModelImpl: BaseViewModel, SearchViewModel {
    
    /// The results container
    let results = CurrentValueSubject<[Hero], Never>([])
    
    /// The coordinator
    private let coordinator: SearchViewCoordinator
    
    /// Marvel service
    private let marvelService: MarvelService
    
    /// Typing debounce timer
    private var timer: Timer?
    
    /// Cancellable container for the search request
    private var searchCancellable: AnyCancellable?
    
    /// Current page
    private var currentPage = -1
    
    /// The max number of items requested per page
    private let maxPerPage = 10
    
    /// Flag for signaling if we can load a new page
    private var hasNextPage = true
    
    /// The search term
    private var term = ""
    
    init(coordinator: SearchViewCoordinator, marvelService: MarvelService = ServiceRegistry.shared.marvelService) {
        self.coordinator = coordinator
        self.marvelService = marvelService
        super.init()
    }
    
    /// React to the user typing a search term
    /// - Parameter term: The term
    func didTypeSearchTerm(_ term: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] _ in
            self?.runSearch(on: term)
        })
    }
    
    /// Reset everything and run the search
    /// - Parameter term: The term
    private func runSearch(on term: String) {
        self.term = term
        currentPage = -1
        results.value = []
        hasNextPage = true
        searchCancellable?.cancel()
        loadNextPageIfPossible()
    }
    
    /// Load the next page if we haven't reached the end of the list
    func loadNextPageIfPossible() {
        guard !term.isEmpty, !isLoading.value, hasNextPage else { return }
        isLoading.value = true
        currentPage += 1
        searchCancellable = handlePublisherWithoutStoring(marvelService.searchForHero(nameStartingWith: term, page: currentPage, perPage: maxPerPage), completion: { [weak self] pagedResults in
            self?.results.value.append(contentsOf: pagedResults.results)
            self?.hasNextPage = pagedResults.hasNextPage
            self?.isLoading.value = false
        })
    }
    
    func didSelectHero(_ hero: Hero) {
        coordinator.dismiss()
        coordinator.pushToHero(hero)
    }
}

