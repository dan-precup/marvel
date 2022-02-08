//
//  MockHeroListCoordinator.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import Foundation
@testable import Marvel

final class MockHeroListCoordinator: BaseCoordinator, HeroNavigatable, HeroListCoordinator {
    var heroPresentationTansitionManager: HeroPresentationTansitionManager = HeroPresentationTansitionManager()
    
    var searchPresented = false
    var presentedHero = false
        
    func presentAnimatedHero(_ hero: Hero) {
        presentedHero = true
    }
    
    func presentSearch() {
        searchPresented = true
    }
}
