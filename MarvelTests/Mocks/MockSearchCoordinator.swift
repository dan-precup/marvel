//
//  MockHeroNavigatableCoordinator.swift
//  MarvelTests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import Foundation
@testable import Marvel

final class MockSearchCoordinator: BaseCoordinator, SearchViewCoordinator {
  
    var heroPresentationTansitionManager: HeroPresentationTansitionManager = HeroPresentationTansitionManager()
    
    var didPushToHero = false
    var dismissed = false
    
    override func dismiss() {
        dismissed = true
    }
    
    func pushToHero(_ hero: Hero) {
        didPushToHero = true
    }
}
