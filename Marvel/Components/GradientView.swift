//
//  GradientView.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

final class GradientView: UIView {
    
    /// The colors of the gradient
    private let colors: [CGColor]
    
    /// The location coordinates
    private let locations: [NSNumber]
    
    init(colors: [CGColor] =  [UIColor.black.withAlphaComponent(0).cgColor,
                               UIColor.black.cgColor],
         locations: [NSNumber] = [0, 1]) {
        self.colors = colors
        self.locations = locations
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Prepare the gradient layer
    private func setupUI() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        guard let gradientLayer = layer as? CAGradientLayer else {
            return;
        }

        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.frame = bounds
    }

    
    /// Override the layer class
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
