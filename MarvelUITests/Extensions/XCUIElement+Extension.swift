//
//  XCUIElement+Extension.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

extension XCUIElement {

    /// Removes any current text in the field before typing in the new value
    /// - Parameter text: the text to enter into the field
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = stringValue.map { _ in "\u{8}" }.joined(separator: "")

        self.typeText(deleteString)
        self.typeText(text)
    }
}
