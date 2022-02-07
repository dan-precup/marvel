//
//  HeroPresentationTansitionManager.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import UIKit

final class HeroPresentationTansitionManager: NSObject {
    private let mainAnimationDuration: TimeInterval = 0.6
    private let contractionDuration: TimeInterval = 0.2
    private var isPresenting = true
}

extension HeroPresentationTansitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        mainAnimationDuration + contractionDuration
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
        let newCard = HeroCardView()
        newCard.setHero(cardHero)
        containerView.addSubview(newCard)
        newCard.frame = relativeFrame
        toView?.view.isHidden = true
        if let view = toView?.view {
            containerView.addSubview(view)
        }
        
        animateTransition(for: newCard,
                             to: isPresenting ? .zero : relativeFrame.origin,
                             with: {
            newCard.isHidden = true
            toView?.view.isHidden = false
            transitionContext.completeTransition(true)
        })
        
//        if isPresenting {
//        newCard.frame = relativeFrame
//        UIView.animate(withDuration: 0.8, animations: {
//            newCard.expand()
//            newCard.frame.origin = .zero
//        })
//
//        } else {
//            newCard.frame = .zero
//            UIView.animate(withDuration: 0.8, animations: {
//                newCard.contract()
//                newCard.frame.origin = relativeFrame.origin
//
//            })
//        }
        
        transitionContext.completeTransition(true)
    }
    
    private func animateTransition(for cardView: HeroCardView, to finalOrigin: CGPoint, with completion: @escaping () -> ()) {
        
        let contractionAnimator = makeContractionAnimator(cardView: cardView)
        let mainAnimator = makeMainAnimator(cardView: cardView, forPresenting: isPresenting, finalOrigin: finalOrigin)
        
        mainAnimator.addCompletion({ _ in
            completion()
        })
        
        contractionAnimator.addCompletion({ _ in
            mainAnimator.startAnimation()
        })
        
        contractionAnimator.startAnimation()
    }
    
    private func makeContractionAnimator(cardView: HeroCardView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: contractionDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func makeMainAnimator(cardView: HeroCardView, forPresenting: Bool, finalOrigin: CGPoint) -> UIViewPropertyAnimator {
        let springTiming = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: CGVector(dx: 0, dy: 5))
        let animator = UIViewPropertyAnimator(duration: mainAnimationDuration, timingParameters: springTiming)
        animator.addAnimations {
            cardView.transform = .identity
            if forPresenting {
                cardView.expand()
            } else {
                cardView.contract()
            }
            
            cardView.frame.origin = finalOrigin
        }
        
        return animator
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
