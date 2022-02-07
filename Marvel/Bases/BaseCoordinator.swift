//
//  BaseCoordinator.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import UIKit

class BaseCoordinator: Coordinatable {
    let navigationController: UINavigationController

    init(_ navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }
    
    /// Set the base controller in a coordinator
    /// - Parameters:
    ///   - viewController: The base controller
    ///   - animated: Animated flag
    ///   - title: The title
    func setController(_ viewController: UIViewController, animated: Bool = true, title: String? = nil) {
        setControllers([viewController], animated: animated)
        if let title = title {
            viewController.title = title
        }
    }
    
    /// Set a controller structure
    /// - Parameters:
    ///   - viewControllers: The controller structure
    ///   - animated: Animated flag
    func setControllers(_ viewControllers: [UIViewController], animated: Bool = true) {
        navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    /// Get the coordinator underlying base
    /// - Returns: The base controller - usually a navigation controller
    func baseViewController() -> UIViewController? {
        navigationController
    }
    
    /// Push to a view controller
    /// - Parameter viewController: The view controller
    func push(_ viewController: UIViewController) {
        push(viewController, animated: true, title: nil)
    }
    
    /// Push to a view controller with the animation flag
    /// - Parameters:
    ///   - viewController: The view controller
    ///   - animated: Animation flag
    func push(_ viewController: UIViewController, animated: Bool) {
        push(viewController, animated: animated, title: nil)
    }
    
    /// Push to a view controller with the animation flag
    /// - Parameters:
    ///   - viewController: The view controller
    ///   - animated: Animation flag
    ///   - title: The vc title
    func push(_ viewController: UIViewController, animated: Bool, title: String?) {
        navigationController.pushViewController(viewController, animated: animated)
        if let title = title {
            viewController.title = title
        }
    }
    
    /// Present a viewController
    /// - Parameter viewController: The view controller
    func present(_ viewController: UIViewController) {
        present(viewController, presentationStyle: .fullScreen, animated: false)
    }
    
    /// Present a viewController
    /// - Parameters:
    ///   - viewController: The view controller
    ///   - presentationStyle: The presentation style
    func present(_ viewController: UIViewController, presentationStyle: UIModalPresentationStyle, animated: Bool) {
        viewController.modalPresentationStyle = presentationStyle
        navigationController.present(viewController, animated: animated)
    }
    
    /// Dismiss a view controller
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    
    /// Dismiss a view controller and run a completion afterwards
    /// - Parameter completion: The completion to run
    func dismiss(completion: (() -> Void)?) {
        navigationController.dismiss(animated: true, completion: completion)
    }
}
