//
//  HeroListViewModel.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import Foundation
import Combine

protocol HeroListCoordinator: Coordinatable {}
protocol HeroListViewModel: LoadingNotifier, ViewLoadedListener { }

final class HeroListViewModelImpl: BaseViewModel, HeroListViewModel {
    
    private let coordinator: HeroListCoordinator
    init(coordinator: HeroListCoordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    func didFinishLoading() {
        
    }
}

