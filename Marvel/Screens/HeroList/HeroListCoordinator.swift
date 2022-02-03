//
//  HeroListCoordinator.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation
final class HeroListCoordinatorImpl: BaseCoordinator, HeroListCoordinator {
    
    /// Start the coordinator
    func start() {
        let model = HeroListViewModelImpl(coordinator: self)
        let view = HeroListViewController(viewModel: model)
        setController(view)
    }
}
