//
//  HeroDetailsViewTests.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

class HeroDetailsViewTests: XCTestCase {
    
    private lazy var app = app()

    override func tearDown() {
          app.launchArguments.removeAll()
          addDebugDescriptionAttachment(app)
          super.tearDown()
      }
    
    func testDetailsSeesRequiredElements() {
        app.launch(with: [.heroes])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString("Iron Man")
            .iTapOnString("Iron Man")
            .iWaitAndSeeString("Iron Man")
            .iSeeStrings(["Stats", "Events", "Stories", "Comics","About", "Some description"])
            .buttonExists("closeButton")
            .checkValueInLabel("comicsValue", value: "5")
            .checkValueInLabel("eventsValue", value: "6")
            .checkValueInLabel("storiesValue", value: "7")
            .checkValueInLabel("sectionTitleLabel", value: "Comics")

    }
    
    func testDetailsHeroWithNoDescriptionGetsTheRedactedStringInstead() {
        app.launch(with: [.heroNoDescription])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString("Iron Man")
            .iTapOnString("Iron Man")
            .iWaitAndSeeString("Iron Man")
            .checkValueInLabel("largeTextLabel", value: "🚨 🚨 🚨 Redacted 🚨 🚨 🚨")
    }
    
    func testDetailsHeroWithNoComicsDoesntSeeTheComicsTitle() {
        app.launch(with: [.heroes])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString("Iron Man")
            .iTapOnString("Iron Man")
            .iWaitAndSeeString("Iron Man")
            .iSeeStrings(["Stats", "Events", "Stories", "Comics","About", "Some description", "Comics"])
            .checkValueInLabel("comicsValue", value: "5")
            .checkValueInLabel("eventsValue", value: "6")
            .checkValueInLabel("storiesValue", value: "7")
            .valueInLabelDoesNotExist("valueInLabelDoesNotExist", value: "Comics")

    }
}
