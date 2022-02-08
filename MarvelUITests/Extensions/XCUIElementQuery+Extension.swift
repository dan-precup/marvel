//
//  XCUIElementQuery+Extension.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//


import XCTest

extension XCUIElementQuery {

    func containText(_ text: String) -> Bool {
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", text)
        return containing(predicate).count > 0
    }
}
