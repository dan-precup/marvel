//
//  HeroNavigatable.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import Foundation

protocol HeroNavigatable {
    func pushToHero(_ hero: Hero)
}
extension HeroNavigatable where Self: Coordinatable {
    func pushToHero(_ hero: Hero) {
        let model = HeroDetailsViewModelImpl(coordinator: self, hero: hero)
        let view = HeroDetailsViewController(viewModel: model)
        push(view)
    }
}
