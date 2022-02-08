//
//  XCUITest+Extension.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

extension XCTestCase {
    func addDebugDescriptionAttachment(_ app: XCUIApplication, file: StaticString = #file, preserveIfSuccessfull: Bool = false) {
         //saves debug description at the time of failed test
         let stringAttachment = XCTAttachment(string: app.debugDescription)
         stringAttachment.lifetime = !preserveIfSuccessfull ? .deleteOnSuccess : .keepAlways
        stringAttachment.name = file.description + ".txt"
        add(stringAttachment)
     }

    func addScreenshot(_ app: XCUIApplication, preserveIfSuccessfull: Bool) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = !preserveIfSuccessfull ? .deleteOnSuccess : .keepAlways
        add(attachment)
    }

}
