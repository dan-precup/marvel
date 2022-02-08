//
//  HeroPresentationTansitionManager.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 07/02/2022.
//

import UIKit

final class HeroPresentationTansitionManager: NSObject {
    private struct Constants {
        static let contractionScale: CGFloat = 0.95
        static let mainAnimationDuration: TimeInterval = 0.6
        static let contractionDuration: TimeInterval = 0.2
        static let dampingRatio: CGFloat = 0.7
        static let initialVelocity = CGVector(dx: 0, dy: 4)
        static let targetCloseButtonTopConstraint: CGFloat = 50
        static let initialCloseButtonTopConstraint: CGFloat = -100
        static let initialCloseButtonTrailingConstraint: CGFloat = 200

    }

    private var isPresenting = true
    private let extendableBackgroundView = UIView()
    private var closeButtonTrailingConstraint: NSLayoutConstraint?
    private var closeButtonTopConstraint: NSLayoutConstraint?
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
}

extension HeroPresentationTansitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        Constants.mainAnimationDuration + Constants.contractionDuration
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: .from)
        let toView = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        // get a reference to the original card and the card hero
        guard let cardsTableView = isPresenting ? getHeroList(from: fromView) : getHeroList(from: toView),
              let originCardView = cardsTableView.getSelectedHeroCard(),
              let cardHero = originCardView.hero
        else { return }
        
        let relativeFrame = originCardView.convert(originCardView.frame, to: nil)
        
        //add the background view to the stack
        addExtendableBackground(containerView)
        
        // add the actual view to the stack
        if isPresenting, let view = toView?.view {
            toView?.view.isHidden = true
            blurView.alpha = 0
            blurView.addAndPinAsSubview(of: containerView)
            containerView.addSubview(view)
        }
        
        // setup the new card
        let newCard = HeroCardView()
        newCard.setHero(cardHero)
        newCard.setExpansionStatus(expand: !isPresenting)
        containerView.addSubview(newCard)
        newCard.frame = isPresenting ? relativeFrame : CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        originCardView.isHidden = true
        
        let closeButton = addCloseButton(to: newCard)
        
        containerView.layoutIfNeeded()
        animateTransition(for: newCard,
                             to: isPresenting ? .zero : relativeFrame.origin,
                             closeButton: closeButton,
                             with: {
            if self.isPresenting {
                toView?.view.isHidden = false
                newCard.isHidden = true
                originCardView.isHidden = false
                transitionContext.completeTransition(true)
                self.extendableBackgroundView.alpha = 0
            } else {
                newCard.isHidden = true
                originCardView.isHidden = false
                self.extendableBackgroundView.isHidden = true
                transitionContext.completeTransition(true)
            }
        })
        
    }
    
    /// Configure a background viw
    /// - Parameter containerView: The parent view
    private func addExtendableBackground(_ containerView: UIView) {
        extendableBackgroundView.background(isPresenting ? .systemBackground : .systemGroupedBackground)
        extendableBackgroundView.alpha = isPresenting ? 0 : 1
        extendableBackgroundView.isHidden = false
        containerView.addSubview(extendableBackgroundView)
        extendableBackgroundView.frame = UIScreen.main.bounds
    }
    
    /// Creates and adds a button to a view
    /// - Parameter view: The parent view
    /// - Returns: Returns a reference to the button
    private func addCloseButton(to view: UIView) -> UIButton {
        let closeButton = UIButton()
        closeButton
            .opacity(0)
            .tinted(.white)
            .addAsSubview(of: view)
            .constrained()
            .setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButtonTrailingConstraint = closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                              constant: Constants.initialCloseButtonTrailingConstraint)
        closeButtonTrailingConstraint?.isActive = true
        closeButtonTopConstraint = closeButton.topAnchor.constraint(equalTo: view.topAnchor,
                                                                    constant: Constants.initialCloseButtonTopConstraint)
        closeButtonTopConstraint?.isActive = true
        return closeButton
    }
    
    
    /// Runs the sequence of animators
    /// - Parameters:
    ///   - cardView: The card view
    ///   - finalOrigin: The origin destination point
    ///   - closeButton: The close button
    ///   - completion: And a completion handler
    private func animateTransition(for cardView: HeroCardView, to finalOrigin: CGPoint, closeButton: UIButton, with completion: @escaping () -> ()) {
        
        let contractionAnimator = makeContractionAnimator(cardView: cardView)
        let mainAnimator = makeMainAnimator(cardView: cardView,
                                            backgroundView: extendableBackgroundView,
                                            forPresenting: isPresenting,
                                            closeButton: closeButton,
                                            finalOrigin: finalOrigin)
        
        mainAnimator.addCompletion({ _ in
            completion()
        })
        
        contractionAnimator.addCompletion({ _ in
            mainAnimator.startAnimation()
        })
        
        contractionAnimator.startAnimation()
    }
    
    /// Makes the small contraction animation at the begining of the transition
    /// - Parameter cardView: The card view
    /// - Returns: The animator
    private func makeContractionAnimator(cardView: HeroCardView) -> UIViewPropertyAnimator {
        UIViewPropertyAnimator(duration: Constants.contractionDuration, curve: .easeOut) {
            cardView.transform = CGAffineTransform(scaleX: Constants.contractionScale, y: Constants.contractionScale)
        }
    }
    
    /// Create the main animator
    /// - Parameters:
    ///   - cardView: The cardview to animate
    ///   - backgroundView: The background view
    ///   - forPresenting: Flag if it's for presentation or dimissal
    ///   - closeButton: The close button
    ///   - finalOrigin: The the final origin point
    /// - Returns: The animator
    private func makeMainAnimator(cardView: HeroCardView,
                                  backgroundView: UIView,
                                  forPresenting: Bool,
                                  closeButton: UIButton,
                                  finalOrigin: CGPoint) -> UIViewPropertyAnimator {
        
        let springTiming = UISpringTimingParameters(dampingRatio: Constants.dampingRatio,
                                                    initialVelocity: Constants.initialVelocity)
        let animator = UIViewPropertyAnimator(duration: Constants.mainAnimationDuration,
                                              timingParameters: springTiming)
        animator.addAnimations {
            cardView.transform = .identity
            if forPresenting {
                cardView.expand()
                backgroundView.alpha = 1
                self.closeButtonTrailingConstraint?.constant = -UIConstants.spacingTripe
                self.closeButtonTopConstraint?.constant = Constants.targetCloseButtonTopConstraint
                self.blurView.alpha = 1
                closeButton.alpha = 1
                cardView.layoutIfNeeded()
            } else {
                self.closeButtonTrailingConstraint?.constant = Constants.initialCloseButtonTrailingConstraint
                self.closeButtonTopConstraint?.constant = Constants.initialCloseButtonTopConstraint
                closeButton.alpha = 0
                self.blurView.alpha = 0
                cardView.contract()
                backgroundView.alpha = 0
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
