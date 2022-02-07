//
//  HeroCell.swift
//  Marvel
//
//  Created by Precup Aurel Dan on 04/02/2022.
//

import SDWebImage
import UIKit

class HeroCell: UITableViewCell {
   
    let cardView = HeroCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.tinted(.white)
        selectionStyle = .none
        cardView.addAndPinAsSubview(of: contentView)
    }
    
    /// Populate the cell with data
    /// - Parameter hero: The hero
    func setHero(_ hero: Hero) {
        cardView.setHero(hero)
    }
}
