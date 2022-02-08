//
//  Coordinatable.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 03/02/2022.
//

import UIKit

protocol Coordinatable: AnyObject {
    var navigationController: UINavigationController { get }
    func baseViewController() -> UIViewController?
    func push(_ viewController: UIViewController)
    func push(_ viewController: UIViewController, animated: Bool)
    func push(_ viewController: UIViewController, animated: Bool, title: String?)
    func present(_ viewController: UIViewController)
    func present(_ viewController: UIViewController, presentationStyle: UIModalPresentationStyle, animated: Bool)
    func dismiss()
    func dismiss(completion: (() -> Void)?)
}
