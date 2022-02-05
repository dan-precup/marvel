//
//  HeroListCoordinator.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation

final class HeroListCoordinatorImpl: BaseCoordinator, SearchViewCoordinator {
    
    /// Start the coordinator
    func start() {
        let model = HeroListViewModelImpl(coordinator: self)
        let view = HeroListViewController(viewModel: model)
        setController(view)
    }
}
extension HeroListCoordinatorImpl: HeroListCoordinator {
    
    func presentSearch() {
        let model = SearchViewModelImpl(coordinator: self)
        let view = SearchViewController(viewModel: model)
        present(view, presentationStyle: .overCurrentContext)
    }
}
