//
//  TitledIcon.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import UIKit

final class TitledIcon: UIView {
    private let imageView = UIImageView().fit()
    private let titleLabel = UILabel.make(size: 14, color: .white, numberOfLines: 1)
    
    init(imageSystemName: String) {
        super.init(frame: .zero)
        imageView.image = UIImage(systemName: imageSystemName)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        titleLabel.textCentered()
            .shrinkToFit()
        [imageView, titleLabel]
            .vStack(spacing: 0)
            .addAndPinAsSubview(of: self)
    }
    
    /// Set the value of the title
    /// - Parameter title: Text to set
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
