//
//  HeroPresentationTansitionManager.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import UIKit

final class HeroPresentationTansitionManager: NSObject {
    private let transitionDuration: TimeInterval = 0.8
    private let contractionDuration: TimeInterval = 0.2
    private var isPresenting = true
}

extension HeroPresentationTansitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        guard let cardsTableView = isPresenting ? getHeroList(from: fromView) : getHeroList(from: toView),
              let originCardView = cardsTableView.getSelectedHeroCard(),
              let cardHero = originCardView.hero
        else { return }
        
        let relativeFrame = originCardView.convert(originCardView.frame, to: nil)
        let newCard = HeroCardView(frame: relativeFrame)
        newCard.setHero(cardHero)
        containerView.addSubview(newCard)
        
        transitionContext.completeTransition(true)
    }
    
    private func getHeroList(from contextView: UIViewController?) -> HeroListViewController? {
        (contextView as? UINavigationController)?.topViewController as? HeroListViewController
    }
    
}

extension HeroPresentationTansitionManager: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
