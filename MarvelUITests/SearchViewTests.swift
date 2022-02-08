//
//  SearchViewTests.swift
//  MarvelUITests
//
//  Created by Precup Aurel Dan on 08/02/2022.
//

import XCTest

class SearchViewTests: XCTestCase {

    private lazy var app = app()

    override func tearDown() {
          app.launchArguments.removeAll()
          addDebugDescriptionAttachment(app)
          super.tearDown()
      }

    func testSearchWithNoResultsShowNoResultsMessage() {
        app.launch(with: [.noHeros])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndTapButton("trailingSearchButton")
            .iWaitAndSeeTextField(identifier: "searchTextField")
            .iType("Iron", inTextFieldWithIdentifier: "searchTextField")
            .iWaitAndSeeString("No results yet")
    }
    
    func testCloseButtonDimissesView() {
        app.launch(with: [.noHeros])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndTapButton("trailingSearchButton")
            .iWaitAndTapButton("closeButton")
            .iWaitAndSeeString("Marvel Heros")
    }
    
    func testSelectingASearchResultNavigatatesToTheHeroDetailsView() {
        app.launch(with: [.heroes])
            .iSeeNavTitleIs("Marvel Heros")
            .iWaitAndTapButton("trailingSearchButton")
            .iType("Iron", inTextFieldWithIdentifier: "searchTextField")
            .iWaitAndSeeString("Iron Man")
            .iTapOnString("Iron Man")
            .iWaitAndSeeString("Iron Man")
            .iSeeString("About")
    }
}
