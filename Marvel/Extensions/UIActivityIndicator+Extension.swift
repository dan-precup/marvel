//
//  UIActivityIndicator+Extension.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 05/02/2022.
//

import Combine
import UIKit

extension UIActivityIndicatorView {
    
    static func make(started: Bool) -> UIActivityIndicatorView {
       let spinner = UIActivityIndicatorView()
       spinner.hidesWhenStopped = true
        if started {
            spinner.startAnimating()
        }
        return spinner
    }
    
    /// Links a notifier to a view's visibility
    /// - Parameter notifier: The notifier
    func visibilityBindedTo(_ notifier: LoadingNotifier, storedIn: inout Set<AnyCancellable>) {
        notifier.isLoading.receive(on: DispatchQueue.main).share().sink(receiveValue: { [weak self] isLoading in
            guard self?.isAnimating != isLoading else { return }
            if isLoading {
                self?.startAnimating()
            } else {
                self?.stopAnimating()
            }
        }).store(in: &storedIn)
    }
}
