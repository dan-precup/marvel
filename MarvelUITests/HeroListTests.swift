//
//  HeroListTests.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

class HeroListTests: XCTestCase {
    private lazy var app = app()

    override func tearDown() {
          app.launchArguments.removeAll()
          addDebugDescriptionAttachment(app)
          super.tearDown()
      }
    
    func testNavigationTitle() {
        app.launch(with: []).iSeeNavTitleIs("Marvel Heros")
    }

    func testShowingHeroesList() {
        app.launch(with: [.heroes])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString("Iron Man")
            .iSeeImage("heroImage")
            .scrollDown()
            .iSeeString("Captain America")
    }
    
    
    func testTapingOnACardShowsTheHeroDetails() {
        app.launch(with: [.heroes])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString("Iron Man")
            .iTapOnString("Iron Man")
            .iWaitAndSeeString("Iron Man")
            .iSeeString("About")
    }
    
    func testTapOnSearchOpensTheSearchView() {
        app.launch(with: [])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndTapButton("trailingSearchButton")
            .iWaitAndSeeTextField(identifier: "searchTextField")
    }
    
    func testNoHeroesShowsEmptyMessage() {
        app.launch(with: [])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndSeeString(Constants.noResultsString)
    }
}

