//
//  XCTestCase+Extesnion.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

extension XCTestCase {
    
    func app(flags: [HeroMockFlag] = []) -> XCUIApplication {
        XCUIApplication.new(arguments: flags.map({$0.rawValue}))
    }

}
